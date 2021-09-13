//
//  CashoutCompleteRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

struct CashoutCompleteRequestModel: Encodable {
    let amount: String?
    let initialRequestId: String?
    let currencyType: String?
}
