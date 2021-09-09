//
//  TransferVM.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

class TransferVM: BaseVM {
    //MARK: - Properties
    var cashoutCompleteResponse: CashoutCompleteResponseModel?
    
    //MARK: - Navigated Properties
    var navigatedInitializeResponse: InitResponseModel?
    
    //MARK: - Request
    func getCashoutComplete(amount: String?,
                            onSuccess: @escaping (CashoutCompleteResponseModel?) -> Void,
                            onFailure: @escaping (String?, NetworkStatusTypes) -> Void) {
        let requestModel = CashoutCompleteRequestModel(amount: amount,
                                                       initialRequestId: navigatedInitializeResponse?.initialRequestId,
                                                       currencyType: "TRY")
        Networking.request(router: CashoutRouter.completeCashoutToBalance(requestModel: requestModel))
        { [weak self] (response: BaseResponse<CashoutCompleteResponseModel>?) in
            self?.cashoutCompleteResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, networkStatusType) in
            onFailure(error, networkStatusType)
        }
    }
}
