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

    public let clientId: String
    public let clientSecret: String
    public let scope: String

    public func hashedString() -> String {
        return "\(clientId):\(clientSecret):\(scope)".sha512()
    }
}
