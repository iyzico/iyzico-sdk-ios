//
//  StringConstants.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 21.12.2020.
//

import Foundation
import UIKit
//open class StringConstant {
//
//
//    public static let shared = StringConstant()
//
//    // MARK: - Bundle Identifier
//    public let frameworkBundle = "com.basefy.iyzi-co-test-framework"
//
//    // MARK: - FONT
//    let markPro = "MarkPro.otf"
//    let markProItalic = "MarkPro-Italic.otf"
//    let markProLightItalic = "MarkPro-Light-Italic.otf"
//    let markProMedium = "MarkPro-Medium.otf"
//    let markProLight = "MarkPro-Light.otf"
//    let markProBold = "MarkPro-Bold.otf"
//    let markProBook = "MarkPro-Book.otf"
//
//    // MARK: - General
//    let continueButtonTitle = "Devam Et"
//    let payWithIyzico = "iyzico ile Öde"
//    let keyboardDoneTitle = "Kapat"
//    let comma = ","
//    let dot = "."
//
//    // MARK: - IyzicoPopUpView Default Data
//    let iyzicoButtonError: String = "Tamam"
//    let iyzicoButtonTitle: String = "Ödemeye Devam Et"
//    let iyzicoPopUpViewTryAgainTitle: String = "Tekrar Dene"
//    let iyzicoButtonOptionalTitle: String = "Sayfayı Kapat"
//    let iyzicoPopUpViewDescText = "Sayfayı kapatırsanız satın alma işlemi iptal edilecektir."
//    let iyzicoPopUpViewTimeOutDesc = "Satın alma süreniz doldu, lütfen tekrar deneyin."
//
//
//    // MARK: - IyzicoTextArea Default Data
//    let textAreaPlaceholder = "Type Here"
//
//
//    // MARK: - IyzicoTextInput Default Data
//    let textInputDatePlaceholder = "Gün/Ay/Yıl"
//    public let externalBorderName = "externalBorder"
//    let textInputSeperator: String = "-"
//    let textInputDateSeperator: String = "/"
//
//    struct IyzicoAmountView {
//        static let fullTextFieldPlaceHolder = "₺0,00"
//        static let naturalNumberFieldPlaceHolder = "₺0"
//        static let decimalNumberTextFieldPlaceholder = ",00"
//    }
//
//    // MARK: - IyzicoNavBar Default Data
//    let titleLabelName: String = "Ödeme"
//    let amountLabelName: String = "Ödenecek Tutar: "
//    let timeLabelName: String = "Kalan Süre:"
//    let cancelButtonTitle = "Vazgeç"
//    let priceTitleLabelName = "Toplam Tutar"
//    let navBarBalanceTitle = "bakiyen"
//    let closeButtonTitle = "Kapat"
//
//
//    // MARK: - Intro
//    public let introTitle = "iyzico Korumalı Alışveriş ile"
//    public let introBody = "Güvenle Ödeme Yap"
//
//
//    // MARK: - PhoneVC Default Data
//    let buttonTextFieldTitle: String = "Telefon Numarası"
//    let phoneButtonTitle: String = "Kod Gönder"
//    let defaultPhoneCode: String = "+90"
//    let emailTextFieldTitle: String = "E-posta adresin"
//    let emailPlaceHolder: String = "E-posta adresini yaz"
//    let phonePlaceHolder: String = "Telefon numaranı yaz"
//    public let phoneVCTermString: String = "Devam ederek KVKK Aydınlatma Metni’ni okuduğunuzu kabul etmektesiniz."
//    public let phoneVCTermHighletedString: String = "KVKK Aydınlatma Metni"
//
//
//    // MARK: - OTPVC Default Data
//    let otpVCChangePhoneButtonTitle: String = "Değiştir"
//    let otpVCSupportButtonTitle: String = "Destek"
//    let otpVCSendAgainButtonTitle: String = "Tekrar Gönder"
//    let otpVCSendAgainTitleText: String = "Mesajlarını kontrol et! 💬"
//    let otpVCSendAgainCodeText: String = "Onay Kodunu Gir"
//    let otpVCSmsSendedText = "SMS Gönderildi"
//
//    // MARK: - IyzicoInfoVC Default Data
//    let iyzicoInfoVCRecievedIyzicoTitle = "iyzico güvencesiyle"
//    let iyzicoInfoVCRecievedIyzicoFulltitle = "iyzico güvencesiyle \n ödemeniz başarıyla alındı."
//    let iyzicoInfoVCTransferredIyzicoTitle =  "Hesabına Aktardık!"
//    let iyzicoInfoVCTransferringIyzicoTitle = "İadeni Hesabına Aktarıyoruz"
//    let iyzicoInfoVCAllOkIyzicoTitle = "Hepsi Tamam"
//
//    let iyzicoInfoVCRecievedDescText = "yönlendiriliyorsunuz."
//    let iyzicoInfoVCTransferredDescText = "adresine kayıtlı \n iyzico hesabına aktarma işlemini tamamladık."
//    let iyzicoInfoVCTransferringDescText = "Bu iadenin iyzico bakiyene aktarılmasını \n onaylıyor musun?"
//    let iyzicoInfoVCAllOkDescText = "başarıyla hesabınıza işlenmiştir."
//
//    let iyzicoInfoVCReturnApp = "Uygulamaya Dön"
//    let iyzicoInfoVCApprove = "Onayla"
//    let iyzicoInfoVCMainPage = "Ana Sayfa"
//
//    let iyzicoInfoVCTransferTitle = "Aktarılıcak iade Tutarı"
//    let iyzicoInfoVCBalanceTitle = "bakiyem"
//
//    // MARK: - IyzicoTransferVC Default Data
//   // let iyzicoTransferVCAmountTitle = "Tutar"
//    let iyzicoTransferVCAmountForLoadTitle = "Yüklenecek Tutar"
//    let iyzicoTransferVCAmountTitle = "Yüklenecek Tutar"
//    let iyzicoTransferVCCashoutTitle = "Tutar"
//    let iyzicoTransferVCDefaultAmount = "₺0,00"
//    let iyzicoTransferVCDefaultAmountWithNoSembol = "0,00"
//    let iyzicoTransferVCDefaultTL = "₺"
//    let iyzicoTransferVCTransferTitle = "Aktaralabilir Bakiyem"
//    let iyzicoTransferVCiyzicoTitle = "Her zaman iyzico'ya aktar\nBu ayarı daha sonra değiştirebilirsin"
//    let iyzicoTransferVCiyzicoTitleHighleted = "Her zaman iyzico'ya aktar"
//    let iyzicoTransferVCButtonTitle = "Aktar"
//    let iyzicoTransferVCTranferAllButtonTitle = "Tümünü Aktar"
//    let iyzicoTransferVCIyzicoButtonCashoutTitle = "Hesabıma Aktar"
//    let iyzicoTransferVCIyzicoButtonTopUpTitle = "Hesabıma Yükle"
//
//
//    // MARK: - IyzicoHomeVC Default Data
//    let iyzicoMenuTitle1 = "Hesabım"
//    let iyzicoMenuTitle2 = "Kredi Kartı"
//    let iyzicoMenuTitle3 = "Havale / EFT"
//
//    let iyzicoHomeVCTitleText = "Korumalı Ödeme Yöntemleri"
//    let iyzicoHomeVCAmountText = "Yüklenecek Tutar"
//    let iyzicoHomeVCInfoText =  "Aktaracağız tutar 1 saat içinde hesabınıza yansıyacaktır."
//
//    // MARK: - NewCardCell Default Data
//    let newCardCellCardText = "Yeni kart ile öde"
//    let newCardCellCardUserText = "Kart sahibi"
//    let newCardCellCardUserPlaceholder = "Kart sahibinin ismini yazınız."
//    let newCardCellCardNumberText = "Kart numarası"
//    let newCardCellCardNumberPlaceholder = "Kart numarasını yazınız."
//    let newCardCellCardDateText = "Skt tarihi"
//    let newCardCellCardDatePlaceholder = "AA/YY"
//    let newCardCellCardCodeText = "CVV"
//    let newCardCellCardCodePlaceholder = "123"
//    let newCardCellCardInfoText = "Kart bilgileriniz iyzico tarafından saklanır."
//    let newCardCellCardAmountLabelText = "Bakiye Kullan"
//
//    // MARK: - MyAccountCell Default Data
//    let myAccountCellTitleText = "Hesabındaki bakiyen ile kolayca ödeme\nyapabilirsin."
//    let myAccountCellAccountText = "Güncel Hesabım"
//    let myAccountCellDetailText = "Hesabınıza iyzico mobil uygulamasından\npara yükleyebilirsiniz."
//    let myAccountCellDetailAttText = "iyzico mobil uygulama"
//
//
//    //MARK: - NewMemberVC
//    struct NewMemberVCConstants {
//        static let titleLabelText = "iyzico ile tüm ödemelerinde kontrol sende!"
//        static let titleDescriptionLabelText = "Saklı kartınla veya bakiyenle kolayca ödeme imkanı Korumalı Alışveriş güvencesiyle iyzico’da."
//        static let emailTextInputViewTitle = "E-Posta Adresin"
//        static let phoneTextInputViewTitle = "Telefon Numarası"
//        static let infoViewText = "Bakiyenizi iyzico’ya aktarabilmek için iyzico uygulamasında da bu mail adresiyle hesap açmanız gerekmektedir. Başka bir e-posta adresi kullanmak istiyorum."
//        static let infoViewHighlightedText = "Başka bir e-posta adresi kullanmak istiyorum."
//        static let secondInfoViewText = "Çerçeve Sözleşmesi’ni ve KVKK Aydınlatma Metni’ni okuduğumu ve onayladığımı kabul ediyorum."
//        static let kvkkHighlightedText = "KVKK Aydınlatma Metni"
//        static let boundsHighlightedText = "Çerçeve Sözleşmesi"
//        static let continueButtonTitle = "Devam Et"
//    }
//    //MARK: - SettlementVC
//    struct SettlementVCConstants {
//        static let balanceToDeliveryLabelText = "Aktaralacak Bakiye"
//        static let alwaysDeliveryLabelText = "Her zaman iyzico bakiyeme aktar."
//        static let alwaysDeliverySubLabelText = "Bu ayarı daha sonra değiştirebilirsin."
//        static let deliveryButtonTitle = "iyzico Hesabıma Aktar"
//    }
//
//    //MARK: - EmailSupportVC
//    struct EmailSupportVCConstants {
//        static let title = "Destek"
//        static let description1LabelText = "iyzico, 2012 yılında, farklı alanlarda hizmet veren çeşitli büyüklüklerdeki e-ticaret şirketlerine, kolay ve güvenli ödeme yönetim platformu sunma amacıyla Barbaros Özbuğutu ve Tahsin Isın tarafından İstanbul’da kuruldu."
//        static let description2LabelText = "Avrupa’nın saygın şirketlerinde uzun yıllar önemli pozisyonlarında görev alan Özbuğutu ve Isın, bu alandaki tecrübelerini iyzico ile Türkiye pazarına taşıdılar ve tamamen bu pazara adapte olmuş inovatif bir platform oluşturdular."
//        static let getSupportButtonTitle = "Get Support"
//    }
//
//    //MARK: - IyzicoEFTDetailVC
//    let iban = "IBAN"
//    let accountOwner = "Hesap Sahibi"
//    let amount = "Aktarmanız Gereken Tutar"
//    let desc = "Açıklama"
//    let iyzicoEFTDetailVCShareText = "Paylaş"
//    let iyzicoEFTDetailVCCompleteOrderText = "Siparişi Tamamla"
//    let iyzicoEFTDetailVCReturnAppText = "Uygulamaya Dön"
//    let iyzicoEFTDetailVCInfoText = " Açıklama alanına cep telefonunuzu yazmanız gerekmektedir."
//
//    //MARK: - ResultVC
//    struct ResultVC {
//        static let seeBankInformation = "Banka Bilgilerini Gör"
//        static let returnToApp = "Uygulamaya Dön"
//        static let supportDescription = "İşlemlerini iyzico uygulamasından kolayca takip edebilir, 7/24 destek alabilirsin."
//        static let iyzicoTrust = "iyzico güvencesiyle"
//        static let deliverySucceced = "hesaba aktarma başarıyla gerçekleşti."
//        static let willDeliverToYourAccount = "Talebin onaylandığı anda iyzico hesabına aktarılacak."
//        static let refundRequestTaken = "iade talebiniz başarıyla alındı."
//        static let willRefundAmount = "İade Edilecek Tutar"
//        static let loadedToAccount = "hesabınıza yüklendi."
//        static let redirectTo = "\(SDKManager.brand ?? "") 'a yönlendiriliyorsunuz"
//        static let deliveryRequestTaken = "hesaba aktarma talebiniz başarıyla alındı."
//        static let willDeliverAmountToYourAccount = "Hesaba Aktarılacak Tutar"
//        static let payRequestTaken = "ödeme talebiniz başarıyla alındı."
//        static let orderWillApprove = "Siparişiniz havale/eft işleminin gerçekleşmesinden sonra onaylanacaktır."
//        static let threeDTitle = "3D Secure \n(Güvenli Ödeme) "
//        static let waitingRedirectToThreeD = "Ödemenizi tamamlamak için 3D Secure doğrulamasına yönlendiriliyorsunuz"
//        static let payTaken = "ödemeniz başarıyla alındı."
//        static let redirectingToApp = "Uygulamaya yönlendiriliyorsunuz"
//        static let payNotCompleted = "Ödemeni tamamlayamadık."
//        static let appStoreIyzicoLink = "itms-apps://itunes.apple.com/app/id1436467445"
//    }
//
//    //MARK: - MemberVC
//    struct MemberVC {
//        static let titleLabel = "iyzico ile tüm ödemelerinde kontrol sende!"
//        static let subTitleLabel = "Saklı kartınla veya bakiyenle kolayca ödeme imkanı Korumalı Alışveriş güvencesiyle iyzico’da."
//        static let memberButtonDescription = "olarak devam et"
//        static let changeAccountButton = "Hesap Değiştir"
//    }
//
//    //MARK: - InternalMessage
//    let successText = "Operation successful."
//    let errorText = "Operation failed with unknown error."
//    let timeOutText = "Operation timeout."
//    let phoneErrorText = "Phone number is required."
//    let emailErrorText = "Email adress is required."
//    let brandErrorText = "Invalid brand."
//    let priceErrorText = "Invalid price."
//    let idErrorText = "Invalid product id."
//    let apikeyErrorText = "Invalid api key."
//
//    //MARK: - Formats
//    struct Formats {
//        static let doubleTwoDigitAfterComma = "%.2f"
//        static let tLText = "TL"
//        static let tlAscii = "₺"
//        static let securePasswordAscii = "•"
//    }
//
//    //MARK: - Iyzico
//    struct IyzicoLog {
//        static let iyzicoStarted = "IyzicoSDK started. v\(GlobalMethodsManager.getSdkVersion())"
//        static let iyzicoClosed = ""
//        static let iyzicoDateFormat = "dd-MM-yyyy HH:mm:ss"
//    }
//
//}
//
//open class StringConstant {
//
//
//    public static let shared = StringConstant()
//
//    // MARK: - Bundle Identifier
//    public let frameworkBundle = "com.basefy.iyzi-co-test-framework"
//
//    // MARK: - FONT
//    let markPro = "MarkPro.otf"
//    let markProItalic = "MarkPro-Italic.otf"
//    let markProLightItalic = "MarkPro-Light-Italic.otf"
//    let markProMedium = "MarkPro-Medium.otf"
//    let markProLight = "MarkPro-Light.otf"
//    let markProBold = "MarkPro-Bold.otf"
//    let markProBook = "MarkPro-Book.otf"
//
//    // MARK: - General
//    let continueButtonTitle = "iyzico_common_contunie".localized
//    let payWithIyzico = "iyzico ile Öde" //dosyada yok
//    let keyboardDoneTitle = "iyzico_close".localized
//    let comma = ","
//    let dot = "."
//
//    // MARK: - IyzicoPopUpView Default Data
//    let iyzicoButtonError: String = "iyzico_okey_text".localized
//    let iyzicoButtonTitle: String = "iyzico_custom_popup_close_continue_button".localized
//    let iyzicoPopUpViewTryAgainTitle: String = "iyzico_custom_popup_try_again".localized
//    let iyzicoButtonOptionalTitle: String = "iyzico_custom_popup_close_page_button_text".localized
//    let iyzicoPopUpViewDescText = "iyzico_custom_popup_warning_close_page".localized
//    let iyzicoPopUpViewTimeOutDesc = "iyzico_buying_time_is_finish_error".localized
//
//
//    // MARK: - IyzicoTextArea Default Data
////    let textAreaPlaceholder = "Type Here"
//
//
//    // MARK: - IyzicoTextInput Default Data
////    let textInputDatePlaceholder = "Gün/Ay/Yıl" //dosyada yok
//    public let externalBorderName = "externalBorder"
////    let textInputSeperator: String = "-"
//    let textInputDateSeperator: String = "/"
//
//    struct IyzicoAmountView {
//        static let fullTextFieldPlaceHolder = "₺0,00"
//        static let naturalNumberFieldPlaceHolder = "₺0"
//        static let decimalNumberTextFieldPlaceholder = ",00"
//    }
//
//    // MARK: - IyzicoNavBar Default Data
//    let titleLabelName: String = "iyzico_title_payment".localized
////    let amountLabelName: String = "Ödenecek Tutar: " //dosyada yok
//    let timeLabelName: String = "Kalan Süre:" // android formati ile yazilmis
//    let cancelButtonTitle = "iyzico_custom_popup_close".localized
//    let priceTitleLabelName = "iyzico_sum_price".localized
//    let navBarBalanceTitle = "iyzico_common_your_balance".localized
//    let closeButtonTitle = "iyzico_close".localized
//
//
//    // MARK: - Intro
//    public let introTitle = "iyzico Korumalı Alışveriş ile" //dosyada yok
//    public let introBody = "Güvenle Ödeme Yap" //dosyada yok
//
//
//    // MARK: - PhoneVC Default Data
//    let buttonTextFieldTitle: String = "iyzico_fragment_phone_number".localized
//    let phoneButtonTitle: String = "iyzico_fragment_send_code".localized
//    let defaultPhoneCode: String = "iyzico_turkey_phone_code".localized
//    let emailTextFieldTitle: String = "iyzico_fragment_email_email".localized
//    let emailPlaceHolder: String = "iyzico_fragment_email_write_email".localized
//    let phonePlaceHolder: String = "Telefon numaranı yaz" //dosyada yok
////    public let phoneVCTermString: String = "Devam ederek KVKK Aydınlatma Metni’ni okuduğunuzu kabul etmektesiniz." //dosyada yok
////    public let phoneVCTermHighletedString: String = "KVKK Aydınlatma Metni" //metin birlesik olarak yazilmis
//
//
//    // MARK: - OTPVC Default Data
//    let otpVCChangePhoneButtonTitle: String = "iyzico_change".localized
//    let otpVCSupportButtonTitle: String = "iyzico_support_screen_title".localized
//    let otpVCSendAgainButtonTitle: String = "iyzico_send_again".localized
//    let otpVCSendAgainTitleText: String = "iyzico_fragment_sms_control".localized
//    let otpVCSendAgainCodeText: String = "iyzico_fragment_sms_verificate_phone".localized
//    let otpVCSmsSendedText = "iyzico_send_sms".localized
//
//    // MARK: - IyzicoInfoVC Default Data
////    let iyzicoInfoVCRecievedIyzicoTitle = "iyzico_fragment_infto_transfer_assurance_of_iyzico".localized
////    let iyzicoInfoVCRecievedIyzicoFulltitle = "iyzico güvencesiyle \n ödemeniz başarıyla alındı." //metin ayri olarak yazilmis
////    let iyzicoInfoVCTransferredIyzicoTitle =  "Hesabına Aktardık!" //dosyada yok
////    let iyzicoInfoVCTransferringIyzicoTitle = "İadeni Hesabına Aktarıyoruz" //dosyada yok
////    let iyzicoInfoVCAllOkIyzicoTitle = "Hepsi Tamam" //dosyada yok
//
////    let iyzicoInfoVCRecievedDescText = "yönlendiriliyorsunuz." //android de birlesik yazilmis
////    let iyzicoInfoVCTransferredDescText = "adresine kayıtlı \n iyzico hesabına aktarma işlemini tamamladık." //dosyada yok
////    let iyzicoInfoVCTransferringDescText = "Bu iadenin iyzico bakiyene aktarılmasını \n onaylıyor musun?" //dosyada yok
////    let iyzicoInfoVCAllOkDescText = "başarıyla hesabınıza işlenmiştir."// dosyada yok
//
////    let iyzicoInfoVCReturnApp = "iyzico_common_button_back_app".localized
////    let iyzicoInfoVCApprove = "iyzico_common_accept".localized
////    let iyzicoInfoVCMainPage = "Ana Sayfa" //dosyada yok
//
////    let iyzicoInfoVCTransferTitle = "Aktarılıcak iade Tutarı"//dosyada yok
////    let iyzicoInfoVCBalanceTitle = "bakiyem"//dosyada yok
//
//    // MARK: - IyzicoTransferVC Default Data
////    let iyzicoTransferVCAmountTitle = "Tutar" //Dosyada yok
//    let iyzicoTransferVCAmountForLoadTitle = "Yüklenecek Tutar" //dosyada yok
//    let iyzicoTransferVCAmountTitle = "Yüklenecek Tutar" //dosyada yok
//    let iyzicoTransferVCCashoutTitle = "Tutar" // dosyada Toplam Tutar yazilmis
//    let iyzicoTransferVCDefaultAmount = "₺0,00"
//    let iyzicoTransferVCDefaultAmountWithNoSembol = "0,00"
//    let iyzicoTransferVCDefaultTL = "₺"
//    let iyzicoTransferVCTransferTitle = "iyzico_can_transfer_all".localized
////    let iyzicoTransferVCiyzicoTitle = "Her zaman iyzico'ya aktar\nBu ayarı daha sonra değiştirebilirsin" // dosyada yok
////    let iyzicoTransferVCiyzicoTitleHighleted = "iyzico_common_transfer_information_textView".localized //Her zaman iyzico'ya aktar yazilmis ios ta
////    let iyzicoTransferVCButtonTitle = "Aktar" //dosyada yok
//    let iyzicoTransferVCTranferAllButtonTitle = "iyzico_transfer_all".localized
//    let iyzicoTransferVCIyzicoButtonCashoutTitle = "Hesabıma Aktar" // iyzico Hesabıma Aktar yazilmis
//    let iyzicoTransferVCIyzicoButtonTopUpTitle = "Hesabıma Yükle" // dosyada yok
//
//    //------
//    // MARK: - IyzicoHomeVC Default Data
//    let iyzicoMenuTitle1 = "iyzico_my_account".localized
//    let iyzicoMenuTitle2 = "iyzico_my_credit_cards".localized
//    let iyzicoMenuTitle3 = "iyzico_havale_eft".localized //
//
//    let iyzicoHomeVCTitleText = "iyzico_protected_payment_methots".localized
//    let iyzicoHomeVCAmountText = "Yüklenecek Tutar" //dosyada yok
//    let iyzicoHomeVCInfoText =  "Aktaracağız tutar 1 saat içinde hesabınıza yansıyacaktır." // dosyada yok
//
//    // MARK: - NewCardCell Default Data
//    let newCardCellCardText = "iyzico_pay_with_new_card".localized
//    let newCardCellCardUserText = "iyzico_input_car_name".localized
//    let newCardCellCardUserPlaceholder = "iyzico_input_car_name_example".localized
//    let newCardCellCardNumberText = "iyzico_input_card_number".localized //ios ta Kart numarası yazilmis "n kucuk"
//    let newCardCellCardNumberPlaceholder = "iyzico_input_card_number_example".localized
//    let newCardCellCardDateText = "iyzico_input_card_date".localized
//    let newCardCellCardDatePlaceholder = "iyzico_input_card_date_example".localized
//    let newCardCellCardCodeText = "iyzico_input_card_cvv".localized // iosta CVV olarak yazilmis
//    let newCardCellCardCodePlaceholder = "iyzico_input_card_cvv_example".localized
//    let newCardCellCardInfoText = "iyzico_saving_card_datas".localized
//    let newCardCellCardAmountLabelText = "iyzico_use_my_balance".localized
//
//    // MARK: - MyAccountCell Default Data
//    let myAccountCellTitleText = "Hesabındaki bakiyen ile kolayca ödeme\nyapabilirsin." //ios ta \n koyulmus
//    let myAccountCellAccountText = "iyzico_my_current_balance".localized
//    let myAccountCellDetailText = "Hesabınıza iyzico mobil uygulamasından\npara yükleyebilirsiniz." //iosta \n koyulmus
//    let myAccountCellDetailAttText = "iyzico mobil uygulama" //dosyada yok
//
//
//    //MARK: - NewMemberVC
//    struct NewMemberVCConstants {
//        static let titleLabelText = "iyzico_fragment_login_title".localized //android de cumle sonunda ! yok
//        static let titleDescriptionLabelText = "iyzico_fragment_login_second_title".localized
//        static let emailTextInputViewTitle = "iyzico_fragment_email_email".localized
//        static let phoneTextInputViewTitle = "iyzico_input_phone_number".localized
//        static let infoViewText = "iyzico_cashout_login_information".localized
//        static let infoViewHighlightedText = "Başka bir e-posta adresi kullanmak istiyorum."// dosyada yok
//        static let secondInfoViewText = "iyzico_fragment_email_term".localized
//        static let kvkkHighlightedText = "KVKK Aydınlatma Metni" //android de ayri bir metin yok
//        static let boundsHighlightedText = "Çerçeve Sözleşmesi" //android de ayri bir metin yok
//        static let continueButtonTitle = "iyzico_common_contunie".localized
//    }
//    //MARK: - SettlementVC
//    struct SettlementVCConstants {
//        static let balanceToDeliveryLabelText = "Aktaralacak Bakiye" //dosyada yok
//        static let alwaysDeliveryLabelText = "iyzico_common_transfer_information_textView".localized
//        static let alwaysDeliverySubLabelText = "iyzico_fragment_settlement_setting_explanation".localized
//        static let deliveryButtonTitle = "iyzico_transfer_my_acount".localized
//    }
//
//    //MARK: - EmailSupportVC
//    struct EmailSupportVCConstants {
//        static let title = "iyzico_support_screen_title".localized
//        static let description1LabelText = "iyzico_support_top_text".localized
//        static let description2LabelText = "iyzico_soport_secondary_text".localized
//        static let getSupportButtonTitle = "iyzico_get_support".localized
//    }
//
//    //MARK: - IyzicoEFTDetailVC
//    let iban = "IBAN" //dosyada yok
//    let accountOwner = "Hesap Sahibi" // hepsi birlesik yazilmis
//    let amount = "Aktarmanız Gereken Tutar"// dosyada yok
//    let desc = "Açıklama" // dosyada yok
//    let iyzicoEFTDetailVCShareText = "iyzico_common_share".localized
//    let iyzicoEFTDetailVCCompleteOrderText = "iyzico_common_finish_order".localized
//    let iyzicoEFTDetailVCReturnAppText = "iyzico_common_button_back_app".localized
//    let iyzicoEFTDetailVCInfoText = "Açıklama alanına cep telefonunuzu yazmanız gerekmektedir." //dosyada yok
//
//    //MARK: - ResultVC
//    struct ResultVC {
//        static let seeBankInformation = "iyzico_see_bank_Details".localized
//        static let returnToApp = "iyzico_common_button_back_app".localized
//        static let supportDescription = "iyzico_fragment_info_transfer_confirm_message".localized
//        static let iyzicoTrust = "iyzico_fragment_infto_transfer_assurance_of_iyzico".localized
//        static let deliverySucceced = "hesaba aktarma başarıyla gerçekleşti."
//        static let willDeliverToYourAccount = "iyzico_fragment_info_transfer_secondary_info".localized
//        static let refundRequestTaken = "iade talebiniz başarıyla alındı." //dosyada yok
//        static let willRefundAmount = "iyzico_refaund_payment".localized
//        static let loadedToAccount = "hesabınıza yüklendi." //android de buyuk harf ile baslamis
//        static let redirectTo = "\(SDKManager.brand ?? "") 'a yönlendiriliyorsunuz" //android de static olarak lidyana.com a yonlendiriliyorsunuz yazilmis
//        static let deliveryRequestTaken = "iyzico_fragment_info_transfer_success".localized //android de buyuk harfle basliyor
//        static let willDeliverAmountToYourAccount = "iyzico_trasfer_to_account".localized
//        static let payRequestTaken = "iyzico_fragment_info_transfer_details_title".localized
//        static let orderWillApprove = "iyzico_fragment_info_transfer_details_second_title".localized
//        static let threeDTitle = "3D Secure \n(Güvenli Ödeme) " //android de bosluklu yazilmis
//        static let waitingRedirectToThreeD = "iyzico_directed_three_d_payment".localized
//        static let payTaken = "iyzico_payment_successfully_achieved".localized
//        static let redirectingToApp = "iyzico_redirected_to_application".localized
//        static let payNotCompleted = "iyzico_not_complate_payment".localized //androidde sonunda nokta yok
//        static let appStoreIyzicoLink = "itms-apps://itunes.apple.com/app/id1436467445"
//    }
//
//    //MARK: - MemberVC
//    struct MemberVC {
//        static let titleLabel = "iyzico_fragment_login_title".localized //androidde sonunda unlem yok
//        static let subTitleLabel = "iyzico_fragment_login_second_title".localized
//        static let memberButtonDescription = "olarak devam et" //dosyada yok
//        static let changeAccountButton = "iyzico_fragment_login_change_acount".localized
//    }
//
//    //MARK: - InternalMessage
//    let successText = "Operation successful."
//    let errorText = "Operation failed with unknown error."
//    let timeOutText = "Operation timeout."
//    let phoneErrorText = "Phone number is required."
//    let emailErrorText = "Email adress is required."
//    let brandErrorText = "Invalid brand."
//    let priceErrorText = "Invalid price."
//    let idErrorText = "Invalid product id."
//    let apikeyErrorText = "Invalid api key."
//
//    //MARK: - Formats
//    struct Formats {
//        static let doubleTwoDigitAfterComma = "%.2f"
//        static let tLText = "TL"
//        static let tlAscii = "₺"
//        static let securePasswordAscii = "•"
//    }
//
//    //MARK: - Iyzico
//    struct IyzicoLog {
//        static let iyzicoStarted = "IyzicoSDK started. v\(GlobalMethodsManager.getSdkVersion())"
//        static let iyzicoClosed = ""
//        static let iyzicoDateFormat = "dd-MM-yyyy HH:mm:ss"
//    }
//
//}

open class StringConstant {
    
    
    public static let shared = StringConstant()
    
    // MARK: - Bundle Identifier
    public let frameworkBundle = "com.basefy.iyzi-co-test-framework"
    
    // MARK: - FONT
    let markPro = "MarkPro.otf"
    let markProItalic = "MarkPro-Italic.otf"
    let markProLightItalic = "MarkPro-Light-Italic.otf"
    let markProMedium = "MarkPro-Medium.otf"
    let markProLight = "MarkPro-Light.otf"
    let markProBold = "MarkPro-Bold.otf"
    let markProBook = "MarkPro-Book.otf"
    
    // MARK: - General
    let continueButtonTitle = "iyzico_common_contunie".localized
    let payWithIyzico = "iyzico_account_fragment_button".localized
    let keyboardDoneTitle = "iyzico_close".localized
    let keyboardDoneTitleV2 = "iyzico_close".localized
    let comma = ","
    let dot = "."
    
    // MARK: - IyzicoPopUpView Default Data
    let iyzicoButtonError: String = "iyzico_okey_text".localized
    let iyzicoButtonTitle: String = "iyzico_custom_popup_close_continue_button".localized
    let iyzicoPopUpViewTryAgainTitle: String = "iyzico_custom_popup_try_again".localized
    let iyzicoButtonOptionalTitle: String = "iyzico_custom_popup_close_page_button_text".localized
    let iyzicoPopUpViewDescText = "iyzico_custom_popup_warning_close_page".localized
    let iyzicoPopUpViewTimeOutDesc = "iyzico_buying_time_is_finish_error".localized
    let iyzicoPopUpViewTopUpDescriptionText = "iyzico_close_widget_pop_up_top_up".localized
    let iyzicoPopUpViewSettlementDescriptionText = "iyzico_close_widget_pop_up_settlement".localized
    let iyzicoPopUpViewRefundDescriptionText = "iyzico_close_widget_pop_up_refund".localized
    let iyzicoPopUpViewCashoutDescriptionText = "iyzico_close_widget_pop_up_cashout".localized
    let iyzicoPopUpViewPwiDescriptionText = "iyzico_close_widget_pop_up_pwi".localized
    let iyzicoPopUpViewTopUpButtonText = "iyzico_close_widget_pop_up_top_up_button".localized
    let iyzicoPopUpViewSettlementButtonText = "iyzico_close_widget_pop_up_settlement_button".localized
    let iyzicoPopUpViewRefundButtonText = "iyzico_close_widget_pop_up_refund_button".localized
    let iyzicoPopUpViewCashoutButtonText = "iyzico_close_widget_pop_up_cashout_button".localized
    let iyzicoPopUpViewPwiButtonText = "iyzico_close_widget_pop_up_pwi_button".localized
    
    // MARK: - IyzicoTextArea Default Data
    let textAreaPlaceholder = "Type Here"
    
    
    // MARK: - IyzicoTextInput Default Data
    let textInputDatePlaceholder = "Gün/Ay/Yıl" //discarded
    public let externalBorderName = "externalBorder"
    let textInputSeperator: String = "-" //discarded
    let textInputDateSeperator: String = "/"
    
    struct IyzicoAmountView {
        static let fullTextFieldPlaceHolder = "₺0,00"
        static let validationControl = "₺,00"
//        static let naturalNumberFieldPlaceHolder = "₺0"
        static let currencySymbolPlaceHolder = "₺"
        static let naturalNumberFieldPlaceHolder = "0"
        static let decimalNumberTextFieldPlaceholder = ",00"
    }
    
    // MARK: - IyzicoNavBar Default Data
    let titleLabelName: String = "iyzico_title_payment".localized
    let amountLabelName: String = "Ödenecek Tutar: " //discarded
    let timeLabelName: String = "iyzico_remaining_time".localized
    let cancelButtonTitle = "iyzico_custom_popup_close".localized
    let cancelButtonTitleForPopUp = "iyzico_close".localized
    let priceTitleLabelName = "iyzico_sum_price".localized
    let navBarBalanceTitle = "iyzico_common_your_balance".localized
    let closeButtonTitle = "iyzico_close".localized
  
    
    // MARK: - Intro
    public let introTitle = "iyzico Korumalı Alışveriş ile" //discarded
    public let introBody = "Güvenle Ödeme Yap" //discarded
    
  
    // MARK: - PhoneVC Default Data
    let buttonTextFieldTitle: String = "iyzico_fragment_phone_number".localized
    let phoneButtonTitle: String = "iyzico_fragment_send_code".localized
    let defaultPhoneCode: String = "iyzico_turkey_phone_code".localized
    let emailTextFieldTitle: String = "iyzico_fragment_email_email".localized
    let emailPlaceHolder: String = "iyzico_fragment_email_write_email".localized
    let phonePlaceHolder: String = "Telefon numaranı yaz" // tamamen bos olma ihtimali yok
    public let phoneVCTermString: String = "Devam ederek KVKK Aydınlatma Metni’ni okuduğunuzu kabul etmektesiniz." //discarded
    public let phoneVCTermHighletedString: String = "KVKK Aydınlatma Metni" //discarded
    
    
    // MARK: - OTPVC Default Data
    let otpVCChangePhoneButtonTitle: String = "iyzico_change".localized
    let otpVCSupportButtonTitle: String = "iyzico_support_screen_title".localized
    let otpVCSendAgainButtonTitle: String = "iyzico_send_again".localized
    let otpVCSendAgainTitleText: String = "iyzico_fragment_sms_control".localized
    let otpVCSendAgainCodeText: String = "iyzico_fragment_sms_verificate_phone".localized
    let otpVCSmsSendedText = "iyzico_send_sms".localized
    
    // MARK: - IyzicoInfoVC Default Data
    let iyzicoInfoVCRecievedIyzicoTitle = "iyzico_fragment_infto_transfer_assurance_of_iyzico".localized
    let iyzicoInfoVCRecievedIyzicoFulltitle = "iyzico güvencesiyle \n ödemeniz başarıyla alındı."//discarded
    let iyzicoInfoVCTransferredIyzicoTitle =  "Hesabına Aktardık!"//discarded
    let iyzicoInfoVCTransferringIyzicoTitle = "İadeni Hesabına Aktarıyoruz"//discarded
    let iyzicoInfoVCAllOkIyzicoTitle = "Hepsi Tamam"//discarded
    
    let iyzicoInfoVCRecievedDescText = "yönlendiriliyorsunuz."//discarded
    let iyzicoInfoVCTransferredDescText = "adresine kayıtlı \n iyzico hesabına aktarma işlemini tamamladık."//discarded
    let iyzicoInfoVCTransferringDescText = "Bu iadenin iyzico bakiyene aktarılmasını \n onaylıyor musun?"//discarded
    let iyzicoInfoVCAllOkDescText = "başarıyla hesabınıza işlenmiştir."//discarded
    
    let iyzicoInfoVCReturnApp = "iyzico_common_button_back_app".localized//discarded
    let iyzicoInfoVCApprove = "iyzico_common_accept".localized//discarded
    let iyzicoInfoVCMainPage = "Ana Sayfa" //discarded
    
    let iyzicoInfoVCTransferTitle = "Aktarılıcak iade Tutarı" //discarded
    let iyzicoInfoVCBalanceTitle = "bakiyem" //discarded
    
    // MARK: - IyzicoTransferVC Default Data
//    let iyzicoTransferVCAmountTitle = "Tutar" //discarded
    let iyzicoTransferVCAmountForLoadTitle = "iyzico_amount_to_install".localized
    let iyzicoTransferVCAmountTitle = "iyzico_amount_to_install".localized
    let iyzicoTransferVCCashoutTitle = "iyzico_amount_to_install".localized
    let iyzicoTransferVCDefaultAmount = "₺0,00"
    let iyzicoTransferVCDefaultAmountWithNoSembol = "0,00"
    let iyzicoTransferVCDefaultTL = "₺"
    let iyzicoTransferVCTransferTitle = "iyzico_can_transfer_all".localized
    let iyzicoTransferVCiyzicoTitle = "Her zaman iyzico'ya aktar\nBu ayarı daha sonra değiştirebilirsin" //discarded
    let iyzicoTransferVCiyzicoTitleHighleted = "iyzico_common_transfer_information_textView".localized //discarded
    let iyzicoTransferVCButtonTitle = "Aktar" //discarded
    let iyzicoTransferVCTranferAllButtonTitle = "iyzico_transfer_all".localized
    let iyzicoTransferVCIyzicoButtonCashoutTitle = "iyzico_transfer_my_account".localized
    let iyzicoTransferVCIyzicoButtonTopUpTitle = "iyzico_transfer_money".localized
    let iyzicoTransferVC20Tl = "iyzico_20_tl".localized
    let iyzicoTransferVC50Tl = "iyzico_50_tl".localized
    let iyzicoTransferVC100Tl = "iyzico_100_tl".localized
    let iyzicoTransferVC200Tl = "iyzico_200_tl".localized
    
    //------
    // MARK: - IyzicoHomeVC Default Data
    let iyzicoNoInstallmentLabelText = "iyzico_one_installment_one_shot".localized
    
    let iyzicoMenuTitle1 = "iyzico_my_account".localized
    let iyzicoMenuTitle2 = "iyzico_my_credit_cards".localized
    let iyzicoMenuTitle3 = "iyzico_havale_eft".localized
    
    let iyzicoHomeVCTitleText = "iyzico_protected_payment_methots".localized
    let iyzicoHomeVCAmountText = "iyzico_amount_to_install".localized
    let iyzicoHomeVCInfoText =  "iyzico_amount_transfer_refrected_one_hour".localized
    let iyzicoHomeVCInstallmentInfoText = "iyzico_payment_options_shows_after_you_filled_a".localized
   
    // MARK: - NewCardCell Default Data
    let newCardCellCardText = "iyzico_pay_with_new_card".localized
    let newCardCellCardUserText = "iyzico_input_car_name".localized
    let newCardCellCardUserPlaceholder = "iyzico_input_car_name_example".localized
    let newCardCellCardNumberText = "iyzico_input_card_number".localized
    let newCardCellCardNumberPlaceholder = "iyzico_input_card_number_example".localized
    let newCardCellCardDateText = "iyzico_input_card_date".localized
    let newCardCellCardDatePlaceholder = "iyzico_input_card_date_example".localized
    let newCardCellCardCodeText = "iyzico_input_card_cvv".localized
    let newCardCellCardCodePlaceholder = "iyzico_input_card_cvv_example".localized
    let newCardCellCardInfoText = "iyzico_saving_card_datas".localized
    let newCardCellCardAmountLabelText = "iyzico_use_my_balance".localized
    
    // MARK: - MyAccountCell Default Data
    let myAccountCellTitleText = "iyzico_account_fragment_wallet_description".localized
    let myAccountCellAccountText = "iyzico_my_current_balance".localized
    let myAccountCellDetailText = "iyzico_my_current_balance_description".localized
    let myAccountCellDetailAttText = "iyzico_mobile_app".localized
    let myAccountCellBalanceLoadedText = "iyzico_topup_balance_loaded".localized
    
    
    //MARK: - NewMemberVC
    struct NewMemberVCConstants {
        static let titleLabelText = "iyzico_fragment_login_title".localized
        static let titleDescriptionLabelText = "iyzico_fragment_login_second_title".localized
        static let emailTextInputViewTitle = "iyzico_fragment_email_email".localized
        static let phoneTextInputViewTitle = "iyzico_input_phone_number".localized
        static let infoViewText = "iyzico_cashout_login_information".localized
        static let infoViewHighlightedText = "iyzico_use_different_email".localized
        static let secondInfoViewText = "iyzico_fragment_email_term".localized
        static let kvkkHighlightedText = "iyzico_kvkk_high_lighted_text".localized
        static let boundsHighlightedText = "iyzico_bounds_high_lighted_text".localized
        static let continueButtonTitle = "iyzico_common_contunie".localized
    }
    //MARK: - NotaMemberVC
    struct NotaMemberVCConstants {
        static let contactPermissionText = "iyzico_contact_permission_sentence".localized
        static let contactPermissionHighlight = "iyzico_contact_permission".localized
        static let kvkkPermissionText = "iyzico_kvkk_permission_sentence".localized
        static let kvkkPermissionHighlight = "iyzico_kvkk_permission".localized
        static let userAgreementPermissionText = "iyzico_user_agreement_permission_sentence".localized
        static let userAgreementPermissionHighlight = "iyzico_user_agreement_permission".localized
        static let userAgreementPermissionErrorText = "iyzico_user_agreement_error".localized
    }
    //MARK: - SettlementVC
    struct SettlementVCConstants {
        static let balanceToDeliveryLabelText = "iyzico_transferred_balance".localized
        static let alwaysDeliveryLabelText = "iyzico_common_transfer_information_textView".localized
        static let alwaysDeliverySubLabelText = "iyzico_fragment_settlement_setting_explanation".localized
        static let deliveryButtonTitle = "iyzico_transfer_my_acount".localized
    }
    
    //MARK: - EmailSupportVC
    struct EmailSupportVCConstants {
        static let title = "iyzico_support_screen_title".localized
        static let description1LabelText = "iyzico_support_top_text".localized
        static let description2LabelText = "iyzico_soport_secondary_text".localized
        static let getSupportButtonTitle = "iyzico_get_support".localized
    }
    
    //MARK: - IyzicoEFTDetailVC
    let iban = "iyzico_bank_information_iban".localized
    let accountOwner = "iyzico_bank_information_account_holder".localized
    let amount = "iyzico_amount_have_to_transfer".localized
    let desc = "iyzico_explanation".localized
    let iyzicoEFTDetailVCShareText = "iyzico_common_share".localized
    let iyzicoEFTDetailVCCompleteOrderText = "iyzico_common_finish_order".localized
    let iyzicoEFTDetailVCReturnAppText = "iyzico_common_button_back_app".localized
    let iyzicoEFTDetailVCInfoText = "iyzico_bottom_sheet_remittence_phone_number_warning".localized
   
    //MARK: - ResultVC
    struct ResultVC {
        static let seeBankInformation = "iyzico_see_bank_Details".localized
        static let returnToApp = "iyzico_common_button_back_app".localized
        static let tryAgain = "iyzico_common_button_try_again".localized
        static let supportDescription = "iyzico_fragment_info_transfer_confirm_message".localized
        static let iyzicoTrust = "iyzico_fragment_infto_transfer_assurance_of_iyzico".localized
        static let deliverySucceced = "iyzico_fragment_info_transfer_success".localized
        static let willDeliverToYourAccount = "iyzico_fragment_info_transfer_secondary_info".localized
        static let refundRequestTaken = "iyzico_refaund_received".localized
        static let willRefundAmount = "iyzico_refaund_payment".localized
        static let loadedToAccount = "iyzico_added_your_account".localized
        static let redirectTo = (SDKManager.brand ?? "") + "iyzico_direct_lidyana".localized
        static let deliveryRequestTaken = "iyzico_fragment_info_transfer_success".localized
        static let willDeliverAmountToYourAccount = "iyzico_trasfer_to_account".localized
        static let payRequestTaken = "iyzico_fragment_info_transfer_details_title".localized
        static let orderWillApprove = "iyzico_fragment_info_transfer_details_second_title".localized
        static let threeDTitle = "iyzico_fragment_info_three_d_payment_title".localized
        static let waitingRedirectToThreeD = "iyzico_directed_three_d_payment".localized
        static let payTaken = "iyzico_payment_successfully_achieved".localized
        static let redirectingToApp = "iyzico_redirected_to_application".localized
        static let payNotCompleted = "iyzico_not_complate_payment".localized
        static let appStoreIyzicoLink = "itms-apps://itunes.apple.com/app/id1436467445"
        static let topUpWaitingTitle = "iyzico_success_top_up_waiting_title".localized
        static let cashoutWaitingTitle = "iyzico_success_cashout_waiting_title".localized
    }
    
    //MARK: - MemberVC
    struct MemberVC {
        static let titleLabel = "iyzico_fragment_login_title".localized
        static let subTitleLabel = "iyzico_fragment_login_second_title".localized
        static let memberButtonDescription = "iyzico_continue_as".localized
        static let changeAccountButton = "iyzico_fragment_login_change_acount".localized
        static let settlementTitle = "iyzico_fragment_login_settlement_title".localized
        static let refundTitle = "iyzico_fragment_login_refund_title".localized
    }
    
    struct BottomAlertVC {
        static let titleLabel = "iyzico_get_support_title".localized
        static let supportPhoneNumber = "iyzico_phone_number_text".localized
        static let supportMail = "iyzico_mail".localized
    }
    
    //MARK: - InternalMessage
    let successText = "Operation successful."
    let errorText = "Operation failed with unknown error."
    let timeOutText = "Operation timeout."
    let phoneErrorText = "Phone number is required."
    let emailErrorText = "Email adress is required."
    let brandErrorText = "Invalid brand."
    let priceErrorText = "Invalid price."
    let idErrorText = "Invalid product id."
    let walletPriceErrorText = "Invalid wallet price."
    let apikeyErrorText = "Invalid api key."
    let clientIdErrorText = "Invalid client id."
    let clientSecretKeyErrorText = "Invalid client secret key."
    let merchantSecretKeyErrorText = "Invalid merchant secret key."
    let merchantApiKeyErrorText = "Invalid merchant api key."
    let baseUrlError = "Invalid baseUrl."
    let paidPriceErrorText = "Geçersiz ödenecek fiyat bilgisi"
    let callbackErrorText = "Geçersiz urlCallback"
    let enabledInstallementErrorText = "Geçersiz taksit seçenekleri"
    let basketIdErrorText = "Geçersiz Sepet id'si"
    let buyerIDError = "Geçersiz kullanıcı id'si"
    let buyerNameError = "Geçersiz kullanıcı adı"
    let buyerSurnameError = "Geçersiz kullanıcı soyadı"
    let buyerIdentityNumberError = "Geçersiz kullanıcı TC Numarası"
    let buyerCityError = "Geçersiz kullanıcı şehri"
    let buyerCountryError = "Geçersiz kullanıcı ülkesi"
    let buyerEmailError = "Geçersiz kullanıcı mail adresi"
    let buyerPhoneError = "Geçersiz kullanıcı telefon Numarası"
    let buyerIPError = "Geçersiz kullanıcı  Ip bilgisi"
    let buyerRegistrationAddressError = "Geçersiz teslimat adresi"
    let buyerZipCodeError = "Geçersiz posta kodu"
    let buyerRegistrationDateError = "Geçersiz kayıt tarihi"
    let buyerLastLoginDateError = "Geçersiz son giriş tarihi"
    let billingContactNameError = "Geçersiz fatura iletişim ismi"
    let billingCityError = "Geçersiz fature şehir bilgisi"
    let shippingCountryError = "Geçersiz nakliye ülke bilgisi"
    let shippingAddressError = "Geçersiz nakliye adres bilgisi"
    let emptyBasketError = "Sepet Boş bırakılamaz"
    let fullBasketError = "Ürün sayısı 500'ü geçemez"
    let basketProductIdError = "Geçersiz sepet ürün id'si"
    let basketProductNameError = "Geçersiz sepet ürün adı"
    let basketProductCategoryError = "Geçersiz sepet ürün kategorisi"
    let billingAdressError = "Geçersiz kullanıcı ülkesi"
    let shippingContactNameError = "Geçersiz nakliye iletişim adı"
    let shippingCityError = "Geçersiz nakliye şehir bilgisi"
    let billingCountryError = "Geçersiz fature ülke bilgisi"
    let languageError = "Geçersiz dil"
    let closedTransactionError = ""
    let basketProductPriceError = "Geçersiz Sepet ürün fiyatı"
    let basketProductItemTypeError = "Geçersiz Sepet ürün tür'ü bilgisi"

    
    //MARK: - Formats
    struct Formats {
        static let doubleTwoDigitAfterComma = "%.2f"
        static let tLText = "TL"
        static let tlAscii = "₺"
        static let securePasswordAscii = "•"
    }
    
    //MARK: - Iyzico
    struct IyzicoLog {
        static let iyzicoStarted = "IyzicoSDK started. v\(GlobalMethodsManager.getSdkVersion())"
        static let iyzicoClosed = ""
        static let iyzicoDateFormat = "dd-MM-yyyy HH:mm:ss"
    }
    
}

// MARK: - Register Fonts
extension StringConstant {
    
    open func registerFonts() {
        UIFont.registerFont(withFilenameString: markPro)
        UIFont.registerFont(withFilenameString: markProItalic)
        UIFont.registerFont(withFilenameString: markProLightItalic)
        UIFont.registerFont(withFilenameString: markProLight)
        UIFont.registerFont(withFilenameString: markProMedium)
        UIFont.registerFont(withFilenameString: markProBold)
    }
}
