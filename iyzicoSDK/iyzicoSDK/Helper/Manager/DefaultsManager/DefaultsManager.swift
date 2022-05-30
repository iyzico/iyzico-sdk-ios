//
//  UserDefaultsManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

class DefaultsManager {
    private static let standard = UserDefaults.standard
    
    public enum DefaultKeys: String {
        case accessToken = "accessToken"
        case cachedImages = "cachedImages"
    }
    
    static func set<T>(_ value: T, forKey: String) where T: Encodable {
        if let encoded = try? JSONEncoder().encode(value) {
            standard.set(encoded, forKey: forKey)
        }
    }
    
    static func get<T>(forKey: String) -> T? where T: Decodable {
        guard let data = standard.value(forKey: forKey) as? Data,
              let decodedData = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return decodedData
    }
}
