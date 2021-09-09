//
//  BaseView.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 28.01.2021.
//

import UIKit

class BaseView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
    }
}
