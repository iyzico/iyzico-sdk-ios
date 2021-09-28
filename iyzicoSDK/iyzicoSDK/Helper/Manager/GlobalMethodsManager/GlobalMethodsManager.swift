//
//  GlobalMethodsManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 10.02.2021.
//

import Foundation

class GlobalMethodsManager {
    
    static func getSdkVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
        return appVersion
    }
    
    static func getOsVersion()  -> String {
        let os = ProcessInfo().operatingSystemVersion
        return "iOS - \(os.majorVersion)"
    }
}
