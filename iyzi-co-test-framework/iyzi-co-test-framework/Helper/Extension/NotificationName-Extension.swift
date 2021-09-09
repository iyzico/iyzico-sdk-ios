//
//  NotificationName-Extension.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 22.12.2020.
//

import Foundation

extension Notification.Name {
    static let bottomSheetHeight = Notification.Name("bottomSheetHeight")
    static let navBarConfiguration = Notification.Name("navBarConfiguration")
    static let hideBottomBar = Notification.Name("hideBottomBar")
    static let keyboardButton = Notification.Name("keyboardButton")
    static let didTappedButtonAboveKeyboard = Notification.Name("didTappedButtonAboveKeyboard")
    static let showAppCancelPopUp = Notification.Name("showAppCancelPopUp")
    static let completeOrder = Notification.Name("completeOrder")
    static let didFinishTimerAtPayWithIyzicoFlow = Notification.Name("didFinishTimerAtPayWithIyzicoFlow")
    static let restartTimerAtPayWithIyzicoFlow = Notification.Name("restartTimerAtPayWithIyzicoFlow")
    static let removePwiTimerObservers = Notification.Name("removePwiTimerObservers")
    static let getBalances = Notification.Name("getBalances")
    static let updatePrice = Notification.Name("updatePrice")
}
