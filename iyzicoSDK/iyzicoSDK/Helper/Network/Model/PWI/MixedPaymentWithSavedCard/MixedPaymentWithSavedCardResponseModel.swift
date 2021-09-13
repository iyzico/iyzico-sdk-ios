//
//  MixedPaymentWithSavedCardResponseModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 4.08.2021.
//

import Foundation

// MARK: - MixedPaymentWithSavedCardResponseModel
struct MixedPaymentWithSavedCardResponseModel: Codable {
    let status, locale: String?
    let systemTime: Int?
    let conversationID, token: String?
    let callbackURL: String?
    let threeDSHTMLContent: String?
    
    enum CodingKeys: String, CodingKey {
        case status, locale, systemTime
        case conversationID = "conversationId"
        case token
        case callbackURL = "callbackUrl"
        case threeDSHTMLContent = "threeDSHtmlContent"
    }
}
