//
//  QuickRegisterInitializeResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 8.03.2021.
//

import Foundation

struct QuickRegisterInitializeResponseModel: Decodable {
    let referenceCode: String?
    let expireDurationInSeconds: Int?
    let userUuid: String?
    let gsmVerified: Bool?
    let maskedGsmNumber: String?
}
