//
//  Iyzico.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 28.01.2021.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

public class Iyzico {
    
    public static let shared = Iyzico()
    public static weak var delegate: IyzicoDelegate?
    private var newMemberVM = NewMemberVM()
    lazy var presentedVC: UIViewController? = {
        return UIApplication.shared.keyWindow?.rootViewController
    }()
    
    init() {
        //MARK: SDK Configuration Check
        
        //MARK: Logs
        LogManager.printLogWithTemplate(log: StringConstant.IyzicoLog.iyzicoStarted)
        
        //MARK: Setup
        enableIQKeyboardManager()
        registerFont()
        
        //MARK: - Server Direction
        ServerConfiguration.serverDirection = .sandbox
        
        //MARK: - Disable constraint error messages from console
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}

//MARK: - Flows
extension Iyzico {
    
    public func startPayWithIyziCo(
        brand: String,
        price: Double,
        paidPrice: Double,
        currency: Currency,
        enabledInstallments: [Int]? = nil,
        basketId: String,
        paymentGroup: PaymentGroup? = .PRODUCT,
        paymentSource: String,
        urlCallback: String,
        buyerId: String,
        buyerName: String,
        buyerSurname: String,
        buyerIdentityNumber: String,
        buyerCity: String,
        buyerCountry: String,
        buyerEmail: String,
        buyerPhone: String,
        buyerIp: String,
        buyerRegistrationAddress: String,
        buyerZipCode: String,
        buyerRegistrationDate: String,
        buyerLastLoginDate: String,
        billingContactName: String,
        billingCity: String,
        billingCountry: String,
        billingAddress: String,
        shippingContactName: String,
        shippingCity: String,
        shippingCountry: String,
        shippingAddress: String,
        itemType: String,
        itemName: String,
        itemCategory: String,
        productId: String?,
        addressDescription: String?,
        basketItemList: [IyzicoBasketItem]
    ) {

        SDKManager.flow = .payWithIyzico
        SDKManager.brand = brand
        SDKManager.price = paidPrice//price
        SDKManager.email = buyerEmail.lowercased()
        SDKManager.phone = buyerPhone.addWhitespacesToPhone
        SDKManager.addressDescription = addressDescription
        SDKManager.name = buyerName
        SDKManager.surname = buyerSurname
        
        SDKManager.PWIrequest.paidPrice = paidPrice.description
        SDKManager.PWIrequest.enabledInstallments = enabledInstallments
        SDKManager.PWIrequest.price = price.description
        SDKManager.PWIrequest.paymentGroup = paymentGroup?.rawValue
        SDKManager.PWIrequest.callbackURL = urlCallback
        SDKManager.PWIrequest.paymentSource = paymentSource
        SDKManager.PWIrequest.currency = currency.rawValue
        SDKManager.PWIrequest.basketID = basketId
        
        var buyerInfo = BuyerRequest()
        buyerInfo.id = buyerId
        buyerInfo.name = buyerName
        buyerInfo.surname = buyerSurname
        buyerInfo.identityNumber = buyerIdentityNumber
        buyerInfo.email = buyerEmail.lowercased()
        buyerInfo.gsmNumber = buyerPhone
        buyerInfo.registrationAddress = buyerRegistrationAddress
        buyerInfo.city = buyerCity
        buyerInfo.country = buyerCountry
        buyerInfo.ip = buyerIp
        
        SDKManager.PWIrequest.buyer = buyerInfo
        
        var shippingInfo = PWIAddressRequest()
        shippingInfo.address = shippingAddress
        shippingInfo.city = shippingCity
        shippingInfo.contactName = shippingContactName
        shippingInfo.country = shippingCountry
        
        SDKManager.PWIrequest.shippingAddress = shippingInfo
        
        var billingInfo = PWIAddressRequest()
        billingInfo.address = billingAddress
        billingInfo.city = billingCity
        billingInfo.contactName = billingContactName
        billingInfo.country = billingCountry
        
        SDKManager.PWIrequest.billingAddress = billingInfo
        
        var basketItemsArray: [BasketItemRequest] = []
        basketItemList.forEach { (item) in
            let basketItem = BasketItemRequest(id: item.id,
                                               price: item.price,
                                               name: item.name,
                                               category1: item.category1,
                                               itemType: item.itemType)
            basketItemsArray.append(basketItem)
        }
        
        SDKManager.PWIrequest.basketItems = basketItemsArray
        
        var mobileDeviceInfo = MobileDeviceInfoDto()
        mobileDeviceInfo.sdkVersion = GlobalMethodsManager.getSdkVersion()
        mobileDeviceInfo.operatingSystemVersion = GlobalMethodsManager.getOsVersion()
        mobileDeviceInfo.model = "\(UIDevice().type)"
        mobileDeviceInfo.brand = "Apple"
        
        SDKManager.PWIrequest.mobileDeviceInfoDto = mobileDeviceInfo
        
        checkSDKConfigurations()
    }
    
    public func startTopUp(buyerEmail: String,
                           buyerPhone: String,
                           buyerName: String? = nil,
                           buyerSurname: String? = nil) {
        SDKManager.flow = .topUp
        SDKManager.email = buyerEmail.lowercased()
        SDKManager.phone = buyerPhone.addWhitespacesToPhone
        SDKManager.name = buyerName
        SDKManager.surname = buyerSurname
        checkSDKConfigurations()
    }
    
    public func startSettlement(buyerEmail: String,
                                buyerPhone: String,
                                walletPrice: Double,
                                buyerName: String? = nil,
                                buyerSurname: String? = nil) {
        SDKManager.flow = .settlement
        SDKManager.email = buyerEmail.lowercased()
        SDKManager.phone = buyerPhone.addWhitespacesToPhone
        SDKManager.walletPrice = walletPrice
        SDKManager.name = buyerName
        SDKManager.surname = buyerSurname
        checkSDKConfigurations()
    }
    
    public func startRefund(buyerEmail: String,
                            buyerPhone: String,
                            productId: String,
                            buyerName: String? = nil,
                            buyerSurname: String? = nil) {
        SDKManager.flow = .refund
        SDKManager.email = buyerEmail.lowercased()
        SDKManager.phone = buyerPhone.addWhitespacesToPhone
        SDKManager.productId = productId
        SDKManager.name = buyerName
        SDKManager.surname = buyerSurname
        checkSDKConfigurations()
    }
    
    public func startCashOut(buyerEmail: String,
                             buyerPhone: String,
                             walletPrice: Double,
                             buyerName: String? = nil,
                             buyerSurname: String? = nil) {
        SDKManager.flow = .cashout
        SDKManager.email = buyerEmail.lowercased()
        SDKManager.phone = buyerPhone.addWhitespacesToPhone
        SDKManager.walletPrice = walletPrice
        SDKManager.name = buyerName
        SDKManager.surname = buyerSurname
        checkSDKConfigurations()
    }
}

//MARK: - Helper Methods
extension Iyzico {
    open func initialize(clientIp: String,
                         clientId: String,
                         clientSecret: String,
                         baseUrl: String,
                         merchantApiKey: String? = nil,
                         merchantSecretKey: String? = nil,
                         language: Language) {
        SDKManager.clientIp = clientIp
        SDKManager.clientId = clientId
        SDKManager.clientSecretKey = clientSecret
        SDKManager.baseUrl = baseUrl
        SDKManager.language = language.rawValue
        if ValidationManager.nilValidation(text: merchantApiKey) && ValidationManager.nilValidation(text: merchantSecretKey) {
            SDKManager.merchantApiKey = merchantApiKey
            SDKManager.merchantSecretKey = merchantSecretKey
        }
    }
    
    private func checkSDKConfigurations() {
        SDKManager.checkSDKConfigurations { [weak self] in
            self?.chooseInitializeService()
        } failure: { (state: ResultCode) in
            SDKManager.closeSDK()
            LogManager.printLogForIyzicoInternalMessage(state: state)
        }
    }
    
    fileprivate func enableIQKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.enable = true
        keyboardManager.toolbarDoneBarButtonItemText = StringConstant.shared.keyboardDoneTitleV2
        keyboardManager.enableAutoToolbar = false
        keyboardManager.enabledToolbarClasses = [IyzicoHomeVC.self]
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.keyboardDistanceFromTextField = 75
    }
    
    fileprivate func registerFont() {
        let constant = StringConstant.shared
        let fontArray = [constant.markPro,
                         constant.markProBold,
                         constant.markProMedium,
                         constant.markProLight,
                         constant.markProLightItalic,
                         constant.markProItalic,
                         constant.markProBook]
        fontArray.forEach{ UIFont.registerFont(withFilenameString: $0) }
    }
    
    func showError(errorDescription: String?) {
        let vc = IyzicoPopUpView(iyzicoButton: .primaryLvl1(state: .normal),
                                 iyzicoButtonTitle: StringConstant.shared.iyzicoButtonError,
                                 popUpImage: Asset.nonLottieFail.name,
                                 descText: errorDescription ?? "")
        vc.loadViewIfNeeded()
        vc.closeLabel.text = StringConstant.shared.closeButtonTitle
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        presentedVC?.present(vc, animated: true, completion: nil)
    }
    
    private func chooseInitializeVC(initResponseModel: InitResponseModel?) {
        let vc = MainVC()
        guard let validatedIsMemberExist = initResponseModel?.memberExist else { return }
        if validatedIsMemberExist {
            let memberVC = MemberVC()
            memberVC.newMemberVM.initializeResponse = initResponseModel
            vc.rootVC = memberVC
        }
        else {
            let newMemberVC = NewMemberVC(vcType: SDKManager.flow)
            newMemberVC.viewModel.initializeResponse = initResponseModel
            vc.rootVC = newMemberVC
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    private func chooseInitializeService() {
        switch SDKManager.flow {
        case .topUp:
            getTopUpInitialize()
        case .payWithIyzico:
            getPWIInitialize()
        default:
            getCashoutInitialize()
        }
    }
}

//MARK: - Service Calls
extension Iyzico {
    private func getCashoutInitialize() {
        #warning("Change in prod")
        newMemberVM.getCashoutInitialize(email: SDKManager.email,
                                         amount: "₺50000,00".serviceAmountFormatAsString,
                                         currencyType: "TRY",
                                         onSuccess: { [weak self] (response: InitResponseModel?) in
                                            self?.chooseInitializeVC(initResponseModel: response)
                                         },
                                         onFailure: { [weak self] errorDescription in
                                            self?.showError(errorDescription: errorDescription)
                                         })
    }
    
    private func getTopUpInitialize() {
        newMemberVM.getTopUpInitialize(email: SDKManager.email,
                                       transactionType: .DEPOSIT,
                                       onSuccess: { [weak self] (response: InitResponseModel?) in
                                        self?.chooseInitializeVC(initResponseModel: response)
                                       },
                                       onFailure: { [weak self] errorDescription in
                                        self?.showError(errorDescription: errorDescription)
                                       })
    }
    
    private func getPWIInitialize() {
        //   guard let request =  SDKManager.PWIrequest else { return }
        newMemberVM.getPWIInitialize(request: SDKManager.PWIrequest,
                                     onSuccess: { [weak self] (response: InitResponseModel?) in
                                        self?.chooseInitializeVC(initResponseModel: response)
                                     },
                                     onFailure: { [weak self] errorDescription in
                                        self?.showError(errorDescription: errorDescription)
                                     })
    }
}
