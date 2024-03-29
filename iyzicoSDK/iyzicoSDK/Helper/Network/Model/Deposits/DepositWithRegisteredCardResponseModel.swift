//
//  DepositWithRegisteredCardResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 5.04.2021.
//

import Foundation

struct DepositWithRegisteredCardResponseModel: Decodable {
    let balanceAmount: String?
    let amount: String?
    let currencyCode: String?
    let depositStatus: DepositStatus?
    let depositType: String?
}
