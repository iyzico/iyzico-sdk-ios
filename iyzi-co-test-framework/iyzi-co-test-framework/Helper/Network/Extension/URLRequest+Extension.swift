//
//  URLRequest+Extension.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 11.02.2021.
//

import Foundation

//extension URLRequest {
//
//    init(service: ServiceProtocol) {
//        let urlComponents = URLComponents(service: service)
//
//        self.init(url: urlComponents.url!)
//
//        httpMethod = service.method.rawValue
//        service.headers?.forEach({ header in
//            addValue(header.value, forHTTPHeaderField: header.key)
//        })
//        
//        if case let .requestBodyParameters(requestModelBody) = service.task, service.parametersEncoding == .json {
//            httpBody = try? JSONEncoder().encode(requestModelBody)
//        }
//        if case let .requestBodyAndQueryString(requestModelBody, _) = service.task, service.parametersEncoding == .jsonAndQueryString {
//            httpBody = try? JSONEncoder().encode(requestModelBody)
//        }
//    }
//}
