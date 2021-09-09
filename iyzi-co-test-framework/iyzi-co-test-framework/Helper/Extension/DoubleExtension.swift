//
//  StringExtension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 10.12.2020.
//

import Foundation
import UIKit

extension Double {
    
    var addTL: String {
        return "₺\(self)"
    }
    
    var asString: String {
        return String(format: "%.2f", self)
    }
    
    func addTLWithAlignment(alignment: NSTextAlignment) -> String {
        switch alignment {
        case .left:
            return doubleFormatter.string(from: NSNumber(value: self))?.addTL.replacingOccurrences(of: ".", with: ",") ?? ""
        case .right:
            return (doubleFormatter.string(from: NSNumber(value: self))?.replacingOccurrences(of: ".", with: ",") ?? "") + "₺"
        default:
            return ""
        }
    }
    
    var addTLTextWithSpace: String {
        return "\(doubleFormatter.string(from: NSNumber(value: self)) ?? "") \(StringConstant.Formats.tLText)".replacingOccurrences(of: ".", with: ",")
    }
    
    var roundedTwoDigit: String {
        return "\(doubleFormatter.string(from: NSNumber(value: self)) ?? "")"
    }
    
    var roundedTwoDigitWithDot: String {
        return "\(doubleFormatterWithDot.string(from: NSNumber(value: self)) ?? "")"
    }
    
    //MARK: - Helper Methods
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    private var doubleFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""
        return formatter
    }
    
    private var doubleFormatterWithDot: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        return formatter
    }
    
    
}
