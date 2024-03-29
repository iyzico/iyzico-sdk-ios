//
//  LoginCompleteResponseModel.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct LoginCompleteResponseModel: Decodable {
    let accessToken: String?
    let expiresIn: Int?
}
