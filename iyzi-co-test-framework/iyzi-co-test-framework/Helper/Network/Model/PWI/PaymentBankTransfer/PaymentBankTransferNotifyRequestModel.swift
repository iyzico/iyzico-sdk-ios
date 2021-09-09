//
//  PaymentBankTransferNotifyRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 5.08.2021.
//

import Foundation

struct PaymentBankTransferNotifyRequestModel: Codable {
    let bankTransferPaymentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case bankTransferPaymentID = "bankTransferPaymentId"
    }
}

