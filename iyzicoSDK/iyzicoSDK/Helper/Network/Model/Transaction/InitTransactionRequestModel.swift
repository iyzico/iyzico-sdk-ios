//
//  InitTransactionRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 5.04.2021.
//

import Foundation

struct InitTransactionRequestModel: Encodable {
    let email: String?
    let transactionType: TransactionType?
}

enum TransactionType: String, Codable {
    case DEPOSIT = "DEPOSIT"
}
