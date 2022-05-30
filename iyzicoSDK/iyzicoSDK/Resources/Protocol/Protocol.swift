//
//  Protocol.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 29.01.2021.
//

import Foundation

public protocol IyzicoDelegate: AnyObject {
    func didOperationSuccess(message: String)
    func didCashoutOperationSuccess(message: String, amount: String)
    func didOperationFailed(state: ResultCode, message: String)
}
