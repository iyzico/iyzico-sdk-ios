//
//  UIButtonExtension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 7.12.2020.
//

import Foundation
import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
}
