//
//  CashoutCompleteResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

struct CashoutCompleteResponseModel: Decodable {
    let balanceAmount: String?
    let amount: String?
    let depositStatus: DepositStatus?
}
