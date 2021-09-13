//
//  MainVM.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.03.2021.
//

import Foundation

class MainVM: BaseVM {
    var balancesResponse: BalancesResponseModel?
    
    //MARK: - Requests
    func getBalances(onSuccess: @escaping (BalancesResponseModel?) -> Void,
                     onFailure: @escaping (String?) -> Void) {
        Networking.request(router: BalanceRouter.balances, shouldShowLoading: false)
        { [weak self] (response: BaseResponse<BalancesResponseModel>?) in
            self?.balancesResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }

    }
}
