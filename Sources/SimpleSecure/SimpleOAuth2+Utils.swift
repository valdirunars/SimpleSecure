//
//  SimpleOAuth2+Utils.swift
//  SimpleOAuth2
//
//  Created by Þorvaldur Rúnarsson on 04/12/2016.
//
//

import Foundation


extension SimpleOAuth2 {
    public func isPublic(url: String) -> Bool {
        
        for path in self.publicPaths {
            
            let subPaths = path.components(separatedBy: "/")
            let urlSubPaths = url.components(separatedBy: "/")
            
            if (urlSubPaths.count > subPaths.count
                && subPaths[subPaths.count-1] != "*")
                || urlSubPaths.count < subPaths.count {
                continue
            }
            
            var success = true
            for i in 0 ..< subPaths.count {
                
                if !(subPaths[i] == urlSubPaths[i] || subPaths[i] == "*") {
                    success = false
                }
            }
            if (success) {
                return true
            }
            
        }
        
        return false
    }
    
    public func isPath(_ path: String, authorizedIn scope: String) -> Bool {
        if (self.restrictedPaths[path] == nil) {
            return true
        }
        
        let validScopes = self.restrictedPaths[path]!.components(separatedBy: ",")
        return validScopes.contains(scope)
    }
}
