//
//  DepositWithNewCardRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 21.04.2021.
//

import Foundation

struct DepositWithNewCardRequestModel: Encodable {
    let amount: String?
    let initialRequestId: String?
    let currencyCode: String?
    let clientIp: String?
    let cardHolderName: String?
    let cardNumber: String?
    let expireYear: String?
    let expireMonth: String?
    let cvc: String?
    let channelType: String?
}
