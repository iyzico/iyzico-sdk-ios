//
//  LogManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 10.02.2021.
//

import Foundation

class LogManager {
    
    static func printLogWithTemplate(log: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstant.IyzicoLog.iyzicoDateFormat
        let dateString = dateFormatter.string(from: Date())
        print("💡[\(dateString)]-[Iyzico]: \(log)")
    }
    
    static func printLogForIyzicoInternalMessage(state: InternalMessageState) {
        switch state {
        case .success:
            print("✅")
            printLogWithTemplate(log: state.message)
            print("✅")
        default:
            print("❌")
            printLogWithTemplate(log: "\nError Type: \(state) \nReason: \(state.message)")
            print("❌")
        }
    }
}
