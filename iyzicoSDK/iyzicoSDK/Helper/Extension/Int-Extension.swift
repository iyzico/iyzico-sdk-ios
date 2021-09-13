//
//  Int-Extension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 7.02.2021.
//

import Foundation

extension Int {
    
    func formatNumber(groupingSeparator: String = ".") -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = groupingSeparator
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
}
