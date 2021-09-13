//
//  IyzicoHomePaymentTypes.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 6.04.2021.
//

import Foundation

enum IyzicoHomePaymentTypes: Equatable {
    static func == (lhs: IyzicoHomePaymentTypes, rhs: IyzicoHomePaymentTypes) -> Bool {
        lhs.value == rhs.value
    }
    var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
    case myAccount
    case creditCard(_ creditCardPaymentType: IyzicoHomeCreditCardPaymentTypes)
    case eft
    case none
}

enum IyzicoHomeCreditCardPaymentTypes {
    case withCreditCard(_ selectionType: IyzicoHomePaymentSelectionTypes)
    case withNewCard(_ selectionType: IyzicoHomePaymentSelectionTypes)
}

enum IyzicoHomePaymentSelectionTypes {
    case basic
    case mixed
}

enum IyzicoHomePaymentInstallmentTypes: Int, CaseIterable {
    case full = 0
    case installment
}
