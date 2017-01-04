//
//  SimpleCredential.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 29/11/2016.
//
//

import Foundation
import CryptoSwift

public struct SimpleCredential {
    
    let clientId: String
    let clientSecret: String
    let scope: String
    
    func hashedString() -> String {
        return "\(clientId):\(clientSecret):\(scope)".sha512()
    }
}
