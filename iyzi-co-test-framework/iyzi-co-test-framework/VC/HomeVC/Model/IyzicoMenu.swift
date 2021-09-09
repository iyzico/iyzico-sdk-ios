//
//  IyzicoMenu.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 6.04.2021.
//

import Foundation

class IyzicoMenu {
    var image: String = ""
    var title: String = ""
    var sectionType: IyzicoMenuSectionType = .none
    var isExtended: Bool = false
    var paymentType: IyzicoHomePaymentTypes?
    
    init(image: String = "",
         title: String = "",
         sectionType: IyzicoMenuSectionType = .none,
         isExtended: Bool = false,
         paymentType: IyzicoHomePaymentTypes? = nil) {
        self.image = image
        self.title = title
        self.sectionType = sectionType
        self.isExtended = isExtended
        self.paymentType = paymentType
    }
}
