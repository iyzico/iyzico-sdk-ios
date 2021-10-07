//
//  QuickLoginInitializeResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct QuickLoginInitializeResponseModel: Decodable {
    let referenceCode: String?
    let expireDurationInSeconds: Int?
    let userUuid: String?
    let gsmVerified: Bool?
    let maskedGsmNumber: String?
    let gsmNumber: String?
}
