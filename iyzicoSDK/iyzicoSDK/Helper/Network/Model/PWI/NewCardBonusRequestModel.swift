//
//  NewCardBonusRequestModel.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 12.04.2022.
//

import Foundation

struct NewCardBonusRequestModel: Codable {
    let conversationId: String?
    let currency, locale: String?
    let paidPrice: Double?
    let paymentCard: PaymentCard?
    let paymentChannel: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentChannel, paidPrice, conversationId, currency, locale, paymentCard
    }
}

