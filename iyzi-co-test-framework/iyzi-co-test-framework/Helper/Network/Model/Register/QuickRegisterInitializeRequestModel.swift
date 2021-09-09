//
//  QuickRegisterInitializeRequestModel.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 8.03.2021.
//

import Foundation

struct QuickRegisterInitializeRequestModel: Encodable {
  
    
    let name: String?
    let surname: String?
    let email: String?
    let phoneNumber: String?
    let registerChannel: String?
    var outlineAgreementStatus: String?
    var pdppPermission: String?
    var communicationsPermission: String?
    
    
    internal init(name: String?, surname: String?, email: String?, phoneNumber: String?, registerChannel: String?) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.registerChannel = registerChannel
    }
  
    internal init(name: String?, surname: String?, email: String?, phoneNumber: String?, registerChannel: String?, outlineAgreementStatus: String, pdppPermission: String, communicationsPermission: String?) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.registerChannel = registerChannel
        self.outlineAgreementStatus = outlineAgreementStatus
        self.pdppPermission = pdppPermission
        self.communicationsPermission = communicationsPermission
    }
    
    internal init(name: String?, surname: String?, email: String?, phoneNumber: String?, registerChannel: String?, outlineAgreementStatus: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.registerChannel = registerChannel
        self.outlineAgreementStatus = outlineAgreementStatus
    }
    
    internal init(name: String?, surname: String?, email: String?, phoneNumber: String?, registerChannel: String?, outlineAgreementStatus: String, pdppPermission: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.registerChannel = registerChannel
        self.outlineAgreementStatus = outlineAgreementStatus
        self.pdppPermission = pdppPermission
    }
    
    internal init(name: String?, surname: String?, email: String?, phoneNumber: String?, registerChannel: String?, outlineAgreementStatus: String, communicationsPermission: String?) {
        self.name = name
        self.surname = surname
        self.email = email
        self.phoneNumber = phoneNumber
        self.registerChannel = registerChannel
        self.outlineAgreementStatus = outlineAgreementStatus
        self.communicationsPermission = communicationsPermission
    }
    
}
