//
//  PWIinitResponseModel.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation

struct PWIinitResponseModel: Decodable {
    let checkoutToken: String?
    let checkoutTokenExpireTime: Int?
}
