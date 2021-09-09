//
//  String-Extension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 18.12.2020.
//

import Foundation
import UIKit

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    public var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    var firstLetter: String {
        return "\(self.prefix(1))"
    }
    
    var addTL: String {
        return "₺\(self)"
    }
    
    var addTLWithNoDots: String {
        return "₺\(self)".replacingOccurrences(of: ".", with: ",")
    }
    
    func formatToDouble(shouldDropFirst: Bool) -> Double {
        if shouldDropFirst { //For currency character
            return self.dropFirst().description.replacingOccurrences(of: ",", with: ".").asDouble ?? Double(0.0)
        }
        return self.description.replacingOccurrences(of: ",", with: ".").asDouble ?? Double(0.0)
    }
    
    var numericString: String {
       
        
        let characterSet = CharacterSet(charactersIn: "0123456789.").inverted
        
        if !self.contains(",") {
            return "\(components(separatedBy: characterSet).joined())00"
        }
        return components(separatedBy: characterSet).joined()
      
    }
    var justNumber: Int? {
        
        let characterSet = CharacterSet(charactersIn: "0123456789").inverted
        
        return Int(components(separatedBy: characterSet).joined()) ?? nil
        
    }
    var makeDoubleString: String {
        if self.contains(","){
            return "\(self)"
        }
        return "\(self),00"
    }
    
    var addTLToRight: String {
        return "\(self) \(StringConstant.Formats.tLText)"
    }
    
    var addDecimalDefaultNumber: String {
        return "\(self),00"
    }
    
    var asDouble: Double? {
        return Double(self)
    }
    
    var getWithAmountFormat: String {
        return Double(self.replacingOccurrences(of: "₺", with: ""))?.addTLWithAlignment(alignment: .left) ?? ""
    }
    
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
    
    mutating func removeAtIndex(index: Int) {
        if let index = self.index(self.startIndex, offsetBy: index, limitedBy: self.endIndex) {
            self.remove(at: index)
            print(self) // prints "Hello I must be going"
        } else {
            print("\(index) is out of range")
        }
    }
    
    func getCharacterIndex(character: Character) -> Int? {
        if let firstIndex = self.firstIndex(of: character) {
            let index: Int = self.distance(from: self.startIndex, to: firstIndex)
            return index
        }
        return nil
    }
    
    func formatAmount(groupingSeparator: String = ".") -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = groupingSeparator
        formater.numberStyle = .decimal
        let number = formater.string(from: NSNumber(value: self.justNumber ?? .zero)) ?? ""
        
        return number == "0" ? "" : number
    }
    func currencyFormatting(string: String? = nil, fraction: String? = ",00") -> String {
        /*  if let value = Double(self) {
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.maximumFractionDigits = 0
         if let str = formatter.string(for: value) {
         return str
         }
         }*/
        let formater = NumberFormatter()
        // formater.groupingSeparator = groupingSeparator
        formater.locale = Locale(identifier: "en_TR")
        formater.numberStyle = .currency
        formater.maximumFractionDigits = .zero
        var number = formater.string(from: NSNumber(value: self.justNumber ?? .zero)) ?? ""
        number = "₺" + number.dropFirst()
        // return number
        
        //
        // when you tap on "0" nothing was happening because of line 465
        if self == "₺0" && string == "0" {
            return number
        }
        
        //
        return number == "₺0" ? "₺" : number + (fraction ?? "")
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmojiPresentation }
    }
    
    var containsWhiteSpaces: Bool {
        return contains(" ")
    }
    
    var addDotsToPrice: String {
        let largeNumber = Int(self.replacingOccurrences(of: ".", with: "")) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
        return formattedNumber
    }
    
    var servicePhoneNumberFormat: String {
        return self.dropFirst(2).replacingOccurrences(of: " ", with: "")
    }
    
    var serviceAmountFormat: Decimal {
        let cleanFullAmount = self.replacingOccurrences(of: "₺", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        return Decimal(formatter.number(from: cleanFullAmount)?.doubleValue.roundToDecimal(2) ?? 0.00)
    }
    
    var serviceAmountFormatAsString: String {
        return self.replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }
    
    func openUrl() {
        if let url = URL(string: self) {
            UIApplication.shared.open(url)
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: SDKManager.getBundle(), value: "", comment: "")
    }
    
    var removeWhiteSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func callPhoneNumber() {
        let cleanPhoneNumber = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let phoneCallURL = URL(string: "telprompt://\(cleanPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                     application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    func openMail() {
        if let appURL = URL(string: "mailto:\(self)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
    
    var convertServiceMaskedPhoneNumber: String {
        let str = self.replacingOccurrences(of: "*", with: "•")
        let part1 = str[0..<3]
        let part2 = "(" + str[3..<6] + ")" + " "
        let part3 = str[6..<9] + " "
        let part4 = str[9..<11] + " "
        let part5 = str[11..<13]
        return part1 + part2 + part3 + part4 + part5
    }
    
    var addWhitespacesToPhone: String { // Format should be like +905555555555
        let str = self.removeWhiteSpaces
        let part1 = str[0..<3] + " "
        let part2 = str[3..<6] + " "
        let part3 = str[6..<9] + " "
        let part4 = str[9..<11] + " "
        let part5 = str[11..<13]
        return part1 + part2 + part3 + part4 + part5
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func seperate(by: String) -> [String] {
        let arr  = self.components(separatedBy: by)
        return arr
    }
}
