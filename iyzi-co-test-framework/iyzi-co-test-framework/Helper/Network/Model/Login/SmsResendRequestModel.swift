//
//  SmsResendRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation

struct SmsResendRequestModel: Encodable {
    let userUuid: String?
    let referenceCode: String?
    let channelType: String?
}
