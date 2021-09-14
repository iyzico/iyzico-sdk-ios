//
//  File.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation
import CommonCrypto.CommonHMAC

class EncryptManager {
//    private let clientId = "qumpara"
//    private let clientSecret = "qumparaSecret"
    
    static let shared = EncryptManager()
    
    func getEncryptedAuthenticationToken(apiConfiguration: APIConfiguration,isInitPWI: Bool = false) -> String {
        let salt = UUID().uuidString
        let apiVersion = apiConfiguration.apiVersion
        let path = apiConfiguration.path
        let scope = apiConfiguration.scope
        let accessToken = apiConfiguration.accessToken
        var payload = String()
        var merchantApiKey = String()
        var merchantSecretKey = String()
        var secretKey = String()
        
        if apiConfiguration.httpBody == nil{
            payload = apiVersion + path
        }
        else {
            payload = apiVersion + path + getJsonString(httpBody: apiConfiguration.httpBody)
        }

        let dataToEncrypt = salt + payload
        guard let validatedClientId = SDKManager.clientId else {
            Iyzico.delegate?.didOperationFailed(state: .clientIdError,
                                                message: ResultCode.clientIdError.message)
            return ""
        }
        guard let validatedClientSecret = SDKManager.clientSecretKey else {
            Iyzico.delegate?.didOperationFailed(state: .clientSecretKeyError,
                                                message: ResultCode.clientSecretKeyError.message)
            return ""
        }
        
        if isInitPWI {
            
            guard let validatedMerchantApiKey = SDKManager.merchantApiKey else {
                Iyzico.delegate?.didOperationFailed(state: .merchantApiKeyError,
                                                    message: ResultCode.merchantApiKeyError.message)
                return ""
            }
            
            guard let validatedMerchantSecretKey = SDKManager.merchantSecretKey else {
                Iyzico.delegate?.didOperationFailed(state: .merchantSecretKeyError,
                                                    message: ResultCode.merchantSecretKeyError.message)
                return ""
            }
            
            merchantApiKey = "&merchantApiKey:" + validatedMerchantApiKey
            merchantSecretKey = "&merchantSecretKey:" + validatedMerchantSecretKey
            secretKey = "\(validatedClientSecret):\(validatedMerchantSecretKey)"
        }
       
        var encryptedData = ""
        if isInitPWI {
            encryptedData = encryptToHmacSHA256(clientSecret: secretKey, message: dataToEncrypt)
        } else {
            encryptedData = encryptToHmacSHA256(clientSecret: validatedClientSecret, message: dataToEncrypt)
        }
        
        let clientIdParameter = "clientId:" + validatedClientId
        let clientSecretParameter = "&clientSecret:" + validatedClientSecret
        let saltParameter = "&salt:" + salt
        let scopeParameter = (scope == nil) ? "" : "&scope:" + (scope ?? "")
        let signatureParameter = "&signature:" + encryptedData
        let bearerTokenParameter = (accessToken == nil) ? "" : "&bearerToken:" + (accessToken ?? "")
        
        var authorizationString = ""
        if isInitPWI {
            authorizationString = clientIdParameter + clientSecretParameter + merchantApiKey + merchantSecretKey + saltParameter  + signatureParameter + bearerTokenParameter
        } else {
            authorizationString = clientIdParameter + clientSecretParameter + saltParameter + scopeParameter + signatureParameter + bearerTokenParameter
        }
        
        let base64EncodedAuthorization = authorizationString.base64Encoded()?.description ?? ""
        return "IYZ-TP-v1 " + base64EncodedAuthorization
    }
    
    private func getJsonString(httpBody: Data?) -> String { String(data: httpBody!, encoding: .utf8) ?? "" }
    
    private func encryptToHmacSHA256(clientSecret: String, message: String) -> String { message.hmac(algorithm: .SHA256, key: clientSecret) }
}

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate() // !! UPDATED: Error: deallocate(capacity:)' is unavailable: Swift currently only supports freeing entire heap blocks, use deallocate() instead
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
}


