//
//  UserDefaultsManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

class DefaultsManager {
    private static let standard = UserDefaults.standard
    
    enum DefaultKeys: String {
        case accessToken = "accessToken"
    }
    
    static func set(value: Any?, forKey: DefaultKeys) {
        standard.set(value, forKey: forKey.rawValue)
    }
    
    static func get<T>(forKey: DefaultKeys, type: T.Type) -> T? {
        return standard.object(forKey: forKey.rawValue) as? T
    }
}
