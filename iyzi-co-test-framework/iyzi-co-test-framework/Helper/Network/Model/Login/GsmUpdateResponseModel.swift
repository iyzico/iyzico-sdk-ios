//
//  GsmUpdateResponseModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 12.04.2021.
//

import Foundation

struct GsmUpdateResponseModel: Decodable {
    let userUuid: String?
    let expireDurationInSeconds: Int?
    let referenceCode: String?
    let gsmVerified: Bool?
    let maskedGsmNumber: String?
}
