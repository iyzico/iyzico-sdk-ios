//
//  Timer.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 19.12.2020.
//

import Foundation
import UIKit



// MARK: - TIMER
extension UILabel {
    
    public func startTimer(time: Int, completionHandler: ((Int) -> Void)? = nil){
        var second = time
        self.text = self.timeString(time: TimeInterval(second))
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Constant.shared.countDown), repeats: true) { timer in
            second -= Constant.shared.countDown
            self.text = self.timeString(time: TimeInterval(second),timer: timer)
            completionHandler?(second)
        }
    }
    
    public func startTimerWithReturn(time: Int, completionHandler: ((Int) -> Void)? = nil) -> Timer {
        var second = time
        self.text = self.timeString(time: TimeInterval(second))
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Constant.shared.countDown), repeats: true) { timer in
            second -= Constant.shared.countDown
            self.text = self.timeString(time: TimeInterval(second),timer: timer)
            completionHandler?(second)
        }
        return timer
    }
    
    
    func timeString(time:TimeInterval,timer: Timer? = nil) -> String {
        
        let minutes = Int(time) / Constant.shared.second % Constant.shared.second
        let seconds = Int(time) % Constant.shared.second
        
        if minutes == Constant.shared.invalidateTimer && seconds == Constant.shared.invalidateTimer {
            print("done")
            timer?.invalidate()
        } else if minutes == Constant.shared.invalidateTimer {
            changeTimerColor()
        }
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func changeTimerColor() {
        self.textColor = .yellowOrange
    }
    
    
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
