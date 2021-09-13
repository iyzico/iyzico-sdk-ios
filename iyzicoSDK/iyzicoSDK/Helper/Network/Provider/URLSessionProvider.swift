//
//  URLSessionProvider.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 11.02.2021.
//

import Foundation

//final class Networking: ProviderProtocol {
//    
//    static let shared = Networking()
//
//    private var session: URLSessionProtocol
//    private var task: URLSessionDataTask
//
//    init(session: URLSessionProtocol = URLSession.shared) {
//        self.session = session
//        self.task = URLSessionDataTask()
//    }
//    
//    func request<T>(service: ServiceProtocol,
//                    type: T.Type,
//                    completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
//        let request = URLRequest(service: service)
//        log(request: request)
//        self.task = session.dataTask(request: request, completionHandler: { [weak self] (data, response, error) in
//            let httpResponse = response as? HTTPURLResponse
//            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
//        })
//        self.task.resume()
//    }
//    
//    private func handleDataResponse<T: Decodable>(data: Data?,
//                                                  response: HTTPURLResponse?,
//                                                  error: Error?,
//                                                  completion: (NetworkResponse<T>) -> ()) {
//        log(data: data, response: response, error: error)
//        guard error == nil else { return completion(.failure(.unknown)) }
//        guard let response = response else { return completion(.failure(.noJSONData)) }
//        
//        switch response.statusCode {
//        case 200...299:
//            guard let data = data,
//                  let model = try? JSONDecoder().decode(T.self, from: data) else { return completion(.failure(.unknown)) }
//            completion(.success(model))
//        default:
//            completion(.failure(.unknown))
//        }
//    }
//    
//    func cancelTask() {
//        self.task.cancel()
//    }
//    
//    //MARK: - Helper Methods
//    private func log(request: URLRequest){
//
//        let urlString = "URL: " + (request.url?.absoluteString ?? "")
//        let components = URLComponents(string: urlString)
//
//        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
//        let path = "\(components?.path ?? "")"
//        let query = "\(components?.query ?? "")"
//        let host = "\(components?.host ?? "")"
//
//        var requestLog = "\n🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐 REQUEST 🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐\n"
//        requestLog += "\(urlString)"
//        requestLog += "\n\n"
//        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
//        requestLog += "Host: \(host)\n"
//        for (key,value) in request.allHTTPHeaderFields ?? [:] {
//            requestLog += "\(key): \(value)\n"
//        }
//        if let body = request.httpBody{
//            let bodyString = String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded";
//            requestLog += "\n\(bodyString)\n"
//        }
//
//        requestLog += "\n🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐\n";
//        print(requestLog)
//    }
//
//    private func log(data: Data?, response: HTTPURLResponse?, error: Error?){
//
//        let urlString = "URL: " + (response?.url?.absoluteString ?? "")
//        let components = URLComponents(string: urlString)
//
//        let path = "\(components?.path ?? "")"
//        let query = "\(components?.query ?? "")"
//
//        var responseLog = "\n🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐 RESPONSE 🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐\n"
//        responseLog += "\(urlString)"
//        responseLog += "\n\n"
//
//        if let statusCode =  response?.statusCode{
//            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
//        }
//        if let host = components?.host{
//            responseLog += "Host: \(host)\n"
//        }
//        for (key,value) in response?.allHeaderFields ?? [:] {
//            responseLog += "\(key): \(value)\n"
//        }
//        if let body = data{
//            let bodyString = String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded";
//            responseLog += "\n\(bodyString)\n"
//        }
//        if let error = error{
//            responseLog += "\nError: \(error.localizedDescription)\n"
//        }
//
//        responseLog += "🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐\n";
//        print(responseLog)
//    }
//}
