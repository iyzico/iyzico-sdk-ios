//
//  BSConfiguration.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 18.03.2021.
//

import UIKit

struct BSConfiguration {
    public var topMargin: CGFloat = 0.0
    public var cornerRadius: CGFloat = 10.0
    
    public var backgroundColor: UIColor = UIColor.black
    public var backgroundAlpha: CGFloat = 0.4
    public var contentBackgroundColor: UIColor?
    
    public var maxHeightPerc: CGFloat = 0.78
    
    public var dismissOnBackground: Bool = true
    public var dismissOnPull: Bool = true
    
    public init() { }
}
