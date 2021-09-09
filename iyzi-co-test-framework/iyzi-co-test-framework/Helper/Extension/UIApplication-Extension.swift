//
//  UIApplication-Extension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 20.12.2020.
//

import Foundation
import UIKit
extension UIApplication {
    
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}
