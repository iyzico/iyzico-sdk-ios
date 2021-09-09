//
//  PaymentBankTransferRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 5.08.2021.
//

import Foundation

struct PaymentBankTransferRequestModel: Codable {
    let bankID, memberID: Int?
    let email, gsmNumber, paymentChannel: String?
    let buyerProtected: Bool?
    let locale: String?
    
    enum CodingKeys: String, CodingKey {
        case bankID = "bankId"
        case memberID = "memberId"
        case email, gsmNumber, paymentChannel, buyerProtected, locale
    }
}
