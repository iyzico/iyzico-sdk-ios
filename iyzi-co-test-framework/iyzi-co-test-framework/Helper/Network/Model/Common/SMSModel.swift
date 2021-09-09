//
//  SMSModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct SMSModel: Codable {
    let userUuid: String?
    let referenceCode: String?
    let verificationCode: String?
    
    enum CodingKeys: String, CodingKey {
        case userUuid = "userUuid"
        case referenceCode = "referenceCode"
        case verificationCode = "verificationCode"
    }
    
    public init(userUuid: String?,
                referenceCode: String?,
                verificationCode: String?) {
        self.userUuid = userUuid
        self.referenceCode = referenceCode
        self.verificationCode = verificationCode
    }
}
