//
//  KeyboardManager.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 23.12.2020.
//

import Foundation
import UIKit

class KeyboardManager {
    
    static let shared = KeyboardManager()
    let rootVC = UIApplication.getPresentedViewController()
    var keyboardHeight: CGFloat = 0
    var textField = UITextField()
    var textFieldFrame = CGRect()
    
    func start() {
        keyboardFuncs()
    }
    
    fileprivate func keyboardFuncs() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editingDidBegin(sender:)), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo

        if let keyboardSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardSizeHeight = keyboardSize.origin.y - 60
            if textField.frame.origin.y >= keyboardSizeHeight {
                rootVC?.view.frame.origin.y = -((textField.frame.origin.y-keyboardSize.origin.y) + 50 + 30)
            }
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        rootVC?.view.frame.origin.y = 0
    }
    @objc func editingDidBegin(sender: NSNotification) {
        
        textField = (sender.object as? UITextField) ?? UITextField()
        
        if let frame = textField.superview?.superview?.convert(rootVC!.view.frame , to: nil) {
            textField.frame  = frame
        }
    }
}
