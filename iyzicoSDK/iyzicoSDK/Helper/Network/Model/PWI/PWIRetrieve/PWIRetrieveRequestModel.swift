//
//  PWIRetrieveRequestModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 3.08.2021.
//

import Foundation
// MARK: - PWIRetrieveRequestModel
struct PWIRetrieveRequestModel: Codable {
    let checkoutToken: String?
    let locale: String?
}
