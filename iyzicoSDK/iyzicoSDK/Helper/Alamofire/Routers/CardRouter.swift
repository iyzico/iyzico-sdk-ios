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

    var method: HTTPMethod {
        switch self {
        case .cards:
            return .get
        }
    }
    
    var scope: String? {
        switch self {
        case .cards:
            return nil
        }
    }

    var path: String {
        switch self {
        case .cards:
            return "/members/cards"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .cards:
            return "/api/v2"
        }
    }

    var httpBody: Data? {
        switch self {
        case .cards:
            return nil
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .cards:
            return nil
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .cards:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .cards:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .cards:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
