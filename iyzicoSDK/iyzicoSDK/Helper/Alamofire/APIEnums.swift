//
//  APIConstants.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

enum ServerConfiguration: String {
    case sandbox
    case prod
    
    static var baseURL: String {
        switch ServerConfiguration.serverDirection {
        case .sandbox: return SDKManager.baseUrl ?? ""
        case .prod: return SDKManager.baseUrl ?? ""
        }
    }
    
    static var serverDirection: ServerConfiguration = .sandbox
}

enum HTTPHeaders {
    case authentication(value: String)
    case contentType
    case acceptType
    case acceptEncoding
    case xiyziToken(value: String)
    
    var key: String {
        switch self {
        case .authentication: return "Authorization"
        case .contentType: return "Content-Type"
        case .acceptType: return "Accept"
        case .acceptEncoding: return "Accept-Encoding"
        case .xiyziToken: return "X-IYZI-TOKEN"
        }
    }
    
    var value: String {
        switch self {
        case .authentication(let value): return value
        case .contentType: return "application/json"
        case .acceptType: return "Accept"
        case .acceptEncoding: return "Accept-Encoding"
        case .xiyziToken(let value): return value
        }
    }
}

enum NetworkError {
    case unknown
    case emptyJson
}

enum NetworkStatusTypes: String {
    case success = "success"
    case failure = "failure"
    case responseFailure
}
