//
//  LoginCompleteRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct LoginCompleteRequestModel: Encodable {
    let loginSmsVerification: SMSModel?
    let clientIp: String?
    let loginChannel: String?
    
    enum CodingKeys: String, CodingKey {
        case loginSmsVerification = "loginSmsVerification"
        case clientIp = "clientIp"
        case loginChannel = "loginChannel"
    }
}
