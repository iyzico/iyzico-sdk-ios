//
//  UITextView+Extension.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 25.03.2021.
//

import UIKit

extension UITextView {
    func addMultipleAttribute(text: String = "",
                              attTexts: [String],
                              linksNames: [String],
                              color: UIColor = .red700,
                              plainFont: UIFont = .markProMedium12,
                              highletedFont: UIFont = .markProMedium12,
                              alignment: NSTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = alignment
        
        let attrStri = NSMutableAttributedString.init(string: text)
        let fullRange = NSString(string: text).range(of: text)
        attrStri.addAttribute(.foregroundColor, value: UIColor.blueGrey, range: fullRange)
        attrStri.addAttribute(.font, value: plainFont, range: fullRange)
        for (index, attText) in attTexts.enumerated() {
            let partialRange = NSString(string: text).range(of: attText)
            let linkAttributes: [NSAttributedString.Key: Any] = [
                .font: highletedFont,
                .link: URL(string: linksNames[index]) as Any,
                .foregroundColor: color
            ]
            attrStri.addAttributes(linkAttributes, range: partialRange)
        }
        attrStri.addAttribute(.paragraphStyle, value: style, range: fullRange)

        self.attributedText = attrStri
    }
}
