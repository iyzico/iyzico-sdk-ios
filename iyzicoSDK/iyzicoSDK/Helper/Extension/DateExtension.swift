//
//  DateExtension.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 28.04.2022.
//

import Foundation

extension Date {
    public func sameTimeNextDay(
        inDirection direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current
    ) -> Date {
        let components = calendar.dateComponents(
            [.hour, .minute, .second, .nanosecond],
            from: self
        )
        
        return calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: .nextTime,
            direction: direction
        )!
    }
    
//    static public func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
//        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
//        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
//        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
//        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
//        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
//        
//        return (month: month, day: day, hour: hour, minute: minute, second: second)
//    }
}
