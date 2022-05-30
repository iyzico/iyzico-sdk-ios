//
//  PWInitRequestModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation


// MARK: - Welcome
 struct PWIinitRequestModel: Codable {
    var paidPrice: String?
    var enabledInstallments: [Int]?
    var price, paymentGroup: String?
    var callbackURL: String?
    var paymentSource, currency, basketID: String?
    var buyer: BuyerRequest?
    var shippingAddress, billingAddress: PWIAddressRequest?
    var basketItems: [BasketItemRequest]?
    var mobileDeviceInfoDto: MobileDeviceInfoDto?
    
    enum CodingKeys: String, CodingKey {
        case paidPrice, enabledInstallments, price, paymentGroup
        case callbackURL = "callbackUrl"
        case paymentSource, currency
        case basketID = "basketId"
        case buyer, shippingAddress, billingAddress, basketItems, mobileDeviceInfoDto
    }
}

// MARK: - BasketItem
 struct BasketItemRequest: Codable {
   var id, price, name, category1: String?
   var itemType, subMerchantKey, subMerchantPrice: String?
}

// MARK: - IngAddress
 struct PWIAddressRequest: Codable {
    var address, contactName, city, country: String?
}

// MARK: - Buyer
struct BuyerRequest: Codable {
    var id, name, surname, identityNumber: String?
    var email, gsmNumber, registrationAddress, city: String?
    var country, ip: String?
    
}

// MARK: - MobileDeviceInfoDto
struct MobileDeviceInfoDto: Codable {
    var sdkVersion, operatingSystemVersion, model, brand: String?
}
