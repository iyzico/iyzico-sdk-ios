//
//  OTPVM.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 18.02.2021.
//

import Foundation

class OTPVM: BaseVM {
    //MARK: - Properties
    var loginCompleteResponse: LoginCompleteResponseModel?
    var smsResendResponse: QuickLoginInitializeResponseModel?
    var isPasted = false
    var isMemberExist = false
    var changeButtonType: OTPVCChangeButtonTypes = .change
    
    //MARK: - Navigated Properties
    var navigatedLoginInitializeResponse: QuickLoginInitializeResponseModel?
    var navigatedRegisterInitializeResponse: QuickRegisterInitializeResponseModel?
    var navigatedInitializeResponse: InitResponseModel? {
        didSet {
            setIsMemberExist()
        }
    }
    var navigatedGsmUpdateResponse: GsmUpdateResponseModel?
    var navigatedPhoneNumber: String?
    var isGsmVerified: Bool? {
        didSet {
            changeButtonType = (isGsmVerified ?? false) ? .support : .change
        }
    }
    
    //MARK: - Requests
    func getLoginComplete(verificationCode: String?,
                          clientIp: String?,
                          loginChannel: String?,
                          onSuccess: @escaping (LoginCompleteResponseModel?) -> Void,
                          onFailure: @escaping (String?) -> Void) {
        let requestModel = LoginCompleteRequestModel(loginSmsVerification: getSMSModel(verificationCode: verificationCode),
                                                     clientIp: clientIp,
                                                     loginChannel: loginChannel)
        Networking.request(router: LoginRouter.loginComplete(requestModel: requestModel))
        { [weak self] (response: BaseResponse<LoginCompleteResponseModel>?) in
            self?.loginCompleteResponse = response?.data
            DefaultsManager.set(value: response?.data?.accessToken, forKey: .accessToken)
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    func getResendSms(onSuccess: @escaping (QuickLoginInitializeResponseModel?) -> Void,
                      onFailure: @escaping (String?) -> Void) {
        let loginInitModel = navigatedLoginInitializeResponse
        let requestModel = SmsResendRequestModel(userUuid: loginInitModel?.userUuid,
                                                 referenceCode: loginInitModel?.referenceCode,
                                                 channelType: "THIRD_PARTY_APP")
        Networking.request(router: LoginRouter.smsResend(requestModel: requestModel))
        { [weak self] (response: BaseResponse<QuickLoginInitializeResponseModel>?) in
            self?.smsResendResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _) in
            onFailure(error)
        }
    }
    
    //MARK: - Helper Methods
    private func setIsMemberExist() {
        if navigatedRegisterInitializeResponse == nil {
            let responseArray = [navigatedInitializeResponse]
            responseArray.forEach { model in
                if let isMemberExist = model?.memberExist {
                    self.isMemberExist = isMemberExist
                }
            }
        }
        else {
            isMemberExist = false
        }
    }
    
    private func getSMSModel(verificationCode: String?) -> SMSModel? {
        #warning("change in prod")
        if isMemberExist {
            return SMSModel(userUuid: navigatedLoginInitializeResponse?.userUuid,
                            referenceCode: navigatedLoginInitializeResponse?.referenceCode,
                            verificationCode: verificationCode)
        }
        else {
            return SMSModel(userUuid: navigatedRegisterInitializeResponse?.userUuid,
                            referenceCode: navigatedRegisterInitializeResponse?.referenceCode,
                            verificationCode: verificationCode)
        }
    }
    
    func getMaskedPhoneText() -> String? {
        if navigatedGsmUpdateResponse?.maskedGsmNumber != nil {
            return navigatedGsmUpdateResponse?.maskedGsmNumber?.convertServiceMaskedPhoneNumber
        }
        if navigatedLoginInitializeResponse != nil {
            return navigatedLoginInitializeResponse?.maskedGsmNumber?.convertServiceMaskedPhoneNumber
        }
        else {
            return navigatedRegisterInitializeResponse?.maskedGsmNumber?.convertServiceMaskedPhoneNumber
        }
    }
}
