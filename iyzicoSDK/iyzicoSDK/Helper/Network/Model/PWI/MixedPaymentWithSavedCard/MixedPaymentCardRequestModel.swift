//
//  MixedPaymentCardRequestModel.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 4.08.2021.
//

import Foundation

struct MixedPaymentCardRequestModel: Codable {
    let paymentChannel: String?
    let memberBalanceAmount: Double?
    let memberToken: String?
    let paymentCard: PaymentCard?
    let reward: Reward?
    
    init(paymentChannel: String?, memberBalanceAmount: Double?, memberToken: String? = nil, paymentCard: PaymentCard?, reward: Reward?) {
        self.paymentChannel = paymentChannel
        self.memberBalanceAmount = memberBalanceAmount
        self.memberToken = memberToken
        self.paymentCard = paymentCard
        self.reward = reward
    }
    
   
}

// MARK: - PaymentCard
struct PaymentCard: Codable {
    let cardToken, consumerToken: String?
    let cardNumber, cardHolderName, expireYear, expireMonth: String?
    let cvc: String?
    let registerConsumerCard: Bool?
    let registerCard: Int?
    
    init(cardToken: String? = nil,cardNumber: String? = nil, cardHolderName: String? = nil, expireYear: String? = nil, expireMonth: String? = nil, cvc: String? = nil, registerConsumerCard: Bool? = nil, registerCard: Int? = nil, consumerToken: String? = nil) {
        self.cardToken = cardToken
        self.cardNumber = cardNumber
        self.cardHolderName = cardHolderName
        self.expireYear = expireYear
        self.expireMonth = expireMonth
        self.cvc = cvc
        self.registerConsumerCard = registerConsumerCard
        self.registerCard = registerCard
        self.consumerToken = consumerToken
    }
}

struct Reward: Codable {
    let rewardAmount: Double?
    let rewardUsage: Int?
    
    init(rewardAmount: Double? = nil, rewardUsage: Int? = nil) {
        self.rewardAmount = rewardAmount
        self.rewardUsage = rewardUsage
    }
}

