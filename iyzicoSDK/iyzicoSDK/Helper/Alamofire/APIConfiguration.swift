//
//  APIConfiguration.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var scope: String? { get } //For encrypt algorithm
    var path: String { get }
    var apiVersion: String { get }
    var httpBody: Data? { get }
    var queryParameters: Parameters? { get }
    var headers: [HTTPHeaders]? { get }
    var timeout: Double? { get }
    var accessToken: String? { get }
}

extension APIConfiguration {    
    func asURLRequest() throws -> URLRequest {
        let url = try ServerConfiguration.baseURL.appending(apiVersion).asURL().appendingPathComponent(path)
        
        var urlComponents = URLComponents(string: url.absoluteString)
        
        //Query Parameters
        urlComponents?.queryItems = queryParameters?.map { key, value in
            return URLQueryItem(name: key, value: (value as? String)?.description)
        }
        
        var urlRequest = URLRequest(url: (urlComponents?.url!)!)
        
        //HTTP Method
        urlRequest.httpMethod = method.rawValue

        //Headers
        urlRequest.setValue(HTTPHeaders.contentType.value, forHTTPHeaderField: HTTPHeaders.contentType.key) //Instant
        headers?.forEach({ header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        })
        
        //Timeout
        urlRequest.timeoutInterval = timeout ?? 10
        
        //HTTP Body
        urlRequest.httpBody = httpBody

        return urlRequest
    }
}
