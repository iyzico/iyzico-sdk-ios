//
//  BalanceResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation

struct BalancesResponseModel: Decodable {
    let amount: String?
    let lastUpdatedDate: String?
    let currencyCode: String?
    let provisionAmount: String?
}
