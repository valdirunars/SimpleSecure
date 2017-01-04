//
//  JWTAuthenticator.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 30/11/2016.
//
//

import Foundation
import JWT

public enum MacAlgorithm {
    case none
    case hs256
    case hs384
    case hs512
    
    public func toAlgorithm(with secret: Data) -> Algorithm {
        switch self {
        case .hs512:
            return Algorithm.hs512(secret)
        case .hs384:
            return Algorithm.hs384(secret)
        case .hs256:
            return Algorithm.hs512(secret)
        case .none:
            return Algorithm.none
        }
    }
}
public class SimpleJWT {
    
    public static let tokenDuration: TimeInterval = 60 * 30 // 30 min
    
    private let issuer: String
    public let scope: String
    private let algorithm: Algorithm
    
    init(issuer: String, scope: String, using algorithm: MacAlgorithm, with secret: Data) {
        self.issuer = issuer
        self.scope = scope
        self.algorithm = algorithm.toAlgorithm(with: secret)
    }
    
    func encode(with secret: String, expiresIn: TimeInterval) -> String {
        let token = JWT.encode(self.algorithm) { builder in
            
            builder.issuer = issuer
            builder.issuedAt = Date()
            builder.expiration = Date().addingTimeInterval(expiresIn)
            builder["scope"] = self.scope
        }
        return token
    }
    
    
    func authorize(token: String) -> Bool {
        do {
            let payload = try JWT.decode(token, algorithm: self.algorithm)
            
            guard let iss = (payload["iss"] as? String) else {
                return false
            }
            
            guard let exp = (payload["exp"] as? TimeInterval) else {
                return false
            }
            
            guard let scp = (payload["scope"] as? String) else {
                return false
            }
            
            return Date().timeIntervalSince1970 < exp &&
                        iss == self.issuer &&
                        scp == self.scope
            
        } catch {
            print("Failed to decode JWT: \(error)")
        }
        return false
    }
    
}
