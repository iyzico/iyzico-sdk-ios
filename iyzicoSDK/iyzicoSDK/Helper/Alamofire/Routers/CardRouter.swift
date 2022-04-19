//
//  CardRouter.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 23.03.2021.
//

import Foundation
import Alamofire

enum CardRouter: APIConfiguration {
    case cards
    case cardBonus(requestModel: CardBonusRequestModel?)
    case newCardBonus(requestModel: NewCardBonusRequestModel?)
    
    var method: HTTPMethod {
        switch self {
            case .cards:
                return .get
            case .cardBonus:
                return .post
            case .newCardBonus:
                return .post
        }
    }
    
    var scope: String? {
        switch self {
            case .cards:
                return nil
            case .cardBonus(requestModel: _):
                return nil
            case .newCardBonus:
                return nil
        }
    }
    
    var path: String {
        switch self {
            case .cards:
                return "/members/cards"
            case .cardBonus, .newCardBonus:
                return "/pay-with-iyzico/third-party/inquire"
        }
    }
    
    var apiVersion: String {
        switch self {
            case .cards:
                return "/api/v2"
            case .cardBonus, .newCardBonus:
                return "/api/v1"
        }
    }
    
    var httpBody: Data? {
        switch self {
            case .cards:
                return nil
            case .cardBonus(let requestModel):
                return requestModel?.asData
            case .newCardBonus(let requestModel):
                return requestModel?.asData
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
            case .cards:
                return nil
            case .cardBonus, .newCardBonus:
                return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
            case .cards:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
            case .cardBonus, .newCardBonus:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self,
                                                                                                     isInitPWI: true)),
                        .xiyziToken(value: SDKManager.checkoutToken ?? "")]
        }
    }
    
    var timeout: Double? {
        switch self {
            case .cards, .cardBonus:
                return 10
            case .newCardBonus:
                return 10
        }
    }
    
    var accessToken: String? {
        switch self {
            case .cards, .cardBonus, .newCardBonus:
                return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
