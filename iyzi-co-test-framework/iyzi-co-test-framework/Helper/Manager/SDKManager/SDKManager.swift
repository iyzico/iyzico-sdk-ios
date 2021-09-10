//
//  DataManager.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 28.01.2021.
//

import UIKit

fileprivate struct SDKConfigurationModel {
    let configValue: String?
    let errorValue: InternalMessageState
    
    init(configValue: String?,
         errorValue: InternalMessageState) {
        self.configValue = configValue
        self.errorValue = errorValue
    }
}

class SDKManager: Iyzico {
    static var flow: IyzicoFlowType = .payWithIyzico //App all screens ui can be changed based on flow type.
    
    //MARK: - Flow Neccesities
    static var brand: String?
    static var price: Double?
    static var email: String?
    static var productId: String?
    static var walletPrice: Double?
    static var phone: String?
    static var addressType: String?
    static var addressDescription: String?
    static var productImage: UIImage?
    static var name: String?
    static var surname: String?
    static var PWIrequest = PWIinitRequestModel()
    
    //MARK: - SDK Configuration
    static var clientIp: String?
    static var clientId: String?
    static var clientSecretKey: String?
    static var baseUrl: String?
    static var merchantApiKey: String?
    static var merchantSecretKey: String?
    static var checkoutToken: String?
    static var isSdkConfigCompleted = false
    static var language: String?
    
    //MARK: - Helper Methods
    static func getBundle(vc: UIViewController) -> Bundle {
        return  Bundle(for: type(of: vc))
    }
    
    static func getBundle() -> Bundle {
        return Bundle(for: self)
    }
    
    static func checkSDKConfigurations(success: () -> Void,
                                       failure: (_ state: InternalMessageState) -> Void) {
        var configModelArray = [SDKConfigurationModel(configValue: clientIp, errorValue: .clientIpError),
                                SDKConfigurationModel(configValue: clientId, errorValue: .clientIdError),
                                SDKConfigurationModel(configValue: clientSecretKey, errorValue: .clientSecretKeyError),
                                SDKConfigurationModel(configValue: baseUrl, errorValue: .baseUrlError),
                                SDKConfigurationModel(configValue: language, errorValue: .languageError)]
        
        if SDKManager.flow == .payWithIyzico {
            configModelArray.append(SDKConfigurationModel(configValue: merchantApiKey, errorValue: .merchantApiKeyError))
            configModelArray.append(SDKConfigurationModel(configValue: merchantSecretKey, errorValue: .merchantSecretKeyError))
        }
        
        for i in configModelArray {
            if let validatedConfigValue = i.configValue,
               !validatedConfigValue.isEmpty && !validatedConfigValue.containsWhiteSpaces {
                
            }
            else {
                Iyzico.delegate?.didOperationFailed(state: i.errorValue,
                                                    message: i.errorValue.message)
                failure(i.errorValue)
                return
            }
        }
        
        checkFlowValues {}
        failure: { (state) in
            failure(state)
        }
        success()
    }
    
    private static func checkFlowValues(success: () -> Void,
                                        failure: (_ state: InternalMessageState) -> Void) {
        let configModelArray = [SDKConfigurationModel(configValue: brand, errorValue: .brandError),
                                SDKConfigurationModel(configValue: price?.description, errorValue: .priceError),
                                SDKConfigurationModel(configValue: email, errorValue: .emailError),
                                SDKConfigurationModel(configValue: productId, errorValue: .productIDError),
                                SDKConfigurationModel(configValue: walletPrice?.description, errorValue: .walletPriceError),
                                SDKConfigurationModel(configValue: phone, errorValue: .phoneError),
                                SDKConfigurationModel(configValue: name, errorValue: .buyerNameError),
                                SDKConfigurationModel(configValue: surname, errorValue: .buyerSurnameError),
                                SDKConfigurationModel(configValue: PWIrequest.paidPrice?.description, errorValue: .paidPriceError),
                                SDKConfigurationModel(configValue: PWIrequest.basketID, errorValue: .basketIDError),
                                SDKConfigurationModel(configValue: PWIrequest.callbackURL, errorValue: .urlCallbackError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.id, errorValue: .buyerIDError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.name, errorValue: .buyerNameError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.surname, errorValue: .buyerSurnameError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.identityNumber, errorValue: .buyerIdentityNumberError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.email, errorValue: .buyerEmailError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.gsmNumber, errorValue: .buyerPhoneError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.registrationAddress, errorValue: .buyerRegistrationAddressError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.city, errorValue: .buyerCityError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.country, errorValue: .buyerCountryError),
                                SDKConfigurationModel(configValue: PWIrequest.buyer?.ip, errorValue: .buyerIPError),
                                SDKConfigurationModel(configValue: PWIrequest.billingAddress?.address, errorValue: .billingAdressError),
                                SDKConfigurationModel(configValue: PWIrequest.billingAddress?.contactName, errorValue: .billingContactNameError),
                                SDKConfigurationModel(configValue: PWIrequest.billingAddress?.city, errorValue: .billingCityError),
                                SDKConfigurationModel(configValue: PWIrequest.billingAddress?.country, errorValue: .billingCountryError),
                                SDKConfigurationModel(configValue: PWIrequest.shippingAddress?.address, errorValue: .shippingAddressError),
                                SDKConfigurationModel(configValue: PWIrequest.shippingAddress?.contactName, errorValue: .shippingContactNameError),
                                SDKConfigurationModel(configValue: PWIrequest.shippingAddress?.city, errorValue: .shippingCityError),
                                SDKConfigurationModel(configValue: PWIrequest.shippingAddress?.country, errorValue: .shippingCountryError)]
        var configModelArrayByFlow: [SDKConfigurationModel] = []
        switch flow {
        case .topUp:
            configModelArrayByFlow = [configModelArray[2],
                                      configModelArray[5],
                                      configModelArray[0],
                                      configModelArray[6],
                                      configModelArray[7]]
        case .settlement:
            configModelArrayByFlow = [configModelArray[2],
                                      configModelArray[5],
                                      configModelArray[4],
                                      configModelArray[6],
                                      configModelArray[7]]
        case .refund:
            configModelArrayByFlow = [configModelArray[2],
                                      configModelArray[5],
                                      configModelArray[3],
                                      configModelArray[6],
                                      configModelArray[7]]
        case .cashout:
            configModelArrayByFlow = [configModelArray[2],
                                      configModelArray[5],
                                      configModelArray[4],
                                      configModelArray[6],
                                      configModelArray[7]]
        case .payWithIyzico:
            configModelArrayByFlow = [configModelArray[0],
                                      configModelArray[1],
                                      configModelArray[2],
                                      configModelArray[3],
                                      configModelArray[5],
                                      configModelArray[6],
                                      configModelArray[7],
                                      configModelArray[8],
                                      configModelArray[9],
                                      configModelArray[10],
                                      configModelArray[11],
                                      configModelArray[12],
                                      configModelArray[13],
                                      configModelArray[14],
                                      configModelArray[15],
                                      configModelArray[16],
                                      configModelArray[17],
                                      configModelArray[18],
                                      configModelArray[19],
                                      configModelArray[20],
                                      configModelArray[21],
                                      configModelArray[22],
                                      configModelArray[23],
                                      configModelArray[24],
                                      configModelArray[25],
                                      configModelArray[26],
                                      configModelArray[27],
                                      configModelArray[28]]
        }
        
        handleFlowValues(success: {
            success()
        },
        failure: { (state) in
            failure(state)
        },
        configModels: configModelArrayByFlow)
    }
    
    private static func handleFlowValues(success: () -> Void,
                                         failure: (_ state: InternalMessageState) -> Void,
                                         configModels: [SDKConfigurationModel]) {
        
        for i in configModels {
            if let validatedConfigValue = i.configValue,
               !validatedConfigValue.isEmpty && !validatedConfigValue.containsWhiteSpaces {
                
            }
            else {
                Iyzico.delegate?.didOperationFailed(state: i.errorValue,
                                                    message: i.errorValue.message)
                failure(i.errorValue)
                return
            }
        }
//        configModels.forEach { configModel in
//            ///TODO - Make rules for every property
////            if let validatedConfigValue = configModel.configValue,
////               !validatedConfigValue.isEmpty && !validatedConfigValue.containsWhiteSpaces {
////
////            }
////            else {
////                Iyzico.delegate?.didOperationFailed(state: configModel.errorValue,
////                                                    message: configModel.errorValue.message)
////                failure(configModel.errorValue)
////                return
////            }
//        }
        
        success()
    }
    
    static func closeSDK() {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
            IyzicoNavBar.timer?.invalidate()
            NotificationCenter.default.post(name: .removePwiTimerObservers, object: nil)
        })
    }
}
