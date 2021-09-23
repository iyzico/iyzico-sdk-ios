//
//  AlamofireNetworking.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import Alamofire
import CommonCrypto
import CryptoKit

class Networking {
    static let loadingVC = AlertManager()
  
    static let session = Session(delegate:CustomSessionDelegate())
    
    static func request<T: Decodable>(router: URLRequestConvertible,
                                      shouldShowLoading: Bool = true,
                                      success: @escaping (T) -> Void,
                                      failure: @escaping (String?, String?, NetworkStatusTypes) -> Void) {
        if shouldShowLoading {
            showLoading() {
               
                
                session.request(router).responseDecodable { (response: AFDataResponse<T>) in
                    printLog(response: response)
                    let jsonString = String(bytes: response.data ?? Data(), encoding: .utf8) ?? ""
                    let dict = jsonString.convertToDictionary()
                    let statusMessage = dict?["status"] as? String
                    let consumerErrorMessage = dict?["consumerErrorMessage"] as? String
                    let errorMessage = dict?["errorMessage"] as? String
                    let errorCode = dict?["errorCode"] as? String
                    let error = consumerErrorMessage != nil ? consumerErrorMessage : errorMessage
                    switch response.response?.statusCode ?? 204 { //204-> No Content
                    case 200..<300:
                        switch response.result {
                        case .success(let data):
                            hideLoading()
                            if statusMessage == NetworkStatusTypes.success.rawValue {
                                success(data)
                            }
                            else {
                                failure(error, errorCode, .responseFailure)
                            }
                        case .failure( _):
                            hideLoading()
                            let validatedError = error != nil ? error : "Hata"
                            failure(validatedError,errorCode, .failure)
                        }
                        
                    default:
                        hideLoading()
                        failure(error, errorCode, .failure)
                    }
                }
            }
        }
        else {
            session.request(router).responseDecodable { (response: AFDataResponse<T>) in
                #if DEBUG
                    printLog(response: response)
                #endif
                let jsonString = String(bytes: response.data ?? Data(), encoding: .utf8) ?? ""
                let dict = jsonString.convertToDictionary()
                let statusMessage = dict?["status"] as? String
                let consumerErrorMessage = dict?["consumerErrorMessage"] as? String
//                let errorCode = dict?["errorCode"] as? String
//                let fullErrorMessage = (consumerErrorMessage ?? "") + (errorCode ?? "")
                let errorMessage = dict?["errorMessage"] as? String
                let errorCode = dict?["errorCode"] as? String
                let error = consumerErrorMessage != nil ? consumerErrorMessage : errorMessage
                switch response.response?.statusCode ?? 204 { //204-> No Content
                case 200..<300:
                    switch response.result {
                    case .success(let data):
                        if statusMessage == NetworkStatusTypes.success.rawValue {
                            success(data)
                        }
                        else {
                            failure(error, errorCode, .responseFailure)
                        }
                    case .failure:
                        let validatedError = error != nil ? error : "Hata"
                        failure(validatedError, errorCode, .failure)
                    }
                default:
                    failure(error, errorCode, .failure)
                }
            }
        }
    }
    
    static private func printLog<T: Decodable>(response: AFDataResponse<T>) {
        print("\n\n\n")
        print("🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐")
        debugPrint(response)
//        debugPrint(response.result)
        print("🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐🌐")
        print("\n\n\n")
    }
    
    private static func showLoading(completionHandler: @escaping () -> Void) {
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.modalPresentationStyle = .overFullScreen
        UIApplication.getPresentedViewController()?.present(loadingVC, animated: true, completion: {
            completionHandler()
        })
    }
    
    private static func hideLoading() {
        loadingVC.dismiss(animated: true, completion: nil)
    }
    
  
   
   
  
}

extension Networking {
    static func requestWithNoBaseResponse<T: Decodable>(router: URLRequestConvertible,
                                      shouldShowLoading: Bool = true,
                                      success: @escaping (T) -> Void,
                                      failure: @escaping (String?, NetworkStatusTypes) -> Void) {
        if shouldShowLoading {
            showLoading() {
                session.request(router).responseDecodable { (response: (AFDataResponse<T>)) in
                    printLog(response: response)
                    let jsonString = String(bytes: response.data ?? Data(), encoding: .utf8) ?? ""
                    let dict = jsonString.convertToDictionary()
                    let statusMessage = dict?["status"] as? String
                    let consumerErrorMessage = dict?["consumerErrorMessage"] as? String
                    
                    switch response.response?.statusCode ?? 204 { //204-> No Content
                        case 200..<300:
                            switch response.result {
                                case .success(let data):
                                    hideLoading()
                                    if statusMessage == NetworkStatusTypes.success.rawValue {
                                        success(data)
                                    }
                                    else {
                                        failure(consumerErrorMessage, .responseFailure)
                                    }
                                case .failure:
                                    hideLoading()
                                    let validatedError = consumerErrorMessage != nil ? consumerErrorMessage : "Hata"
                                    failure(validatedError, .failure)
                            }
                        default:
                            hideLoading()
                            failure(consumerErrorMessage, .failure)
                    }
                }
            }
        }
        else {
            session.request(router).responseDecodable { (response: AFDataResponse<T>) in
                #if DEBUG
                printLog(response: response)
                #endif
                let jsonString = String(bytes: response.data ?? Data(), encoding: .utf8) ?? ""
                let dict = jsonString.convertToDictionary()
                let statusMessage = dict?["status"] as? String
                let consumerErrorMessage = dict?["consumerErrorMessage"] as? String
                //                let errorCode = dict?["errorCode"] as? String
                //                let fullErrorMessage = (consumerErrorMessage ?? "") + (errorCode ?? "")
                
                switch response.response?.statusCode ?? 204 { //204-> No Content
                    case 200..<300:
                        switch response.result {
                            case .success(let data):
                                if statusMessage == NetworkStatusTypes.success.rawValue {
                                    success(data)
                                }
                                else {
                                    failure(consumerErrorMessage, .responseFailure)
                                }
                            case .failure:
                                let validatedError = consumerErrorMessage != nil ? consumerErrorMessage : "Hata"
                                failure(validatedError, .failure)
                        }
                    default:
                        failure(consumerErrorMessage, .failure)
                }
            }
        }
    }

}

//MARK:- SSL PINNING
class CustomSessionDelegate: SessionDelegate {
    private static let publicKeyHash = "9pfml4d3n7mXEa4UXu0k6jTHoVVPYLwsVWJbY1kn7kM="
    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    override func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             didReceive challenge: URLAuthenticationChallenge,
                             completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return
        }
        if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
            // Server public key
            guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            guard let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            let data:Data = serverPublicKeyData as Data
            // Server Hash key
            let serverHashKey = sha256(data: data)
            // Local Hash Key
            let publickKeyLocal = type(of: self).publicKeyHash
            if (serverHashKey == publickKeyLocal) {
                // Success! This is our server
                print("Public key pinning is successfully completed")
                completionHandler(.useCredential, URLCredential(trust:serverTrust))
                return
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
        }
    }
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        
        
        return Data(hash).base64EncodedString()
    }
}
