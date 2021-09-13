//
//  BasketItem.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation

public struct IyzicoBasketItem {
    
    public let id, price, name, category1: String?
    public let itemType: String?
    
    public init(itemCategory: String, productId: String?, itemType: String, itemName: String, price: String?) {
        self.id = productId
        self.price = price
        self.name = itemType
        self.category1 = itemCategory
        self.itemType = itemType
    }
    
}
