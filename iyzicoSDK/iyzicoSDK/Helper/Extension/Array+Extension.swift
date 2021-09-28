//
//  Array+Extension.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 2.03.2021.
//

import Foundation

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}

extension Sequence where Iterator.Element : Hashable {

    func intersects<S : Sequence>(with sequence: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        let sequenceSet = Set(sequence)
        return self.contains(where: sequenceSet.contains)
    }
}
