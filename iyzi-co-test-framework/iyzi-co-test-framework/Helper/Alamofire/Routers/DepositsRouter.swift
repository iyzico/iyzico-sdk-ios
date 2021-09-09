//
//  DepositsRouter.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 5.04.2021.
//

import Foundation
import Alamofire

enum DepositsRouter: APIConfiguration {
    case withRegisteredCard(requestModel: DepositWithRegisteredCardRequestModel?)
    case withNewCard(requestModel: DepositWithNewCardRequestModel?)
    case protectedBankAccounts

    var method: HTTPMethod {
        switch self {
        case .withRegisteredCard:
            return .post
        case .withNewCard:
            return .post
        case .protectedBankAccounts:
            return .get
        }
    }
    
    var scope: String? {
        switch self {
        case .withRegisteredCard:
            return "fund"
        case .withNewCard:
            return "fund"
        case .protectedBankAccounts:
            return nil
        }
    }

    var path: String {
        switch self {
        case .withRegisteredCard:
            return "/funds/deposits/third-party/with-registered-card"
        case .withNewCard:
            return "/funds/deposits/third-party/with-new-card"
        case .protectedBankAccounts:
            return "/funds/protected-bank-accounts"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .withRegisteredCard:
            return "/api/v1"
        case .withNewCard:
            return "/api/v1"
        case .protectedBankAccounts:
            return "/api/v2"
        }
    }

    var httpBody: Data? {
        switch self {
        case .withRegisteredCard(let requestModel):
            return requestModel?.asData
        case .withNewCard(let requestModel):
            return requestModel?.asData
        case .protectedBankAccounts:
            return nil
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .withRegisteredCard:
            return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        case .withNewCard:
            return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        case .protectedBankAccounts:
            return ProtectedBankAccountsQueryRequestModel(channelType: "THIRD_PARTY_APP").asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .withRegisteredCard:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .withNewCard:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .protectedBankAccounts:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .withRegisteredCard:
            return 10
        case .withNewCard:
            return 10
        case .protectedBankAccounts:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .withRegisteredCard:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        case .withNewCard:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        case .protectedBankAccounts:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
