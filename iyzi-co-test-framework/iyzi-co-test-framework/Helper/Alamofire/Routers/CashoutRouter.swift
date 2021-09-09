//
//  CashoutRouter.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import Alamofire

enum CashoutRouter: APIConfiguration {
    case initializeCashoutToBalance(requestModel: CashoutInitRequestModel?)
    case completeCashoutToBalance(requestModel: CashoutCompleteRequestModel?)

    var method: HTTPMethod {
        switch self {
        case .initializeCashoutToBalance:
            return .post
        case .completeCashoutToBalance:
            return .post
        }
    }

    var scope: String? {
        switch self {
        case .initializeCashoutToBalance:
            return nil
        case .completeCashoutToBalance:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .initializeCashoutToBalance:
            return "/funds/initialize-cashout-to-balance"
        case .completeCashoutToBalance:
            return "/funds/complete-cashout-to-balance"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .initializeCashoutToBalance:
            return "/api/v1"
        case .completeCashoutToBalance:
            return "/api/v1"
        }
    }

    var httpBody: Data? {
        switch self {
        case .initializeCashoutToBalance(let requestModel):
            return requestModel?.asData
        case .completeCashoutToBalance(let requestModel):
            return requestModel?.asData
        }
    }
    
    var queryParameters: Parameters? {
        return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .initializeCashoutToBalance:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .completeCashoutToBalance:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .initializeCashoutToBalance:
            return 10
        case .completeCashoutToBalance:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .initializeCashoutToBalance:
            return nil
        case .completeCashoutToBalance:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
