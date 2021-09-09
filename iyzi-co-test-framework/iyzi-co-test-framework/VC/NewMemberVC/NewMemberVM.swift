//
//  NewMemberVM.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 3.03.2021.
//

import Foundation

class NewMemberVM: BaseVM {
    //MARK: - Responses
    var loginInitializeResponse: QuickLoginInitializeResponseModel?
    var registerInitializeResponse: QuickRegisterInitializeResponseModel?
    var initializeResponse: InitResponseModel?
    var PWIinitializeResponse: PWIinitResponseModel?
    var gsmUpdateResponse: GsmUpdateResponseModel?
    
    //MARK: - Internal Properties
    var isUserChangedEmailAddress: Bool = false
    var isPhoneNumberChanged: Bool = false
    var phoneNumber: String?
    var isUserNavigatedFromOTP: Bool = false
    
    //MARK: - Requests
    func getGsmUpdate(phone: String?,
                      shouldShowLoading: Bool,
                      onSuccess: @escaping (GsmUpdateResponseModel?) -> Void,
                      onFailure: @escaping (String?) -> Void) {
        
        let model = loginInitializeResponse
        var userUuid: String?
        var referenceCode: String?
        #warning("change in prod gms number")
        if model == nil {
            userUuid = registerInitializeResponse?.userUuid
            referenceCode = registerInitializeResponse?.referenceCode
        } else {
            userUuid = model?.userUuid
            referenceCode = model?.referenceCode
        }
        let requestModel = GsmUpdateRequestModel(userUuid: userUuid,
                                                 referenceCode: referenceCode,
                                                 gsmNumber: phone,
                                                 channelType: "THIRD_PARTY_APP")
        Networking.request(router: LoginRouter.gsmUpdate(requestModel: requestModel),
                           shouldShowLoading: shouldShowLoading)
        { [weak self] (response: BaseResponse<GsmUpdateResponseModel>?) in
            self?.gsmUpdateResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    func getLoginInitialize(email: String?,
                            clientIp: String?,
                            loginChannel: String?,
                            shouldShowLoading: Bool,
                            onSuccess: @escaping (QuickLoginInitializeResponseModel?) -> Void,
                            onFailure: @escaping (String?) -> Void) {
        let requestModel = QuickLoginInitializeRequestModel(email: email?.lowercased(),
                                                            clientIp: clientIp,
                                                            loginChannel: loginChannel)
        Networking.request(router: LoginRouter.otpQuickLoginInitialize(requestModel: requestModel),
                           shouldShowLoading: shouldShowLoading)
        { [weak self] (response: BaseResponse<QuickLoginInitializeResponseModel>?) in
            self?.loginInitializeResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
   
    func getRegisterInitialize(name: String?,
                               surname: String?,
                               email: String?,
                               phoneNumber: String?,
                               registerChannel: String?,
                               outlineAgreementStatus: String? = nil,
                               pdppPermission: String? = nil,
                               communicationsPermission: String? = nil,
                               shouldShowLoading: Bool,
                               onSuccess: @escaping (QuickRegisterInitializeResponseModel?) -> Void,
                               onFailure: @escaping (String?) -> Void) {
        
        var requestModel: QuickRegisterInitializeRequestModel?
        
        if !ValidationManager.nilValidation(text: pdppPermission) && !ValidationManager.nilValidation(text: communicationsPermission) {
            requestModel = QuickRegisterInitializeRequestModel(name: name,
                                                               surname: surname,
                                                               email: email?.lowercased(),
                                                               phoneNumber: phoneNumber,
                                                               registerChannel: registerChannel,
                                                               outlineAgreementStatus: outlineAgreementStatus ?? "")
        } else if !ValidationManager.nilValidation(text: pdppPermission) && ValidationManager.nilValidation(text: communicationsPermission) {
            requestModel = QuickRegisterInitializeRequestModel(name: name,
                                                               surname: surname,
                                                               email: email?.lowercased(),
                                                               phoneNumber: phoneNumber,
                                                               registerChannel: registerChannel,
                                                               outlineAgreementStatus: outlineAgreementStatus ?? "",
                                                               communicationsPermission: communicationsPermission ?? "")
        } else if ValidationManager.nilValidation(text: pdppPermission) && !ValidationManager.nilValidation(text: communicationsPermission) {
            requestModel = QuickRegisterInitializeRequestModel(name: name,
                                                               surname: surname,
                                                               email: email?.lowercased(),
                                                               phoneNumber: phoneNumber,
                                                               registerChannel: registerChannel,
                                                               outlineAgreementStatus: outlineAgreementStatus ?? "",
                                                               pdppPermission: pdppPermission ?? "")
        } else {
            requestModel = QuickRegisterInitializeRequestModel(name: name,
                                                               surname: surname,
                                                               email: email?.lowercased(),
                                                               phoneNumber: phoneNumber,
                                                               registerChannel: registerChannel,
                                                               outlineAgreementStatus: outlineAgreementStatus ?? "",
                                                               pdppPermission: pdppPermission ?? "",
                                                               communicationsPermission: communicationsPermission ?? "")
        }
       
        
        Networking.request(router: RegisterRouter.quickRegister(requestModel: requestModel),
                           shouldShowLoading: shouldShowLoading)
        { [weak self] (response: BaseResponse<QuickRegisterInitializeResponseModel>?) in
            self?.registerInitializeResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    func getCashoutInitialize(email: String?,
                              amount: String?,
                              currencyType: String?,
                              onSuccess: @escaping (InitResponseModel?) -> Void,
                              onFailure: @escaping (String?) -> Void) {
        let requestModel = CashoutInitRequestModel(email: email?.lowercased(),
                                                   amount: amount,
                                                   currencyType: currencyType)
        Networking.request(router: CashoutRouter.initializeCashoutToBalance(requestModel: requestModel))
        { [weak self] (response: BaseResponse<InitResponseModel>?) in
            self?.initializeResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    func getTopUpInitialize(email: String?,
                            transactionType: TransactionType?,
                            onSuccess: @escaping (InitResponseModel?) -> Void,
                            onFailure: @escaping (String?) -> Void) {
        let requestModel = InitTransactionRequestModel(email: email?.lowercased(),
                                                       transactionType: transactionType)
        Networking.request(router: TransactionRouter.initTransaction(requestModel: requestModel))
        { [weak self] (response: BaseResponse<InitResponseModel>?) in
            self?.initializeResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    func getPWIInitialize(request: PWIinitRequestModel,
                            onSuccess: @escaping (InitResponseModel?) -> Void,
                            onFailure: @escaping (String?) -> Void) {
        let requestModel = request
        Networking.request(router: PWIRouter.initPWI(requestModel: requestModel))
        { [weak self] (response: BaseResponse<InitResponseModel>?) in
            self?.initializeResponse = response?.data
            SDKManager.checkoutToken = self?.initializeResponse?.checkoutToken
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
}
