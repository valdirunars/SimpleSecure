//
//  CredentialMiddlewear.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 29/11/2016.
//
//

import Foundation
import Kitura
import SwiftyJSON


class SimpleCredentialMiddleware: RouterMiddleware {


    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        
        if (request.method == .post
                && request.urlComponents.path == SimpleOAuth2.authPath)
            ||  SimpleOAuth2.sharedInstance.isPublic(url: request.urlComponents.path) {
            
            next()
            return
        }
        
        
        guard let auth = request.headers["Authorization"] else {
            response.sendUnauthorized(message: "Authentication needed.", code: 1)
            return
        }
        
        let args = auth.components(separatedBy: " ")
        if (args.count != 2 ||
            (args.count > 0 && args[0] != "Bearer")) {
            response.sendUnauthorized(message: "Authentication needed.", code: 2)
        }
        
        let token = args[1]
        
        var authorized = false
        for auth in SimpleOAuth2.sharedInstance.authenticators.values {
            if auth.authorize(token: token) &&
                SimpleOAuth2.sharedInstance.isPath(request.urlComponents.path, authorizedIn: auth.scope) {
                authorized = true
                break
            }
        }
        
        if !authorized {
            response.sendUnauthorized(message: "Authentication needed.", code: 3)
            return
        }
                
        next()
    }

}
