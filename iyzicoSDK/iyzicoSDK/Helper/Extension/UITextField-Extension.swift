//
//  UITextField-Extension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 19.12.2020.
//

import Foundation
import UIKit

extension UITextField {
    func setAttributedString(partialText: String,
                             font: UIFont,
                             foregroundColor: UIColor) {
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let nsRange = NSString(string: self.text ?? "").range(of: partialText)
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: foregroundColor
        ]
        attributedText.addAttributes(attributes, range: nsRange)
        self.attributedText = attributedText
    }
    
    func setDoubleAttributedString(firstText: String,
                                   secondText: String,
                                   firstFont: UIFont,
                                   secondFont: UIFont,
                                   firstForegroundColor: UIColor,
                                   secoindForegroundColor: UIColor) {
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let nsRangeFirst = NSString(string: self.text ?? "").range(of: firstText)
        let nsRangeSecond = NSString(string: self.text ?? "").range(of: secondText)
        let attributesFirst: [NSAttributedString.Key : Any] = [
            .font: firstFont,
            .foregroundColor: firstForegroundColor
        ]
        attributedText.addAttributes(attributesFirst, range: nsRangeFirst)
        let attributesSecond: [NSAttributedString.Key : Any] = [
            .font: secondFont,
            .foregroundColor: secoindForegroundColor
        ]
        attributedText.addAttributes(attributesSecond, range: nsRangeSecond)
        self.attributedText = attributedText
    }
    
    //Make it ordered
    func setMultipleAttributedString(attributedStringModels: [AttributedStringModel]) {
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        let ranges = attributedStringModels.map { NSString(string: self.text ?? "").range(of: $0.text) }
        
        let attributes: [[NSAttributedString.Key : Any]] = attributedStringModels.map { model -> [NSAttributedString.Key : Any] in
            let attribute: [NSAttributedString.Key : Any] = [
                .font: model.font,
                .foregroundColor: model.color
            ]
            return attribute
        }
        for (index, value) in attributes.enumerated() {
            attributedText.addAttributes(value, range: ranges[index])
        }
        self.attributedText = attributedText
    }
    
    func lockPhoneCode(textField: UITextField, string: String, updatedText: String) -> Bool {
        if let selectedRange = self.selectedTextRange {
            
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            
            //User trying to select all text in text field
            let selectedTextCount = textField.text(in: selectedRange)?.count
            if selectedTextCount == textField.text?.count {
                textField.text = textField.text?.dropLast((selectedTextCount ?? 3) - 3).description //3 for instant local area number characters. Example +90
            }
            
            //Maximum character limit check
            if updatedText.count > 17 {
                return false
            }
            
            //Is user trying to remove whitespaces
            let tempCursorPosition = cursorPosition == 0 ? 1 : (cursorPosition - 1)
            if (textField.text ?? "").count == 17 && string.isBackspace && textField.text?[tempCursorPosition] == " " {
                return false
            }
           
            //Is user trting to remove locked characters
            if cursorPosition <= 2 || (cursorPosition == 3 && string.isBackspace) || (cursorPosition == 17 && !string.isBackspace) {
                return false
            }
            if (cursorPosition == 3 && !string.isBackspace) {
                textField.text =   (textField.text ?? "") +  " " + string
                return false
            }
            if  cursorPosition == 7 || cursorPosition == 11 || cursorPosition == 14 {
                if !string.isBackspace {
//                    textField.text =   updatedText + " "
                    textField.text =   (textField.text ?? "") +  " " + string
                    return false
                }
            }
            
        }
        return true
    }
    func lockTL(string: String, updatedText: String, textField: UITextField) -> Bool {
        if let selectedRange = self.selectedTextRange {
            let commaIndex = self.text?.indexInt(of: Character(StringConstant.shared.comma)) ?? .zero
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            
            if cursorPosition < 1 || (cursorPosition == 1 && string.isBackspace) {
                return false
            }
            
            if string == StringConstant.shared.dot && !(textField.text?.contains(StringConstant.shared.comma) ?? true) {
                textField.text = (textField.text ?? "") + StringConstant.shared.comma
                return false
            }
            else if (textField.text?.contains(StringConstant.shared.comma) ?? true) {
                if string == StringConstant.shared.dot {
                    return false
                }
                if cursorPosition == commaIndex + 3 && !string.isBackspace {
                    return false
                }  else if cursorPosition > commaIndex {
                    if cursorPosition - commaIndex == 1 && string.isBackspace {
                        self.text = updatedText.currencyFormatting()
                        return false
                    }
                    return true
                } else {
                    let beforeComma = "\(updatedText.dropLast(3))"
                    //let afterComma = "\(updatedText.suffix(3))"
                    self.text = beforeComma.currencyFormatting()
                    return false
                }
            } else {
                self.text = updatedText.currencyFormatting()
                return false
            }
        }
        return true
    }
    func ibanMask(textField: UITextField, string: String, updatedText: String) -> Bool {
        if let selectedRange = self.selectedTextRange {
            
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            
            if updatedText.count > 32 {
                return false
            }
            
            if cursorPosition < 2 || (cursorPosition == 2 && string.isBackspace) || (cursorPosition == 32 && !string.isBackspace) {
                return false
            }
            if cursorPosition == 3 || cursorPosition == 8 || cursorPosition == 13 || cursorPosition == 18 || cursorPosition == 23 || cursorPosition == 28 {
                
                if !string.isBackspace {
                    textField.text =   updatedText + " "
                    return false
                }
               
            }
        }
        return true
    }
    func cardNumberMask(textField: UITextField, string: String, updatedText: String) -> Bool {
        if let selectedRange = self.selectedTextRange {

            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            
            if (cursorPosition == 19 && !string.isBackspace) {
                return false
            }
            if cursorPosition == 3 || cursorPosition == 8 || cursorPosition == 13{
                
                if !string.isBackspace {
                    textField.text =   updatedText + " "
                    return false
                }
                
            }
        }
        return true
    }
    
    func generalFormat(with mask: String, text: String) {
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        self.text = result
    }
    
    
    func textCount(lessThan: Int, string: String) -> Bool {
        if ((self.text?.count ?? 0) < lessThan || string.isBackspace) {
            return true
        } else {
            return false
        }
    }
   /* func amountPriceMask(string: String) -> Bool {
        switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                IyzicoTextInput.currentString += string
                formatCurrency(string: IyzicoTextInput.currentString)
            default:
                if string.count == 0 && IyzicoTextInput.currentString.count != 0 {
                    IyzicoTextInput.currentString = String(IyzicoTextInput.currentString.dropLast())
                    formatCurrency(string: IyzicoTextInput.currentString)
                }
        }
       /* if string == IyzicoTextInput.currentString && string.isBackspace {
            return true
        } else {
            return false
        }*/
        return false
        
    }
    
    func formatCurrency(string: String) {
        print("format \(string)")
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "en_TR") as Locale
        let numberFromField = (NSString(string: IyzicoTextInput.currentString).doubleValue)/100
        //replace billTextField with your text field name
        self.text = formatter.string(from: NSNumber(value: numberFromField))
        
        let attrStri = NSMutableAttributedString.init(string: self.text ?? "")
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont(name:"MarkPro", size: 28.0)!], range: NSRange(location: (self.text?.count ?? 3) - 3, length: 3))
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont(name:"MarkPro-Bold", size: 32.0)!], range: NSRange(location: 0, length: (self.text?.count ?? 3) - 3))
        self.attributedText = attrStri
    }*/
    
    @IBInspectable var doneAccessory: Bool {
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    
    func convertLowercasedWithDelay(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.text = self?.text?.lowercased()
        }
    }
    
    func setCursorPosition(cursorPosition: CursorPositionTypes) {
        switch cursorPosition {
        case .begin:
            let newPosition = self.beginningOfDocument
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        case .end:
            let newPosition = self.endOfDocument
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func getCursorPosition() -> Int? {
        if let selectedRange = self.selectedTextRange {
            let cursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
            return cursorPosition
        }
        return nil
    }
}
