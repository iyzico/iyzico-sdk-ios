//
//  ProtectedBankAccountsOuterResponseModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 28.04.2021.
//

import Foundation

struct ProtectedBankAccountsOuterResponseModel: Decodable {
    let referenceCode: String?
    let items: [ProtectedBankAccountsResponseModel]?
}
