//
//  CardsResponseModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 24.03.2021.
//

import Foundation

//Outer Model
struct CardItemsResponseModel: Decodable {
    let items: [CardResponseModel]?
}

//Inner Model
struct CardResponseModel: Codable {
    let binNumber, lastFourDigits, cardBankName: String?
    let cardType: CardNameTypes?
    let cardAssociation: String?
    let cardAssociationLogoURL: String?
    let cardToken: String?
    
    enum CodingKeys: String, CodingKey {
        case binNumber, lastFourDigits, cardBankName, cardType, cardAssociation
        case cardAssociationLogoURL = "cardAssociationLogoUrl"
        case cardToken
    }
}

