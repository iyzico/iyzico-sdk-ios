//
//  PayWithBalanceResponseModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 4.08.2021.
//

import Foundation

struct PayWithBalanceResponseModel: Codable {
    let status: String?
    let systemTime: Int?
    let token: String?
    let callbackURL: String?
    
    enum CodingKeys: String, CodingKey {
        case status, systemTime, token
        case callbackURL = "callbackUrl"
    }
}
