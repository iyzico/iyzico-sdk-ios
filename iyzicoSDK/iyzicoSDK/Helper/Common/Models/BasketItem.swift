//
//  BasketItem.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation

public struct BasketItem {
    
    public let id, price, name, category1: String?
    public let itemType: String?
    
    public init(id: String?, price: String?, name: String?, category1: String?, itemType: String?) {
        self.id = id
        self.price = price
        self.name = name
        self.category1 = category1
        self.itemType = itemType
    }
    
}
