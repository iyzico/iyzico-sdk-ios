//
//  CashoutInitResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

struct InitResponseModel: Decodable {
    let initialRequestId: String?
    let memberExist: Bool?
    let checkoutToken: String?
    let checkoutTokenExpireTime: Int?
}
