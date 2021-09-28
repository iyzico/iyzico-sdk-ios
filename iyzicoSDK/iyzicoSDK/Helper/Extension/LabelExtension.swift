//
//  StringExtension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 9.12.2020.
//

import Foundation
import UIKit

extension UILabel {
    
    func addAttribute(text: String = "", attText: String, color: UIColor = .red700, highletedFont: UIFont = .markProBold15) {
        var currentText = text
        if currentText == "" {
            currentText = self.text ?? ""
        }
        let attrStri = NSMutableAttributedString.init(string:currentText)
        let nsRange = NSString(string: currentText).range(of: attText, options: String.CompareOptions.caseInsensitive)
        
     
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 5
    
        attrStri.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: .zero, length: text.count))
        attrStri.addAttribute(.foregroundColor, value: color, range: nsRange)
        attrStri.addAttribute(.font, value: highletedFont, range: nsRange)
     
        self.attributedText = attrStri
    }
    
    func addMultipleAttribute(text: String = "",
                              attTexts: [String],
                              color: UIColor = .red700,
                              highletedFont: UIFont = .markProBold15) {
        
        let attrStri = NSMutableAttributedString.init(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 5
        
        attTexts.forEach { attText in
            let nsRange = NSString(string: self.text ?? "").range(of: attText, options: String.CompareOptions.caseInsensitive)
            attrStri.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: .zero, length: text.count))
            attrStri.addAttribute(.foregroundColor, value: color, range: nsRange)
            attrStri.addAttribute(.font, value: highletedFont, range: nsRange)
        }

        self.attributedText = attrStri
    }
    
   public func securePhoneText(number: String) {
        var countryCode = number.prefix(6)
        let areaCode = countryCode.suffix(3)
        countryCode = number.prefix(3)
        let lastTwo = number.suffix(2)
        let text = "\(countryCode)(\(areaCode)) ••• •• \(lastTwo)"
        
        self.text = text
    }
    
    func dropLastString(_ str: Int) -> String {
        let text = self.text?.dropLast(str)
        return "\(text ?? "")"
    }
}
