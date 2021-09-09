//
//  RegisterRouter.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import Alamofire

enum RegisterRouter: APIConfiguration {
    case quickRegister(requestModel: QuickRegisterInitializeRequestModel?)

    var method: HTTPMethod {
        switch self {
        case .quickRegister:
            return .post
        }
    }
    
    var scope: String? {
        switch self {
        case .quickRegister:
            return nil
        }
    }

    var path: String {
        switch self {
        case .quickRegister:
            return "/members/third-party/quick-register"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .quickRegister:
            return "/api/v1"
        }
    }

    var httpBody: Data? {
        switch self {
        case .quickRegister(let requestModel):
            return requestModel?.asData
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .quickRegister:
            return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .quickRegister:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .quickRegister:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .quickRegister:
            return nil
        }
    }
}
