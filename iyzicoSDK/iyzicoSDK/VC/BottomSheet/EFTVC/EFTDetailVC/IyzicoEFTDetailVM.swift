//
//  IyzicoEFTDetailVM.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 28.04.2021.
//

import Foundation

class IyzicoEFTDetailVM: BaseVM {
    //MARK: - Navigated Properties
    var protectedBankAccount: ProtectedBankAccountsResponseModel?
    var priceForLoad: String?
    var priceForPayment: String?
    var navigatedReferenceCode: String?
    var bankTransferPaymentID: Int?
}

//MARK:-
extension IyzicoEFTDetailVM {
    func payWithBankTransferNotify(onSuccess: @escaping (PaymentBankTransferResponseModel?) -> Void,
                             onFailure: @escaping (String?) -> Void) {
        
        
        let requestModel = PaymentBankTransferNotifyRequestModel(bankTransferPaymentID: bankTransferPaymentID)
        
        Networking.request(router: PWIRouter.paymentWithBankTransferNotify(requestModel: requestModel))
        { [weak self] (response: PaymentBankTransferResponseModel) in
            onSuccess(response)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
}
