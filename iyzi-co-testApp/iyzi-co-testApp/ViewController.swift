//
//  ViewController.swift
//  iyzi-co-testApp
//
//  Created by Tolga İskender on 7.12.2020.
//

import UIKit
import iyzicoSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Iyzico.delegate = self
        #warning("change in prod")
       
    }

    //askdfjkfd90s0sd9@gmail.com gsm verified false at member vc
    @IBAction func topUpFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(clientIp: "127.0.0.1",
                                 clientId: "qumpara",
                                 clientSecret: "qumparaSecret",
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
                                 language: .TURKISH)
        Iyzico.shared.startTopUp(buyerEmail: "iyzicotest10000@email.com", //msahincakir34+02042021@gmail.com
                                 buyerPhone: "+90 555 555 55 55",
                                 buyerName: "nil",
                                 buyerSurname: "nil")
        //        Iyzico.shared.startTopUp(email: "msahincakir34+23032021@gmail.com",
        //                                 phone: "+90 531 860 52 05",
        //                                 brand: "Lidyana.com",
        //                                 name: "Vural",
        //                                 surname: "Celik")
    }
    
    @IBAction func settlementFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(clientIp: "127.0.0.1",
                                 clientId: "qumpara",
                                 clientSecret: "qumparaSecret",
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
                                 language: .TURKISH)
        Iyzico.shared.startSettlement(buyerEmail: "iyzicotest100001@gmail.com",
                                      buyerPhone: "+90 555 555 55 55",
                                      walletPrice: 21.00,
                                      buyerName: "nil",
                                      buyerSurname: "nil")
        //        Iyzico.shared.startSettlement(email: "msahincakir34+23032021@gmail.com",
        //                                      phone: "+90 555 555 55 55",
        //                                      walletPrice: "21.00",
        //                                      name: "Vural",
        //                                      surname: "Celik")
    }
    
    @IBAction func refundFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(clientIp: "127.0.0.1",
                                 clientId: "qumpara",
                                 clientSecret: "qumparaSecret",
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
                                 language: .TURKISH)
        Iyzico.shared.startRefund(buyerEmail: "iyzicotest100002@gmail.com",
                                  buyerPhone: "+90 555 555 55 55",
                                  productId: "123456",
                                  buyerName: "nil",
                                  buyerSurname: "nil")
        //        Iyzico.shared.startRefund(email: "msahincakir34+23032021@gmail.com",
        //                                  phone: "+90 555 555 55 55",
        //                                  productId: "123456",
        //                                  name: "Vural",
        //                                  surname: "Celik")
    }
    
    @IBAction func cashoutFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(
            clientIp: "127.0.0.1",
            clientId: "qumpara",
            clientSecret: "qumparaSecret",
            baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
            language: .TURKISH)
        Iyzico.shared.startCashOut(
            buyerEmail: "iyzicotest100003@email.com", //newuser1234@gmail.com
            buyerPhone: "+90 555 555 55 55",
            walletPrice: 800.00,
            buyerName: "nil",
            buyerSurname: "nil"
        )
    }
    
    //msahincakir34+23032021@gmail.com
    @IBAction func payWithIyzicoFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(
            clientIp: "127.0.0.1",
            clientId: "qumpara",
            clientSecret: "qumparaSecret",
            baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
            merchantApiKey: "sandbox-fEzf4Lbbzw5yGOVjGGl6UF2sM3CZ2nPl",
            merchantSecretKey: "sandbox-DR5z07SXKVWyzwOHR6c85tccPb5ogOE9",
            language: .TURKISH)
   
        Iyzico.shared.startPayWithIyziCo(
            brand: "Lidyana.com",
            price: 50.0,
            paidPrice: 51.0,
            currency: Currency.TRY,
            enabledInstallments: [1],
            basketId: "B67832",
            paymentGroup: nil,
            paymentSource: "MOBILE_SDK",
            urlCallback: "https://www.merchant.com/callback",
            buyerId: "BY789",
            buyerName: "JOHN",
            buyerSurname: "Doe",
            buyerIdentityNumber: "74300864791",
            buyerCity: "Istanbul",
            buyerCountry: "Turkey",
            buyerEmail: "iyzicotest100004@email.com",
            buyerPhone: "+905074018765",
            buyerIp: "Ip",
            buyerRegistrationAddress: "Adres",
            //buyerZipCode: "zip kodu",
            buyerRegistrationDate: "registration date",
            buyerLastLoginDate: "last log in date",
            billingContactName: "Jane Doe",
            billingCity: "Istanbul",
            billingCountry: "Turkey",
            billingAddress: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            shippingContactName: "Jane Doe",
            shippingCity: "Istanbul",
            shippingCountry: "Turkey",
            shippingAddress: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            //itemType: BasketItemType.PHYSICAL.rawValue,
            //itemName: "Binocular",
            //itemCategory: "Collectibles",
            //productId: "",
            //addressDescription: "Ev",
            basketItemList: [IyzicoBasketItem(
                itemCategory: "Collectibles",
                productId: "BI101",
                itemType: BasketItemType.PHYSICAL.rawValue,
                itemName: "Binocular",
                price: "50.0"
            )]
        )
        
    }
}

extension ViewController: IyzicoDelegate {
    func didOperationSuccess(message: String) {
        print(message)
    }
    
    func didOperationFailed(state: ResultCode, message: String) {
        print(state,message)
    }
}
