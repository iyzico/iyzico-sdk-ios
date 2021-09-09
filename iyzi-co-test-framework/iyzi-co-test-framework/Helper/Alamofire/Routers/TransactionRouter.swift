//
//  TransactionRouter.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 5.04.2021.
//

import Foundation
import Alamofire

enum TransactionRouter: APIConfiguration {
    case initTransaction(requestModel: InitTransactionRequestModel?)

    var method: HTTPMethod {
        switch self {
        case .initTransaction:
            return .post
        }
    }
    
    var scope: String? {
        switch self {
        case .initTransaction:
            return "fund"
        }
    }

    var path: String {
        switch self {
        case .initTransaction:
            return "/funds/third-party/init-transaction"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .initTransaction:
            return "/api/v1"
        }
    }

    var httpBody: Data? {
        switch self {
        case .initTransaction(let requestModel):
            return requestModel?.asData
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .initTransaction:
            return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .initTransaction:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .initTransaction:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .initTransaction:
            return nil
        }
    }
}
