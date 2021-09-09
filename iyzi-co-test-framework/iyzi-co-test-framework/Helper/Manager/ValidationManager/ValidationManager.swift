//
//  ValidationManager.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 1.02.2021.
//

import Foundation

class ValidationManager {
    //MARK: - Complete Text Validation
     static func validate(text: String?, regexType: RegexTypes) -> Bool {
        let regex = regexType.rawValue
        let trimmedString = text?.replacingOccurrences(of: " ", with: "")
        let validateText = NSPredicate(format:"SELF MATCHES %@", regex)
        return validateText.evaluate(with: trimmedString)
    }
    
    static func validate(text: String?, cardBrand: CardBrandsName) -> Bool {
        let regex = cardBrand.regex
        let trimmedString = text?.replacingOccurrences(of: " ", with: "")
        let validateText = NSPredicate(format:"SELF MATCHES %@", regex)
        return validateText.evaluate(with: trimmedString)
    }
    
    static func guest(text: String?, cardBrand: CardBrandsName) -> Bool {
        let regex = cardBrand.start
        let trimmedString = text?.replacingOccurrences(of: " ", with: "")
        let validateText = NSPredicate(format:"SELF MATCHES %@", regex)
        return validateText.evaluate(with: trimmedString)
    }
    
    
    static func checkValidation (inputs: [IyzicoTextInput]) -> Bool {
        var validate = false
        for i in inputs {
            if i.textField.text == "" {
                validate = false
            } else {
                validate = true
            }
        }
        return validate
    }
    
    static func amountValidation(amount: String?, afterCommaText: String) -> Bool {
        let emptyCondition = amount == ""
        let defaultCondition = amount == StringConstant.shared.iyzicoTransferVCDefaultAmount
        let afterCommaTextCountCondition = afterCommaText.count != 3
        let validationControlCondition = StringConstant.IyzicoAmountView.validationControl == amount
        if emptyCondition || defaultCondition || afterCommaTextCountCondition || validationControlCondition {
            return false
        }
        return true
    }
    
    static func nilValidation(text: String?) -> Bool {
        if text == "" || text == nil {
            return false
        }
        return true
    }
    
    static func sktDateValidation(text: String) -> Bool {
        //aa -> Month
        //yy -> Year
        let aaText = text.prefix(2).description
        let yyText = text.suffix(2).description
        let slashText = text.suffix(3).first?.description
        
        let currentYear = Int(Calendar.current.component(.year, from: Date()).description.suffix(2)) ?? 0
        let yyRule: [String] = Array(currentYear..<100).map{ $0.description }
        
        var currentMonth = Int(Calendar.current.component(.month, from: Date()).description) ?? 0
        if Int(yyText) ?? 0 > currentYear {
            currentMonth = 1
        }
        let aaRule: [String] = Array(currentMonth..<13).map{ $0.description }

        var aaTextForCondition = ""
        if aaText.first == "0" {
            aaTextForCondition = aaText.dropFirst().description
        }
        else {
            aaTextForCondition = aaText.description
        }
        
        let aaTextCondition = aaRule.contains(aaTextForCondition)
        let yyTextCondition = yyRule.contains(yyText) && yyText.count == 2
        let slashCondition = slashText == "/"
        return aaTextCondition && yyTextCondition && slashCondition
    }
    
    static func otpValidation(text: String) -> Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let isNumeric = Set(text).isSubset(of: nums)
        if text.count == 6 && isNumeric {
            return true
        }
        return false
    }
    
    static func cardNumberValidation(text: String) -> Bool {
        if ValidationManager.validate(text: text, cardBrand: .AMEX) {
            return text.count == 17
        }
        return text.count == 19
    }
    
    static func cvvValidation(text: String) -> Bool {
        return text.count == 3 || text.count == 4
    }
    
    //MARK: - Helper Methods
    static func checkForValidCharacters(text: String, regexType: RegexTypes) -> Bool {
        switch regexType {
        case .email:
            return !text.containsWhiteSpaces
        case .phone:
            return false //default
        case .iban:
            return false //default
        default:
            return true
        }
    }
}
