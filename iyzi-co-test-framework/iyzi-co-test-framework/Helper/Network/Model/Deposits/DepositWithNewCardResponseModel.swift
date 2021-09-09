//
//  DepositWithNewCardResponseModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 21.04.2021.
//

import Foundation

struct DepositWithNewCardResponseModel: Decodable {
    let balanceAmount: String?
    let amount: String?
    let currencyCode: String?
    let depositStatus: DepositStatus?
    let depositType: String?
}
