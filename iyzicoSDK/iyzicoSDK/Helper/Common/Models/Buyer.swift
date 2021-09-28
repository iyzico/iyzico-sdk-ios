//
//  Buyer.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation

public struct Buyer {
    
    public let id, name, surname, identityNumber: String?
    public let email, gsmNumber, registrationAddress, city: String?
    public let country, ip: String?
    
    public init(id: String?, name: String?, surname: String?, identityNumber: String?, email: String?, gsmNumber: String?, registrationAddress: String?, city: String?, country: String?, ip: String?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.identityNumber = identityNumber
        self.email = email
        self.gsmNumber = gsmNumber
        self.registrationAddress = registrationAddress
        self.city = city
        self.country = country
        self.ip = ip
    }
    
}
