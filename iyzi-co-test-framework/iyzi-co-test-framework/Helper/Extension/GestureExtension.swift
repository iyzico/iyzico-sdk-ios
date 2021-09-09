//
//  GestureExtension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 10.12.2020.
//

import Foundation
import UIKit

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
        let attributes = attributedText.attributes(at: .zero, effectiveRange: nil)
        for i in attributes {
            mutableStr.addAttributes([i.key : i.value], range: NSRange.init(location: .zero, length: attributedText.length))
        }
      //  mutableStr.addAttributes([NSAttributedString.Key.font : label.font!,
                               //   ], range: NSRange.init(location: .zero, length: attributedText.length))
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableStr)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    func getTappedCharacterIndexInTextField(textField: UITextField) -> Int {
        let textContainer = NSTextContainer(size: CGSize.zero)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textFieldSize = textField.bounds.size
        
        let locationOfTouchInTextField = self.location(in: textField)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (textFieldSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (textFieldSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInTextField.x - textContainerOffset.x,
                                                     y: locationOfTouchInTextField.y - textContainerOffset.y);
        return layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                            in: textContainer,
                                            fractionOfDistanceBetweenInsertionPoints: nil)
    }
}
