//
//  Protocol.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 29.01.2021.
//

import Foundation

public protocol IyzicoDelegate: class {
    func didOperationSuccess(message: String)
    func didOperationFailed(state: ResultCode, message: String)
}
