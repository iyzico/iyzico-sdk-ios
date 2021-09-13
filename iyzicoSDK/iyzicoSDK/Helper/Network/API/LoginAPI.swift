//
//  ExampleAPI.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 11.02.2021.
//

import Foundation

//enum LoginAPI: ServiceProtocol {
//
//    case otpQuickLoginInitialize(requestModel: QuickLoginInitializeRequestModel?)
//    case loginComplete(requestModel: LoginCompleteRequestModel)
//
//    var path: String {
//        switch self {
//        case .otpQuickLoginInitialize:
//            return "/members/third-party/otp-quick-login-initialize/"
//        case .loginComplete:
//            return "/members/third-party/login-complete"
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .otpQuickLoginInitialize:
//            return .post
//        case .loginComplete:
//            return .post
//        }
//    }
//
//    var task: Task {
//        let queryParametersModel = QueryModel(locale: "tr")
//        switch self {
//        case .otpQuickLoginInitialize(let request):
//            return .requestBodyAndQueryString(request, queryParametersModel)
//        case .loginComplete(let request):
//            return .requestBodyAndQueryString(request, queryParametersModel)
//        }
//    }
//
//    var headers: [HTTPHeader]? {
//        switch self {
//        case .otpQuickLoginInitialize:
//            return [.contentType, .authorization]
//        case .loginComplete:
//            return [.contentType, .authorization]
//        }
//    }
//
//    var parametersEncoding: ParametersEncoding {
//        switch self {
//        case .otpQuickLoginInitialize:
//            return .jsonAndQueryString
//        case .loginComplete:
//            return .jsonAndQueryString
//        }
//    }
//}
