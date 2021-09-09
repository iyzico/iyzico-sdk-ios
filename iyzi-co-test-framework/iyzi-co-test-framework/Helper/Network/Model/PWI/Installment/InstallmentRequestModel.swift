//
//  InstallmentRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 3.08.2021.
//

import Foundation

struct InstallmentRequestModel: Codable {
    let locale, price, binNumber: String?
}
