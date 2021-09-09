//
//  CashoutInitRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

struct CashoutInitRequestModel: Encodable {
    let email: String?
    let amount: String?
    let currencyType: String?
}
