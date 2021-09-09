//
//  Encodable+Extension.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 11.02.2021.
//

import Foundation

extension Encodable {
//    var asDictionary : [String:Any] {
//      let mirror = Mirror(reflecting: self)
//      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
//        guard let label = label else { return nil }
//        return (label, value)
//      }).compactMap { $0 })
//      return dict
//    }
    var asDictionaryWithoutNilValues: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var asDictionaryWithNilValues: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).map { ($0 as? [String: Any] ?? [:]) }
    }
    
    var asData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
