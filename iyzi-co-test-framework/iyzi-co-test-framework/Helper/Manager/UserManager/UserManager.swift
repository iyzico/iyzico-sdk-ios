//
//  UserManager.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 29.01.2021.
//

import Foundation

class UserManager {
    
    static let defaults = UserDefaults.standard
    
    static var userToken: String {
        return  defaults.string(forKey: "token") ?? "222"
    }
    
}
extension UserManager {
    
    static func setUser(token: String) {
        defaults.set(token, forKey: "token")
    }
}
