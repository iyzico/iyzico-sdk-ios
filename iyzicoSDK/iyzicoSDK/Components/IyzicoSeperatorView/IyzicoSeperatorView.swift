//
//  IyzicoSeperatorView.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

class IyzicoSeperatorView: BaseView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        setupUI()
    }
    
    private func setupUI() {
        setupBackgroundColor()
    }
    
    private func setupBackgroundColor() {
        backgroundColor = .paleGreyTwo
    }
}
