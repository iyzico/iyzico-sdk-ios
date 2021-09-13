//
//  DecimalExtension.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation

extension Decimal {
    var roundedCurrency: Decimal {
        let currencyBehavior = NSDecimalNumberHandler(roundingMode: .bankers,
                                                      scale: 2,
                                                      raiseOnExactness: false,
                                                      raiseOnOverflow: false,
                                                      raiseOnUnderflow: false,
                                                      raiseOnDivideByZero: true)
        return (self as NSDecimalNumber).rounding(accordingToBehavior: currencyBehavior) as Decimal
    }
    
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
