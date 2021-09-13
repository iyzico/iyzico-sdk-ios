//
//  PaymentBankTransferResponseModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 5.08.2021.
//

import Foundation

struct PaymentBankTransferResponseModel: Codable {
    let status, locale: String?
    let systemTime: Int?
    let code: String?
    let bankTransferPaymentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case status, locale, systemTime, code
        case bankTransferPaymentID = "bankTransferPaymentId"
    }
}
