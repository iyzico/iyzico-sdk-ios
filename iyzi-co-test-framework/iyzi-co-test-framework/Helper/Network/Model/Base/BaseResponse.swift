//
//  BaseResponse.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let status: String?
    let systemTime: Int?
    let data: T?
    let errorCode: String?
    let errorMessage: String?
    let consumerErrorMessage: String?
}
