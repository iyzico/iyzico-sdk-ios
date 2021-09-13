//
//  BalanceRouter.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation
import Alamofire

enum BalanceRouter: APIConfiguration {
    case balances

    var method: HTTPMethod {
        switch self {
        case .balances:
            return .get
        }
    }
    
    var scope: String? {
        switch self {
        case .balances:
            return nil
        }
    }

    var path: String {
        switch self {
        case .balances:
            return "/funds/balances"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .balances:
            return "/api/v1"
        }
    }

    var httpBody: Data? {
        switch self {
        case .balances:
            return nil
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .balances:
            return BalancesQueryRequestModel(locale: SDKManager.language,
                                             channelType: "THIRD_PARTY_APP").asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .balances:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .balances:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .balances:
            return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
