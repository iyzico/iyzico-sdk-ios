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

extension Array where Element: Equatable
{
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}

extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
