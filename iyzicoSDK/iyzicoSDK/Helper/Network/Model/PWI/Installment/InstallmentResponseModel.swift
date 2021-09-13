//
//  InstallmentResponseModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 3.08.2021.
//

import Foundation

struct InstallmentResponseModel: Codable {
    let status, locale: String?
    let systemTime: Int?
    let installmentDetails: [InstallmentDetail]?
}

// MARK: - InstallmentDetail
struct InstallmentDetail: Codable {
    let binNumber: String?
    let price: Int?
    let cardType, cardAssociation, cardFamilyName: String?
    let force3Ds, bankCode: Int?
    let bankName: String?
    let forceCvc, commercial: Int?
    let installmentPrices: [InstallmentPrice]?
    
    enum CodingKeys: String, CodingKey {
        case binNumber, price, cardType, cardAssociation, cardFamilyName
        case force3Ds = "force3ds"
        case bankCode, bankName, forceCvc, commercial, installmentPrices
    }
}

// MARK: - InstallmentPrice
struct InstallmentPrice: Codable {
    let installmentPrice, totalPrice: Double?
    let installmentNumber: Int?
}
