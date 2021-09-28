//
//  ProtectedBankAccountsResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 28.04.2021.
//

import Foundation

struct ProtectedBankAccountsResponseModel: Codable {
    let bankId: Int?
    let iban: String?
    let legalCompanyTitle: String?
    let bankName: String?
    let bank: String?
    let logoUrl: String?
    let bankLogoUrl: String?
    let currency: String?
   
}
