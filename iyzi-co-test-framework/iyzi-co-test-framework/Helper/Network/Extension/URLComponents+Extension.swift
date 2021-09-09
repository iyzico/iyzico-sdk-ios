//
//  URLComponents+Extension.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 11.02.2021.
//

import Foundation

//extension URLComponents {
//
//    init(service: ServiceProtocol) {
//        let url = service.baseURL.appendingPathComponent(service.path)
//        self.init(url: url, resolvingAgainstBaseURL: false)!
//        if case let .requestBodyParameters(requestModelBody) = service.task,
//           service.parametersEncoding == .url {
//            queryItems = requestModelBody?.asDictionary.map { key, value in
//                return URLQueryItem(name: key, value: String(describing: value))
//            }
//        }
//        if case let .requestBodyAndQueryString(_, requestModelQuery) = service.task,
//           service.parametersEncoding == .jsonAndQueryString {
//            queryItems = requestModelQuery?.asDictionary.map { key, value in
//                return URLQueryItem(name: key, value: String(describing: value))
//            }
//        }
//    }
//}
