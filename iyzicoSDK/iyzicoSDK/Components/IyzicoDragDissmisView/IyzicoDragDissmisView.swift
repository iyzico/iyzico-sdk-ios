//
//  IyzicoDragDissmisView.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 29.01.2021.
//

import Foundation
import UIKit

class IyzicoDragDissmisView: BaseView {
    
  
    var viewTranslation = CGPoint(x: 0, y: 0)
    override func commonInit() {
        super.commonInit()
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }

    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: self)
                if viewTranslation.y > .zero {
                    UIView.animate(withDuration: 0.5, delay: .zero, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.transform = CGAffineTransform(translationX: .zero, y: self.viewTranslation.y)
                    })
                }
                
            case .ended:
                if viewTranslation.y < 150 {
                    UIView.animate(withDuration: 0.5, delay: .zero, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.transform = .identity
                    })
                } else {
        
                    removeBlurred()
                    self.superview?.parentViewController?.dismiss(animated: true, completion: nil)
                }
            default:
                break
        }
    }
}
extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
