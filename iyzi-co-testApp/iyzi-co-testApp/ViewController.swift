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
                                 clientId: "qumpara", //tyHJXKUb7uxeksaejjLjTgC8ZQYuQ9
                                 clientSecret: "qumparaSecret", //zb5KTrDatdP9ebSeHmQ5SG4SGJw3eR
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com", //https://consumerapigw.iyzipay.com
                                 language: .TURKISH)
        Iyzico.shared.startTopUp(buyerEmail: "msahincakir34+22092021@gmail.com", //msahincakir34+02042021@gmail.com
                                 buyerPhone: "+90 555 555 55 55",
                                 buyerName: "nil",
                                 buyerSurname: "nil")
        //        Iyzico.shared.startTopUp(email: "msahincakir34+23032021@gmail.com",
        //                                 phone: "+90 531 860 52 05",
        //                                 brand: "Lidyana.com",
        //                                 name: "Vural",
        //                                 surname: "Celik")
    }
    
    //@IBAction func settlementFlow(_ sender: Any) {
    //    #warning("change in prod")
    //    Iyzico.shared.initialize(clientIp: "127.0.0.1",
    //                             clientId: "qumpara",
    //                             clientSecret: "qumparaSecret",
    //                             baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
    //                             language: .TURKISH)
    //    Iyzico.shared.startSettlement(buyerEmail: "iyzicotest100001@gmail.com",
    //                                  buyerPhone: "+90 555 555 55 55",
    //                                  walletPrice: 21.00,
    //                                  buyerName: "nil",
    //                                  buyerSurname: "nil")
    //        Iyzico.shared.startSettlement(email: "msahincakir34+23032021@gmail.com",
    //                                      phone: "+90 555 555 55 55",
    //                                      walletPrice: "21.00",
    //                                      name: "Vural",
    //                                      surname: "Celik")
    // }
    
    //@IBAction func refundFlow(_ sender: Any) {
    //    #warning("change in prod")
    //    Iyzico.shared.initialize(clientIp: "127.0.0.1",
    //                             clientId: "qumpara",
    //                             clientSecret: "qumparaSecret",
    //                             baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
    //                             language: .TURKISH)
    //    Iyzico.shared.startRefund(buyerEmail: "iyzicotest100002@gmail.com",
    //                              buyerPhone: "+90 555 555 55 55",
    //                              productId: "123456",
    //                              buyerName: "nil",
    //                              buyerSurname: "nil")
    //        Iyzico.shared.startRefund(email: "msahincakir34+23032021@gmail.com",
    //                                  phone: "+90 555 555 55 55",
    //                                  productId: "123456",
    //                                  name: "Vural",
    //                                  surname: "Celik")
    // }
    
    @IBAction func cashoutFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(
            clientIp: "127.0.0.1",
            clientId: "qumpara", //tyHJXKUb7uxeksaejjLjTgC8ZQYuQ9
            clientSecret: "qumparaSecret", //zb5KTrDatdP9ebSeHmQ5SG4SGJw3eR
            baseUrl: "https://sandbox-consumerapigw.iyzipay.com", //https://consumerapigw.iyzipay.com
            language: .TURKISH)
        Iyzico.shared.startCashOut(
            buyerEmail: "msahincakir34+22092021@gmail.com", //newuser1234@gmail.com
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
            clientId: "qumpara", //tyHJXKUb7uxeksaejjLjTgC8ZQYuQ9
            clientSecret: "qumparaSecret", //zb5KTrDatdP9ebSeHmQ5SG4SGJw3eR
            baseUrl: "https://sandbox-consumerapigw.iyzipay.com", //https://consumerapigw.iyzipay.com
            merchantApiKey: "sandbox-fEzf4Lbbzw5yGOVjGGl6UF2sM3CZ2nPl", //aaqZZtlaUdEQY1DgK1Guw8Prj16Hv6gg
            merchantSecretKey: "sandbox-DR5z07SXKVWyzwOHR6c85tccPb5ogOE9", //MU2SxEhkC3bTwSsgnUvPcBsKUzNzoW9O
            language: .TURKISH)
        
        Iyzico.shared.startPayWithIyzico(
            brand: "Lidyana.com",
            price: 1.0,
            paidPrice: 1.0,
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
            buyerEmail: "msahincakir34+22092021@gmail.com", //iyzicotest100004@email.com
            buyerPhone: "+90 555 555 55 55",
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
                price: "1.0"
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
