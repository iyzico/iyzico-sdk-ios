//
//  LoginRouter.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import Alamofire

enum LoginRouter: APIConfiguration {
    case otpQuickLoginInitialize(requestModel: QuickLoginInitializeRequestModel?)
    case loginComplete(requestModel: LoginCompleteRequestModel?)
    case smsResend(requestModel: SmsResendRequestModel?)
    case gsmUpdate(requestModel: GsmUpdateRequestModel?)

    var method: HTTPMethod {
        switch self {
        case .otpQuickLoginInitialize:
            return .post
        case .loginComplete:
            return .post
        case .smsResend:
            return .post
        case .gsmUpdate:
            return .post
        }
    }
    
    var scope: String? {
        switch self {
        case .otpQuickLoginInitialize:
            return "fund"
        case .loginComplete:
            return "fund"
        case .smsResend:
            return nil
        case .gsmUpdate:
            return "fund"
        }
    }

    var path: String {
        switch self {
        case .otpQuickLoginInitialize:
            return "/members/third-party/otp-quick-login-initialize"
        case .loginComplete:
            return "/members/third-party/login-complete"
        case .smsResend:
            return "/members/login/sms-resend"
        case .gsmUpdate:
            return "/members/login/gsm-update"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .otpQuickLoginInitialize:
            return "/api/v1"
        case .loginComplete:
            return "/api/v1"
        case .smsResend:
            return "/api/v2"
        case .gsmUpdate:
            return "/api/v2"
        }
    }

    var httpBody: Data? {
        switch self {
        case .otpQuickLoginInitialize(let request):
            return request?.asData
        case .loginComplete(let request):
            return request?.asData
        case .smsResend(let request):
            return request?.asData
        case .gsmUpdate(let request):
            return request?.asData
        }
    }
    
    var queryParameters: Parameters? {
        return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
        case .otpQuickLoginInitialize:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .loginComplete:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .smsResend:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        case .gsmUpdate:
            return [.contentType,
                    .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self))]
        }
    }
    
    var timeout: Double? {
        switch self {
        case .otpQuickLoginInitialize:
            return 10
        case .loginComplete:
            return 10
        case .smsResend:
            return 10
        case .gsmUpdate:
            return 10
        }
    }
    
    var accessToken: String? {
        switch self {
        case .otpQuickLoginInitialize:
            return nil
        case .loginComplete:
            return nil
        case .smsResend:
            return nil
        case .gsmUpdate:
            return nil
        }
    }
}
