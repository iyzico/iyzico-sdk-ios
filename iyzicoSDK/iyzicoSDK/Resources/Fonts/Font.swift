//
//  Font.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 7.12.2020.
//

import Foundation
import UIKit

extension UIFont {
   
    // MARK: - Bold
    class var markProBold16: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 16.0)!
    }
    
    class var markProBold28: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 28.0)!
    }
    
    class var markProBold12: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 12.0)!
    }
    
    class var markProBold14: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 14.0)!
    }
    
    class var markProBold24: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 24.0)!
    }
    
    class var markProBold15: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 15.0)!
    }
    
    class var markProBold11: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 11.0)!
    }
    
    class var markProBold25: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 25.0)!
    }
    
    class var markProBold17: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 17.0)!
    }
    
    class var markProBold20: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 20.0)!
    }
    
    class var markProBold18: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 18.0)!
    }
    
    class var markProBold51: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 51.0)!
    }
    
    class var markProBold32: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 32.0)!
    }
    
    class var markProBold34: UIFont {
        return UIFont(name: "MarkPro-Bold", size: 34.0)!
    }
    
    
    // MARK: - Medium
    class var markProMedium16: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 16.0)!
    }
    
    class var markProMedium18: UIFont {

        return UIFont(name: "MarkPro-Medium", size: 18.0)!
    }
    
    class var markProMedium20: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 20.0)!
    }
    
    class var markProMedium12: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 12.0)!
    }
    
    class var markProMedium11: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 11.0)!
    }
    
    public class var markProMedium13: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 13.0)!
    }
    
    class var markProMedium14: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 14.0)!
    }
    
    class var markProMedium24: UIFont {
        return UIFont(name: "MarkPro-Medium", size: 24.0)!
    }
    
    
    // MARK: - Normal
    class var markPro14: UIFont {
        return UIFont(name: "MarkPro", size: 14.0)!
    }
    
    class var markPro16: UIFont {
        return UIFont(name: "MarkPro", size: 16.0)!
    }
    
    class var markPro12: UIFont {
        return UIFont(name: "MarkPro", size: 12.0)!
    }
    
    class var markPro11: UIFont {
        return UIFont(name: "MarkPro", size: 11.0)!
    }
    
    class var markPro10: UIFont {
        return UIFont(name: "MarkPro", size: 10.0)!
    }
    
    class var markPro15: UIFont {
        return UIFont(name: "MarkPro", size: 15.0)!
    }
    class var markPro20: UIFont {
        return UIFont(name: "MarkPro", size: 20.0)!
    }
    
    class var markProBook14: UIFont {
        return UIFont(name: "MarkPro-Book", size: 14.0)!
    }
    
    class var markPro28: UIFont {
      return UIFont(name: "MarkPro", size: 28.0)!
    }
    
}

// MARK: - Register Fonts
public extension UIFont {
    
    static func registerFont(withFilenameString filenameString: String, bundle: Bundle =  Bundle(identifier: StringConstant.shared.frameworkBundle)!) {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
