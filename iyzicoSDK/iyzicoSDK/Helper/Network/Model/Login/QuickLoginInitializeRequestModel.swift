//
//  QuickLoginInitializeRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct QuickLoginInitializeRequestModel: Encodable {
    let email: String?
    let clientIp: String?
    let loginChannel: String?
}
