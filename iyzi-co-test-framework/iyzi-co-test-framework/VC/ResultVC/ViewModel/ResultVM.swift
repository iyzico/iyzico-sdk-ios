//
//  ResultVM.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 31.03.2021.
//

import Foundation

class ResultVM: BaseVM {
    //MARK: - Navigated Properties
    var topUpPriceForLoad: String?
    var protectedBankAccount: ProtectedBankAccountsResponseModel?
    var priceForLoad: String?
    var priceForPayment: String?
    var navigatedReferenceCode: String?
    var html: String?
}
