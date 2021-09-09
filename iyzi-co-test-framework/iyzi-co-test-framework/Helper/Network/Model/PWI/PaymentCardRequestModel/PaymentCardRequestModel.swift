//
//  PaymentCardRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 4.08.2021.
//

import Foundation

struct PaymentCardRequestModel: Codable {
    let paymentChannel, paidPrice, memberID: String?
    let installment: Int?
    let gsmNumber: String?
    let buyerProtected: Bool?
    let memberToken: String?
    let paymentCard: PaymentCard?
    
    enum CodingKeys: String, CodingKey {
        case paymentChannel, paidPrice
        case memberID = "memberId"
        case installment, gsmNumber, buyerProtected, memberToken, paymentCard
    }
}
