//
//  CustomTextField.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 20.12.2020.
//

import Foundation
import UIKit

@objc protocol CustomTextFieldDelegate: AnyObject {
    @objc optional func customDeleteBackward()
    @objc optional func didPastedText()
    @objc optional func shouldPasteText() -> Bool
}

class CustomTextField: UITextField {
    weak var myCustomTextFieldDelegate: CustomTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        myCustomTextFieldDelegate?.customDeleteBackward?()
    }
    
    override func paste(_ sender: Any?) {
        myCustomTextFieldDelegate?.didPastedText?()
        super.paste(sender)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return myCustomTextFieldDelegate?.shouldPasteText?() ?? true
        }
        return super.canPerformAction(action, withSender: sender)
    }
}


