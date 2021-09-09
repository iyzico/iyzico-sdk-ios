//
//  AttributedStringModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 19.03.2021.
//

import UIKit

struct AttributedStringModel {
    let text: String
    let font: UIFont
    let color: UIColor
    
    init(text: String, font: UIFont, color: UIColor) {
        self.text = text
        self.font = font
        self.color = color
    }
}
