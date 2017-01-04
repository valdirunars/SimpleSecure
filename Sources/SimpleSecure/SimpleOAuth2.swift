//
//  SimpleOAuth2.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 29/11/2016.
//
//

import Foundation
import Kitura
import SwiftyJSON
import JWT


public class SimpleOAuth2 {

    
    static let authPath = "/oauth2/authorize"
    
    public static var sharedInstance = SimpleOAuth2()

    private var authHashes = [String]()
    public var authenticators = [String:SimpleJWT]()
    
    /// Paths where no authentication is needed
    public var publicPaths: [String] = [String]()
    
    /// A dictionary where key represents a router path and value represents a comma seperated list scopes that the path is restricted to. If a path is not included in this path a request will only need to be authorized by any valid credential.
    public var restrictedPaths = [String:String]()


    /// Secures the routes of router with the specified credentials (clientId, clientSecret, scope), see SimpleOAuth2's scopes property for further info on scope validation
    public func simplySecure(router: Router, with credentials: [SimpleCredential]) {
        router.post(SimpleOAuth2.authPath, handler: SimpleOAuth2.authorize)

        for cred in credentials {
            let credHash = cred.hashedString()
            let auth = SimpleJWT(issuer: cred.clientId, scope: cred.scope, using: .hs512, with: cred.clientSecret.data(using: .utf8)!)
            
            SimpleOAuth2.sharedInstance.authenticators[credHash] = auth
            SimpleOAuth2.sharedInstance.authHashes.append(credHash)
        }
        
        router.all("/*", middleware: BodyParser())
        router.all("/*", middleware: SimpleCredentialMiddleware())
    }


    private static func authorize(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {

        
        // 1 READ PARAMETERS FROM REQUEST BODY
        var b: String?
        
        do {
            b = try request.readString()
        } catch {
            response.sendBadRequest(message: "No body. \(error)")
            return
        }

        guard let body = b else {
            response.sendBadRequest(message: "No body.")
            return
        }

        guard let params = extractParams(from: body) else {
            response.sendBadRequest(message: "Invalid body, use raw utf8 encoded JSON.")
            
            return
        }
        
        // 2 CREATE CREDENTIAL DATA FROM INPUT DATA
        guard let credential = extractCredentials(from: params) else {
            response.sendBadRequest(message: "Invalid parameters")
            
            return
        }
        
        let hash = credential.hashedString()
        
        // 3 CHECK IF CREDENTIALS EXIST IN APP
        var authorized = false
        for comparingHash in SimpleOAuth2.sharedInstance.authHashes {
            if (hash == comparingHash) {
                authorized = true
                break
            }

        }
        
        if (!authorized) {
            response.sendUnauthorized(message: "Invalid credentials.", code: 1)
            return
        }

        
        // 4 GET THE AUTHENTICATOR, CREATE A TOKEN AND SEND IT
        guard let authenticator = SimpleOAuth2.sharedInstance.authenticators[hash] else {
            response.sendUnauthorized(message: "Request unauthorized.", code: 2)
            return
        }
        
        let token = authenticator.encode(with: credential.clientId, expiresIn: SimpleJWT.tokenDuration)

        try? response.send(json: JSON([
            "token_type": "Bearer",
            "expires_in":"\(SimpleJWT.tokenDuration)", // 30 minutes
            "access_token": token
        ])).end()


    }
    
    private static func extractCredentials(from params: [String:Any]) -> SimpleCredential? {
        guard let clientId = params["client_id"] as? String else {
            
            return nil
        }
        guard let clientSecret = params["client_secret"] as? String else {
            
            return nil
        }
        
        guard let grant = params["grant_type"] as? String else {
            
            return nil
        }
        
        guard let scope = params["scope"] as? String else {
            return nil
        }
        
        if (grant != "client_credentials") {
            
            return nil
        }
        
        return SimpleCredential(clientId: clientId,
                         clientSecret: clientSecret,
                         scope: scope)
    }

    private static func extractParams(from body: String) -> [String: String]? {
        guard let jsonData = body.data(using: .utf8) else {
            return nil
        }
        let json = JSON(data: jsonData)
        var params = [String: String]()

        for (key, object) in json {
            params[key as String] = object.stringValue
        }
        return params

    }


}
