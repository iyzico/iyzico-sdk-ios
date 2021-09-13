//
//  BalancesQueryRequestModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation

struct BalancesQueryRequestModel: Encodable {
    let locale: String?
    let channelType: String?
}
