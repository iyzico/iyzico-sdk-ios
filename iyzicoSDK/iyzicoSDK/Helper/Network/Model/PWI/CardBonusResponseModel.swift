//
//  CardBonusResponseModel.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 6.04.2022.
//

import Foundation

struct CardBonusResponseModel: Decodable {
    let locale: String?
    let conversationId, cardBank, cardFamily, currency: String?
    let points: Int?
    let amount: Double?
    
    enum CodingKeys: String, CodingKey {
        case locale, conversationId, cardBank, cardFamily, currency
        case points = "points"
        case amount = "amount"
    }
}
