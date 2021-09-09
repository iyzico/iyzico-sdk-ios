//
//  Color.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 7.12.2020.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Zeplin tasarımından eklenen renkler
    @nonobjc public class var clearBlue: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 100.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc public class var darkGrey: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 37.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var blueGrey: UIColor {
        return UIColor(red: 134.0 / 255.0, green: 142.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var gunmetal: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 80.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var silver: UIColor {
        return UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var paleGrey: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var white2: UIColor {
        return UIColor(white: 245.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var yellowOrange: UIColor {
        return UIColor(red: 1.0, green: 185.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc public class var clearBlueTwo: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 99.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc public class var lightSkyBlue: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 228.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc public class var darkGreyWithAlpha08: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 37.0 / 255.0, blue: 41.0 / 255.0, alpha: 0.8)
    }

    @nonobjc class var pinkishGrey: UIColor {
        return UIColor(red: 209.0 / 255.0, green: 207.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkBlueGrey: UIColor {
        return UIColor(red: 17.0 / 255.0, green: 39.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGreyTwo: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkGreyTwo: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 34.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var charcoalGrey: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 58.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var silverTwo: UIColor {
        return UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var coolGrey: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var steel: UIColor {
        return UIColor(red: 134.0 / 255.0, green: 142.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var clearBlue3: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 100.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPink: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    
    
    // MARK: - Component için eklenen renkler - Proje sonunda silinecek
    @nonobjc class var niceBlue: UIColor {
        return UIColor(red: 15.0 / 255.0, green: 90.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var primarylvl2Highleted: UIColor {
        return UIColor(red: 77.0 / 255.0, green: 171.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var dodgerBlue: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 147.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var dodgerBlue2: UIColor {
        return UIColor(red: 77.0 / 255.0, green: 171.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var paleGray3: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray500: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var paleBlue: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 228.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray600: UIColor {
        return UIColor(red: 134.0 / 255.0, green: 142.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray700: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 80.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var red900: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 62.0 / 255.0, blue: 62.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var red500: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 201.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var red400: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 227.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pale: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 241.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var yellowBrown: UIColor {
        return UIColor(red: 191.0 / 255.0, green: 139.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var darkCream: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 227.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var green500: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 249.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var green900: UIColor {
        return UIColor(red: 47.0 / 255.0, green: 158.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var green600: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 233.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray400: UIColor {
        return UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray200: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 249.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray900: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 37.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var red700: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 107.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var green800: UIColor {
        return UIColor(red: 55.0 / 255.0, green: 178.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var gray800: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 58.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    @nonobjc public class var lineWhite: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var clearBlue2: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 99.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var mediumGreenTwo: UIColor {
      return UIColor(red: 47.0 / 255.0, green: 158.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var dark: UIColor {
      return UIColor(red: 32.0 / 255.0, green: 37.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var veryLightGreen: UIColor {
      return UIColor(red: 211.0 / 255.0, green: 249.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
}
