//
//  PWIRouter.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 2.08.2021.
//

import Foundation
import Alamofire

enum PWIRouter: APIConfiguration {
    case initPWI(requestModel: PWIinitRequestModel?)
    case retrievePWI(requestModel: PWIRetrieveRequestModel?)
    case retrieveInstallments(requestModel: InstallmentRequestModel?)
    case payWithBalance(requestModel: PayWithBalanceRequestModel?)
    case mixedPaymentWithSavedCard(requestModel: MixedPaymentCardRequestModel?)
    case mixedPaymentWithNewCard(requestModel: MixedPaymentCardRequestModel?)
    case paymentWithNewCard(requestModel: PaymentCardRequestModel?)
    case paymentWithNewCard3ds(requestModel: PaymentCardRequestModel?)
    case paymentWithBankTransfer(requestModel: PaymentBankTransferRequestModel?)
    case paymentWithBankTransferNotify(requestModel: PaymentBankTransferNotifyRequestModel?)
    
    var method: HTTPMethod {
        switch self {
            case .initPWI, .retrievePWI ,
                 .retrieveInstallments, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return .post
        }
    }
    
    var scope: String? {
        switch self {
            case .initPWI, .retrievePWI,
                 .retrieveInstallments, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return "fund"
                
        }
    }
    
    var path: String {
        switch self {
            case .initPWI:
                return "/pay-with-iyzico/third-party/checkout/init"
            case .retrievePWI:
                return "/pay-with-iyzico/third-party/checkout/retrieve"
            case .retrieveInstallments:
                return "/pay-with-iyzico/third-party/instalment"
            case .payWithBalance:
                return "/pay-with-iyzico/third-party/auth"
            case .mixedPaymentWithSavedCard:
                return "/pay-with-iyzico/third-party/auth/mix-payment"
            case .mixedPaymentWithNewCard:
                return "/pay-with-iyzico/third-party/auth/mix-payment"
            case .paymentWithNewCard:
                return "/pay-with-iyzico/third-party/auth/ecom"
            case .paymentWithNewCard3ds:
                return "/pay-with-iyzico/third-party/auth/initialize3ds/ecom"
            case .paymentWithBankTransfer:
                return "/pay-with-iyzico/third-party/bank-transfer/initialize"
            case .paymentWithBankTransferNotify:
                return "/pay-with-iyzico/third-party/bank-transfer/notify"
        }
    }
    
    var apiVersion: String {
        switch self {
            case .initPWI, .retrievePWI,
                 .retrieveInstallments, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return "/api/v1"
        }
    }
    
    var httpBody: Data? {
        switch self {
            case .initPWI(let requestModel):
                return requestModel?.asData
            case .retrievePWI(let requestModel):
                return requestModel?.asData
            case .retrieveInstallments(let requestModel):
                return requestModel?.asData
            case .payWithBalance(let requestModel):
                return requestModel?.asData
            case .mixedPaymentWithSavedCard(let requestModel):
                return requestModel?.asData
            case .mixedPaymentWithNewCard(let requestModel):
                return requestModel?.asData
            case .paymentWithNewCard(let requestModel):
                return requestModel?.asData
            case .paymentWithNewCard3ds(let requestModel):
                return requestModel?.asData
            case .paymentWithBankTransfer(let requestModel):
                return requestModel?.asData
            case .paymentWithBankTransferNotify(let requestModel):
                return requestModel?.asData

        }
    }
    
    var queryParameters: Parameters? {
        switch self {
            case .initPWI, .retrievePWI,
                 .retrieveInstallments, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return QueryModel(locale: SDKManager.language).asDictionaryWithoutNilValues
        }
    }
    
    var headers: [HTTPHeaders]? {
        switch self {
            case .initPWI:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self, isInitPWI: true))]
                
            case .retrievePWI:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self, isInitPWI: true))]
                
            case .retrieveInstallments:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self, isInitPWI: true)),
                        .xiyziToken(value: SDKManager.checkoutToken ?? "")]
                
            case .payWithBalance:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self, isInitPWI: true)),
                        .xiyziToken(value: SDKManager.checkoutToken ?? "")]
                
            case .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return [.contentType,
                        .authentication(value: EncryptManager.shared.getEncryptedAuthenticationToken(apiConfiguration: self, isInitPWI: true)),
                        .xiyziToken(value: SDKManager.checkoutToken ?? "")]
                
        }
    }
    
    var timeout: Double? {
        switch self {
            case .initPWI, .retrievePWI,
                 .retrieveInstallments, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return 10
        }
    }
    
    var accessToken: String? {
        switch self {
            case .initPWI, .retrieveInstallments:
                return nil
            case .retrievePWI, .payWithBalance,
                 .mixedPaymentWithSavedCard, .mixedPaymentWithNewCard,
                 .paymentWithNewCard, .paymentWithNewCard3ds,
                 .paymentWithBankTransfer, .paymentWithBankTransferNotify:
                return DefaultsManager.get(forKey: .accessToken, type: String.self)
        }
    }
}
