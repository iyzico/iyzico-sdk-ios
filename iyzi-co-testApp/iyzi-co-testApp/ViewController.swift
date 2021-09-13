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
                                 language: .tr)
        Iyzico.shared.startTopUp(email: "iyzicotest10000@email.com", //msahincakir34+02042021@gmail.com
                                 phone: "+90 555 555 55 55",
                                 brand: "Lidyana.com",
                                 name: "tolga",
                                 surname: "iskender")
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
                                 language: .tr)
        Iyzico.shared.startSettlement(email: "iyzicotest100001@gmail.com",
                                      phone: "+90 555 555 55 55",
                                      walletPrice: 21.00,
                                      name: "tolga",
                                      surname: "iskender")
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
                                 language: .tr)
        Iyzico.shared.startRefund(email: "iyzicotest100002@gmail.com",
                                  phone: "+90 555 555 55 55",
                                  productId: "123456",
                                  name: "tolga",
                                  surname: "iskender")
//        Iyzico.shared.startRefund(email: "msahincakir34+23032021@gmail.com",
//                                  phone: "+90 555 555 55 55",
//                                  productId: "123456",
//                                  name: "Vural",
//                                  surname: "Celik")
    }
    
    @IBAction func cashoutFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(clientIp: "127.0.0.1",
                                 clientId: "qumpara",
                                 clientSecret: "qumparaSecret",
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
                                 language: .tr)
        Iyzico.shared.startCashOut(email: "iyzicotest100003@email.com", //newuser1234@gmail.com
                                   phone: "+90 555 555 55 55",
                                   walletPrice: 800.00,
                                   name: "tolga",
                                   surname: "iskender")
//        Iyzico.shared.startCashOut(email: "msahincakir34+23032021@gmail.com", //newuser1234@gmail.com
//                                   phone: "+90 555 555 55 55",
//                                   walletPrice: "21.00",
//                                   name: "Vural",
//                                   surname: "Celik")
    }
    
    //msahincakir34+23032021@gmail.com
    @IBAction func payWithIyzicoFlow(_ sender: Any) {
        #warning("change in prod")
        Iyzico.shared.initialize(clientIp: "127.0.0.1",
                                 clientId: "qumpara",
                                 clientSecret: "qumparaSecret",
                                 baseUrl: "https://sandbox-consumerapigw.iyzipay.com",
                                 merchantApiKey: "sandbox-fEzf4Lbbzw5yGOVjGGl6UF2sM3CZ2nPl",
                                 merchantSecretKey: "sandbox-DR5z07SXKVWyzwOHR6c85tccPb5ogOE9",
                                 language: .tr)
//        Iyzico.shared.startPayWithIyziCo(brand: "Lidyana.com",
//                                         price: 400.00,
//                                         email: "sahin1incakir34+01042021@gmail.com",
//                                         phone: "+90 555 555 55 55",
//                                         productImage: UIImage(),
//                                         addressType: "Ev",
//                                         addressDescription: "Ev adresi aciklamasi",
//                                         name: nil,
//                                         surname: nil)
        Iyzico.shared.startPayWithIyziCo(brand: "Lidyana.com",
                                         price: 50.0,
                                         paidPrice: 51.0,
                                         enabledInstallments: [2,3,6,9],
                                         basketId: "B67832",
                                         paymentGroup: .SUBSCRIPTION,
                                         paymentSource: "MOBILE_SDK",
                                         callbackUrl: "https://www.merchant.com/callback",
                                         buyer: Buyer(id: "BY789",
                                                      name: "John",
                                                      surname: "Doe",
                                                      identityNumber: "74300864791",
                                                      email: "iyzicotest100004@email.com",
                                                      gsmNumber: "+905074018765",
                                                      registrationAddress: "Adres",
                                                      city: "Istanbul",
                                                      country: "Turkey",
                                                      ip: "Ip"),
                                         billingAddress: PWIAddress(address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
                                                                    contactName: "Jane Doe",
                                                                    city: "Istanbul",
                                                                    country: "Turkey"),
                                         shippingAddress: PWIAddress(address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
                                                                     contactName: "Jane Doe",
                                                                     city: "Istanbul",
                                                                     country: "Turkey"),
                                         basketItems: [BasketItem(id: "BI101",
                                                                 price: "50.0",
                                                                 name: "Binocular",
                                                                 category1: "Collectibles",
                                                                 itemType: BasketItemType.PHYSICAL.rawValue)])
        
//        Iyzico.shared.startPayWithIyziCo(brand: "Lidyana.com",
//                                         price: "60.00",
//                                         email: "msahincakir34+23032021@gmail.com",
//                                         phone: "+90 555 555 55 55",
//                                         productImage: UIImage(),
//                                         addressType: "Ev",
//                                         addressDescription: "Ev adresi aciklamasi",
//                                         name: "Vural",
//                                         surname: "Celik")
        
    }
}

extension ViewController: IyzicoDelegate {
    func didOperationSuccess(state: InternalMessageState, message: String) {
        print(state, message)
    }
    
    func didOperationFailed(state: InternalMessageState, message: String) {
        print(state,message)
    }
}
