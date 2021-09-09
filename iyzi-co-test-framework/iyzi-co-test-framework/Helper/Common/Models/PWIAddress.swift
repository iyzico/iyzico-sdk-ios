//
//  PWIAddress.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation

public struct PWIAddress {

    public let address, contactName, city, country: String?
    
    public init(address: String?, contactName: String?, city: String?, country: String?) {
        self.address = address
        self.contactName = contactName
        self.city = city
        self.country = country
    }
}
