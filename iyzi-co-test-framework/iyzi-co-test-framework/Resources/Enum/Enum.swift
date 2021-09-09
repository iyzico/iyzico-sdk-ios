//
//  Enum.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 18.12.2020.
//

import Foundation
import UIKit

//MARK: - OTPVC
enum OTPVCChangeButtonTypes {
    case change
    case support
}

// MARK: - PhoneVC
enum PhoneVCEnum: CaseIterable {
    case phone
    case addPhone
    case changePhone
    
    
    case email
    case addEmail
    case changeEmail
    
    var image: UIImage {
        
        switch self {
            case .phone:
                return UIImage(named: Asset.yourNumber.name)!
            case .addPhone:
                return UIImage(named: Asset.addNumber.name)!
            case .changePhone:
                return UIImage(named: Asset.changeNumber.name)!
                
            case .email:
                return UIImage(named: Asset.yourEmail.name)!
            case .addEmail:
                return UIImage(named: Asset.addEmail.name)!
            case .changeEmail:
                return UIImage(named: Asset.changeEmail.name)!
        }
    }
    
    var type: PhoneVCEnum {
        switch self {
            case .phone, .addPhone, .changePhone:
                return .phone
            case .email, .addEmail, .changeEmail:
                return .email
        }
    }
    
    var buttonTitle: String {
        switch self {
            case .phone:
                return StringConstant.shared.phoneButtonTitle
            case .addPhone:
                return StringConstant.shared.continueButtonTitle
            case .changePhone:
                return StringConstant.shared.continueButtonTitle
                
                
            case .email:
                return StringConstant.shared.continueButtonTitle
            case .addEmail:
                return StringConstant.shared.continueButtonTitle
            case .changeEmail:
                return StringConstant.shared.continueButtonTitle
        }
    }
    var textFieldTitle: String {
        switch self {
            case .phone, .addPhone, .changePhone:
                return StringConstant.shared.buttonTextFieldTitle
                
            case .email, .addEmail, .changeEmail:
                return StringConstant.shared.emailTextFieldTitle
        }
    }
}

// MARK: - IyzicoInfoVC
enum IyzicoInfoVCEnum {
    case transferring
    case transferred
    case received
    case allOk
}

//MARK: - IyzicoTransferVC
enum IyzicoTransferVCTypes {
    case cashout
    case topUp
}

// MARK: - IyzicoEFTDetailVC
enum IyzicoEFTDetailVCEnum: Int, CaseIterable {
    case iban = 0
    case accountOwner
    case amount
    case desc
    case info
    
    public var textFieldTitle: String {
        switch self {
            case .iban:
                return StringConstant.shared.iban
            case .accountOwner:
                return StringConstant.shared.accountOwner
            case .amount:
                return StringConstant.shared.amount
            case .desc:
                return StringConstant.shared.desc
            case .info:
                return ""
        }
    }
}
// MARK: - IyzicoMenuSectionType
enum IyzicoMenuSectionType: Int {
    case protectedPaymentMethod = 0
    case account
    case creditCardList
    case addNewCreditCard
    case installment
    case eft
    case none
}

enum HomeVCTypeEnum: Int {
    case payWithIyzico = 0
    case topUp
}

// MARK: - EftEnum
enum EftEnum: Int {
    case info = 0
    case bank
}

//MARK: - NewMemberVCEnum
enum NewMemberVCEnum {
    case initial
    case refund
    case cashout
}

//MARK: - ResultVCTypes
enum ResultVCTypes: Int, CaseIterable {
    case cashoutSuccess
    case refundSuccess
    case topUpSuccess
    case settlementSuccess
    case transferDetailSuccess
    case successWithProducts
    case threeDSecure
    case success
    case error
    case topUpWaiting
    case cashoutWaiting
}

//MARK: - Iyzico Flow Type
enum IyzicoFlowType {
    case topUp
    case settlement
    case refund
    case cashout
    case payWithIyzico
}

//MARK: - EftDetailEnum
enum EftDetailVCTypeEnum: Int {
    case info = 0
    case bank
    case transfer
}
//MARK: - INTERNAL MESSAGE
public enum InternalMessageState: Int, CaseIterable {
    case success = 1
    case error = 2
    case timeOut = 3
    case phoneError = 4
    case emailError = 5
    case brandError = 6
    case priceError = 7
    case productIDError = 8
    case walletPriceError = 9
    case clientIpError = 10
    case clientIdError = 11
    case clientSecretKeyError = 12
    case baseUrlError = 13
    case merchantApiKeyError = 14
    case merchantSecretKeyError = 15
    case paidPriceError = 16
    case urlCallbackError = 17
    case enabledinstallmentError = 18
    case basketIDError = 19
    case buyerIDError = 20
    case buyerNameError = 21
    case buyerSurnameError = 22
    case buyerIdentityNumberError = 23
    case buyerCityError = 24
    case buyerCountryError = 25
    case buyerEmailError = 26
    case buyerPhoneError = 27
    case buyerIPError = 28
    case buyerRegistrationAddressError = 29
    case buyerZipCodeError = 30
    case buyerRegistrationDateError = 31
    case buyerLastLoginDateError = 32
    case billingContactNameError = 33
    case billingCityError = 34
    case shippingCountryError = 35
    case shippingAddressError = 36
    case emptyBasketError = 37
    case fullBasketError = 38
    case basketProductIdError = 39
    case basketProductNameError = 40
    case basketProductCategoryError = 41
    case billingAdressError = 42
    case shippingContactNameError = 43
    case shippingCityError = 44
    case billingCountryError = 45
    case languageError = 46
    case closedTransactionError = 47
    case basketProductPriceError = 48
    case basketProductItemTypeError = 49
    
    
    
    var message: String {
        switch self {
            case .success:
                return StringConstant.shared.successText
            case .error:
                return StringConstant.shared.errorText
            case .timeOut:
                return StringConstant.shared.timeOutText
            case .phoneError:
                return StringConstant.shared.phoneErrorText
            case .emailError:
                return StringConstant.shared.emailErrorText
            case .brandError:
                return StringConstant.shared.brandErrorText
            case .priceError:
                return StringConstant.shared.priceErrorText
            case .productIDError:
                return StringConstant.shared.idErrorText
            case .walletPriceError:
                return StringConstant.shared.walletPriceErrorText
            case .clientIpError:
                return StringConstant.shared.apikeyErrorText
            case .clientIdError:
                return StringConstant.shared.clientIdErrorText
            case .clientSecretKeyError:
                return StringConstant.shared.clientSecretKeyErrorText
            case .baseUrlError:
                return StringConstant.shared.baseUrlError
            case .merchantApiKeyError:
                return StringConstant.shared.merchantApiKeyErrorText
            case .merchantSecretKeyError:
                return StringConstant.shared.merchantSecretKeyErrorText
            case .paidPriceError:
                return StringConstant.shared.paidPriceErrorText
            case .urlCallbackError:
                return StringConstant.shared.callbackErrorText
            case .enabledinstallmentError:
                return StringConstant.shared.enabledInstallementErrorText
            case .basketIDError:
                return StringConstant.shared.basketIdErrorText
            case .buyerIDError:
                return StringConstant.shared.buyerIDError
            case .buyerNameError:
                return StringConstant.shared.buyerNameError
            case .buyerSurnameError:
                return StringConstant.shared.buyerSurnameError
            case .buyerIdentityNumberError:
                return StringConstant.shared.buyerIdentityNumberError
            case .buyerCityError:
                return StringConstant.shared.buyerCityError
            case .buyerCountryError:
                return StringConstant.shared.buyerCountryError
            case .buyerEmailError:
                return StringConstant.shared.buyerEmailError
            case .buyerPhoneError:
                return StringConstant.shared.buyerPhoneError
            case .buyerIPError:
                return StringConstant.shared.buyerIPError
            case .buyerRegistrationAddressError:
                return StringConstant.shared.buyerRegistrationAddressError
            case .buyerZipCodeError:
                return StringConstant.shared.buyerZipCodeError
            case .buyerRegistrationDateError:
                return StringConstant.shared.buyerRegistrationDateError
            case .buyerLastLoginDateError:
                return StringConstant.shared.buyerLastLoginDateError
            case .billingContactNameError:
                return StringConstant.shared.billingContactNameError
            case .billingCityError:
                return StringConstant.shared.billingCityError
            case .shippingCountryError:
                return StringConstant.shared.shippingCountryError
            case .shippingAddressError:
                return StringConstant.shared.shippingAddressError
            case .emptyBasketError:
                return StringConstant.shared.emptyBasketError
            case .fullBasketError:
                return StringConstant.shared.fullBasketError
            case .basketProductIdError:
                return StringConstant.shared.basketProductIdError
            case .basketProductNameError:
                return StringConstant.shared.basketProductNameError
            case .basketProductCategoryError:
                return StringConstant.shared.basketProductCategoryError
            case .billingAdressError:
                return StringConstant.shared.billingAdressError
            case .shippingContactNameError:
                return StringConstant.shared.shippingContactNameError
            case .shippingCityError:
                return StringConstant.shared.shippingCityError
            case .billingCountryError:
                return StringConstant.shared.billingCountryError
            case .languageError:
                return StringConstant.shared.languageError
            case .closedTransactionError:
                return StringConstant.shared.closedTransactionError
            case .basketProductPriceError:
                return StringConstant.shared.basketProductPriceError
            case .basketProductItemTypeError:
                return StringConstant.shared.basketProductItemTypeError
        }
    }
}

//MARK: - Regex Enum
enum RegexTypes: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "^\\+905\\d{9}$"
    case iban = "^TR\\d{14}$"
    case cardOwnerName = ".*[^A-Za-zçğıöşüZÇĞIÖŞÜ ].*"
}

//MARK: - NavBar
enum NavBarDismissTypes {
    case cancel
    case close
}

//MARK: - Lottie
enum LottieFiles {
    case fail
    case info
    case loading
    case success
    
    func getFileName() -> String {
        switch self {
            case .fail: return "failLottie"
            case .info: return "infoLottie"
            case .loading: return "loadingLottie"
            case .success: return "successLottie"
        }
    }
}

//MARK: - MemberVCSectionTypes
enum MemberVCSectionTypes: Int, CaseIterable {
    case header
    case member
    case changeAccount
}

//MARK: - WebVCTypes
enum WebVCTypes {
    case boundsAgreement
    case kvkkAgreement
    case html
    case contact
    case kvkk
    case agreement
    
    func getUrl() -> String {
        switch self {
            case .boundsAgreement: return "https://www.iyzico.com/kendim-icin/kullanici-sozlesmesi#ereve-e-para-hracat-ve-deme-hizmeti-szlemesi"
            case .kvkkAgreement: return "https://www.iyzico.com/gizlilik-politikasi/kisisel-verilerin-islenmesine-iliskin-aydinlatma-metni"
            case .html:
                return ""
            case .contact:
                return "https://www.iyzico.com/gizlilik-politikasi/ticari-iletisim-riza-metni"
            case .kvkk:
                return "https://www.iyzico.com/gizlilik-politikasi/kisisel-verilerin-islenmesine-iliskin-riza-metni"
            case .agreement:
                return "https://www.iyzico.com/kendim-icin/kullanici-sozlesmesi/iyzico-mobil-kullanici-sozlesmesi"
        }
    }
}

//MARK: - IyzicoTermAndCondTypes
enum IyzicoTermAndCondTypes {
    case single
    case multiple
}

//MARK: - IyzicoTextInputType
enum IyzicoTextInputType: Int {
    case text = 0
    case phone
    case date
    case number
    case amount
    case iban
    case cardNumber
    case securityCode
    case shortDate
    case amountPrice
    case cardOwnerName
}

//MARK: - Network Connection Types
enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    //... case ipv4 = "ipv4"
    //... case ipv6 = "ipv6"
}
enum CursorPositionTypes {
    case begin
    case end
}

//MARK: - IyzicoPopUpView
enum IyzicoPopUpViewTypes {
    case error
    case none
}

enum BottomAlertAnimationType {
    case open
    case close
}

//MARK: - CreditCardCell (IyzicoHomeVC)
enum CardNameTypes: String, CaseIterable, Codable {
    case CREDIT_CARD
    case DEBIT_CARD
    
    var value: String {
        switch self {
            case .CREDIT_CARD:
                return "Kredi Kartı"
            case .DEBIT_CARD:
                return "Banka Kartı"
        }
    }
}

public enum Language: String, CaseIterable {
    case tr = "tr"
    case en = "en"
}

public enum Currency: String, CaseIterable {
    case TRY = "TRY"
    case USD = "USD"
    case EURO = "EURO"
    case GBP = "GBP"
    case IRR = "IRR"
}

public enum PaymentGroup: String, CaseIterable {
    case PRODUCT = "PRODUCT"
    case LISTING = "LISTING"
    case SUBSCRIPTION = "SUBSCRIPTION"
    case none = ""
}

public enum BasketItemType: String, CaseIterable {
    case PHYSICAL
    case VIRTUAL
}

enum DepositStatus: String, CaseIterable, Decodable {
    case APPROVED
    case WAITING_FOR_PROVISION
}

enum CardBrandsName: Int, CaseIterable {
    case VISA
    case MASTER
    case AMEX
    case MASTER2
    case MASTER3
    case MASTER4
    case TROY
    
    var regex: String {
        switch self {
            case .VISA:
                return "^4\\d{0,16}$"
            case .MASTER:
                return "^5[1-5]\\d{0,14}$"
            case .AMEX:
                return "((^3[47])((\\d{0,11}$)|(\\d{0,13}$))|^311111111111117$)"
            case .MASTER2:
                return "^6[7]\\d{0,14}$"
            case .MASTER3:
                return "^5[8]\\d{0,14}$"
            case .MASTER4:
                return "^222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720\\d{0,12}$"
            case .TROY:
                return "(^9\\d{0,15}$)|(^65\\d{0,14}$)"
        }
    }
    
    var start: String {
        switch self {
            case .VISA:
                return "^4"
            case .MASTER:
                return "^5"
            case .AMEX:
                return "((^3[47]))"
            case .MASTER2:
                return "^6[7]"
            case .MASTER3:
                return "^5[8]"
            case .MASTER4:
                return "^222"
            case .TROY:
                return "(^9)|(^65)"
        }
    }
}
