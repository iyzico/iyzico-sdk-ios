//
//  CardBonusRequestModel.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 6.04.2022.
//

import Foundation

struct CardBonusRequestModel: Codable {
    let conversationId: String?
    let currency, locale: String?
    let paidPrice: Double?
    let paymentCard: PaymentCard?
    let paymentChannel: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentChannel, paidPrice, conversationId, currency, locale, paymentCard
    }
}
