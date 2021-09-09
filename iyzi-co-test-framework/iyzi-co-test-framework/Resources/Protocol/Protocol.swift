//
//  Protocol.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 29.01.2021.
//

import Foundation

public protocol IyzicoDelegate: class {
    func didOperationSuccess(state: InternalMessageState, message: String)
    func didOperationFailed(state: InternalMessageState, message: String)
}
