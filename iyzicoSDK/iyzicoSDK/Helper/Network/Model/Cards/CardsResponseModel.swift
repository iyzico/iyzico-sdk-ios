//
//  CardsResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 24.03.2021.
//

import Foundation

//Outer Model
struct CardItemsResponseModel: Decodable {
    let items: [CardResponseModel]?
}

//Inner Model
struct CardResponseModel: Codable, Equatable {
    let binNumber, lastFourDigits, cardBankName: String?
    let cardType: CardNameTypes?
    let cardAssociation: String?
    let cardAssociationLogoURL: String?
    let cardToken: String?
    let iyzicoCard, iyzicoVirtualCard, threeDSVerified: Bool?
    var isDisabled: Bool?
    var isBonusHidden: Bool? = true
    
    enum CodingKeys: String, CodingKey {
        case binNumber, lastFourDigits, cardBankName, cardType, cardAssociation
        case cardAssociationLogoURL = "cardAssociationLogoUrl"
        case cardToken
        case iyzicoCard, iyzicoVirtualCard, threeDSVerified, isDisabled, isBonusHidden
    }
}

