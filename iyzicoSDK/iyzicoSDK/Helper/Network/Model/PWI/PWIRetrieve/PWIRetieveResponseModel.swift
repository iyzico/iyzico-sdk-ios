import Foundation


// MARK: - PWIRetieveResponseModel
struct PWIRetieveResponseModel: Codable {
    let memberToken: String?
    let memberID: Int?
    var checkoutDetail: CheckoutDetail?
    let memberCards: [CardResponseModel]?
    let memberBalance: MemberBalance?
    
    enum CodingKeys: String, CodingKey {
        case memberToken
        case memberID = "memberId"
        case checkoutDetail, memberCards, memberBalance
    }
}

// MARK: - CheckoutDetail
struct CheckoutDetail: Codable {
    let bkmEnabled, bankTransferEnabled, subscriptionPaymentEnabled: Bool?
    let locale: String?
    let price: Double?
    let currency: String?
    let merchantGatewayBaseURL: String?
    let storeNewCardEnabled, payWithIyzicoUsed: Bool?
    var gsmNumber, email: String?
    let metadata: Metadata?
    let buyerSurname: String?
    let force3Ds, creditCardEnabled, hide3DS, fundEnabled: Bool?
    let bankTransferRedirectURL: String?
    let ucsEnabled: Bool?
    let buyerName, merchantInfo, token: String?
    let enabledApmTypes: [String]?
    let paymentWithNewCardEnabled: Bool?
    let baseURL: String?
    let registerCardEnabled, buyerProtectionEnabled, payWithIyzicoEnabled: Bool?
    let bankTransferAccounts: [ProtectedBankAccountsResponseModel]?
    
    enum CodingKeys: String, CodingKey {
        case bkmEnabled, bankTransferEnabled, subscriptionPaymentEnabled, locale, price, currency
        case merchantGatewayBaseURL = "merchantGatewayBaseUrl"
        case storeNewCardEnabled, payWithIyzicoUsed, gsmNumber, email, metadata, buyerSurname, force3Ds, creditCardEnabled, hide3DS, fundEnabled
        case bankTransferRedirectURL = "bankTransferRedirectUrl"
        case ucsEnabled, buyerName, merchantInfo, token, enabledApmTypes, paymentWithNewCardEnabled
        case baseURL = "baseUrl"
        case registerCardEnabled, buyerProtectionEnabled, payWithIyzicoEnabled, bankTransferAccounts
    }
}

// MARK: - BankTransferAccount
//struct BankTransferAccount: Codable {
//    let iban, legalCompanyTitle, currency, bank: String?
//    let bankID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case iban, legalCompanyTitle, currency, bank
//        case bankID = "bankId"
//    }
//}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - MemberBalance
struct MemberBalance: Codable {
    let currencyCode, amount, provisionAmount: String?
}

//// MARK: - MemberCard
//struct MemberCard: Codable {
//    let binNumber, lastFourDigits, cardBankName: String?
//    let cardType: CardNameTypes?
//    let cardAssociation: String?
//    let cardAssociationLogoURL: String?
//    let cardToken: String?
//
//    enum CodingKeys: String, CodingKey {
//        case binNumber, lastFourDigits, cardBankName, cardType, cardAssociation
//        case cardAssociationLogoURL = "cardAssociationLogoUrl"
//        case cardToken
//    }
//}
