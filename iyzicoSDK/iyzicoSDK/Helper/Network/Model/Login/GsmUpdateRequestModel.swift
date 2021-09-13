//
//  GsmUpdateRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 12.04.2021.
//

import Foundation

struct GsmUpdateRequestModel: Encodable {
    let userUuid: String?
    let referenceCode: String?
    let gsmNumber: String?
    let channelType: String?
}
