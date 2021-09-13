//
//  DepositWithRegisteredCardRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 5.04.2021.
//

import Foundation

struct DepositWithRegisteredCardRequestModel: Encodable {
    let initialRequestId: String?
    let cardToken: String?
    let amount: String?
    let currencyCode: String?
    let clientIp: String?
    let channelType: String?
}
