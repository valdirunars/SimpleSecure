//
//  RouterResponse+Fail.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 01/12/2016.
//
//

import Foundation
import Kitura
import SwiftyJSON

extension RouterResponse {
    public func sendBadRequest(message: String) {
        self.status(.badRequest)
        try? self.send(json: JSON([
            "errorMessage": message
            ])).end()
    }
    
    public func sendUnauthorized(message: String, code: Int) {
        self.status(.unauthorized)
        try? self.send(json: JSON([
            "errorMessage": message,
            "code": code
            ])).end()
    }
}
