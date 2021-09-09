//
//  UIViewController-Extension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 18.12.2020.
//

import Foundation
import UIKit

@nonobjc extension UIViewController {
    
    public func add(_ child: UIViewController, containerView: UIView? = nil) {
        addChild(child)
        view.addSubview(child.view)
        
        if let containerView = containerView {
            addConst(view: child.view, containerView: containerView)
        }
        
        child.didMove(toParent: self)
    }
    
    public  func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addConst(view: UIView, containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 0),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: 0),
            view.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 0),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 0)
        ])
    }
}
