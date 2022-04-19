//
//  IyzicoHomeVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 24.03.2021.
//

import UIKit

class IyzicoHomeVM: BaseVM {
    //MARK: - Responses
    var depositWithRegisteredCardResponse: DepositWithRegisteredCardResponseModel?
    var depositWithNewCardResponse: DepositWithNewCardResponseModel?
    var protectedBankAccountsResponse: ProtectedBankAccountsOuterResponseModel?
    var navigatedInitializeResponse: InitResponseModel?
    var navigatedPhoneNumber: String?
    var isFirst: Bool = true
    var pwiRetrieveResponse: PWIRetieveResponseModel? {
        didSet {
            if !isFirst {
                sortCards()
            }
            isFirst = false
        }
    }
    var installmentDetailResponse: InstallmentResponseModel?
    var payWithBalanceResponse: PayWithBalanceResponseModel?
    var mixedPaymentWithSavedCardResponse: MixedPaymentWithSavedCardResponseModel?
    var paymentBankTransferResponse: PaymentBankTransferResponseModel?
    var plusInstallmentBankList: [PlusInstallmentResponseModel]?
    var memberCards: [CardResponseModel]?
    var isBonusEnabled: Bool = false
    var numberOfIyzicoCards: Int = 0
    var isIyzicoDisabled: Bool = false
    var addCardSelected: Bool = false
    var bonusUsageAmount: Double = 0.0
    var newCardSelected: Bool = true
    var count: Int = 0
    var selectedCell: UITableViewCell? = nil
    var isAddCardBonusAvailable: Bool = false
    var isCreditCardListCellOpened: Bool = false
    
    //MARK: - Regular Properties
    var paymentType: IyzicoHomePaymentTypes = .myAccount {
        didSet {
#if DEBUG
            debugPrint("Payment Type Changed To \(paymentType)")
#endif
        }
    }
    var newCardInputsArray: [IyzicoTextInputModel]?
    
    //MARK: - MyAccount Properties
    
    //MARK: - Credit Cards Properties
    var selectedCells = [true]
    var getCardsResponse: CardItemsResponseModel? {
        didSet {
            setInitialSelectedCellsForFlow()
        }
    }
    var getBonusResponse: CardBonusResponseModel?
    
    var selectedCardForPayment: CardResponseModel?
    
    var installmentCount: Int? = 1
    var installmentPrice: Double? = SDKManager.price {
        didSet {
            SDKManager.price = installmentPrice
            NotificationCenter.default.post(name: .updatePrice, object: nil)
        }
    }
    
    //MARK: - Add New Card Properties
    var priceCheckBoxSelectedStatus = false
    var isUserDisabledPriceCheckbox = true
    var selectedCardType: CardNameTypes?
    
    //MARK: - EFT Properties
    
    //MARK: - Installment Properties
    var showInfoView: Bool = false
    var useBalance: Bool = false
    //MARK: - Navigated Properties
    var priceForLoad: String? //For Top Up Flow
    var navigatedInitResponse: InitResponseModel?
    
    override init() {
        super.init()
        setInitialSelectedCellsForFlow()
    }
    
    //MARK: - Requests
    func getCards(onSuccess: @escaping (CardItemsResponseModel?) -> Void,
                  onFailure: @escaping (String?,String?) -> Void) {
        Networking.request(router: CardRouter.cards)
        { [weak self] (response: BaseResponse<CardItemsResponseModel>?) in
            self?.getCardsResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, errorCode, _) in
            onFailure(error, errorCode)
        }
    }
    
    func getBonus(onSuccess: @escaping (CardBonusResponseModel?) -> Void,
                  onFailure: @escaping (String?,String?) -> Void) {
        let requestModel = CardBonusRequestModel(conversationId: self.mixedPaymentWithSavedCardResponse?.conversationID ?? "",
                                                 currency: "TRY",
                                                 locale: Language.TURKISH.rawValue,
                                                 paidPrice: installmentPrice,
                                                 paymentCard: PaymentCard(cardToken: selectedCardForPayment?.cardToken ?? ""),
                                                 paymentChannel: "THIRD_PARTY_APP")
        Networking.request(router: CardRouter.cardBonus(requestModel: requestModel), shouldShowLoading: false)
        { [weak self] (response: CardBonusResponseModel) in
            self?.getBonusResponse = response
            onSuccess(response)
        } failure: { (error, errorCode, _) in
            onFailure(error, errorCode)
        }
    }
    
    func getNewCardBonus(onSuccess: @escaping (CardBonusResponseModel?) -> Void,
                         onFailure: @escaping (String?,String?) -> Void) {
        let requestModel = NewCardBonusRequestModel(conversationId: self.mixedPaymentWithSavedCardResponse?.conversationID ?? "",
                                                    currency: "TRY",
                                                    locale: Language.TURKISH.rawValue,
                                                    paidPrice: installmentPrice,
                                                    paymentCard: PaymentCard(cardNumber: getCardNumber(),
                                                                             cardHolderName: getCardHolderName(),
                                                                             expireYear: getExpireYear(),
                                                                             expireMonth: getExpireMonth(),
                                                                             cvc: getCvcCode()),
                                                    paymentChannel: "THIRD_PARTY_APP")
        Networking.request(router: CardRouter.newCardBonus(requestModel: requestModel), shouldShowLoading: false)
        { [weak self] (response: CardBonusResponseModel) in
            self?.getBonusResponse = response
            onSuccess(response)
        } failure: { (error, errorCode, _) in
            onFailure(error, errorCode)
        }
    }
    
    func getDepositWithRegisteredCard(onSuccess: @escaping (DepositWithRegisteredCardResponseModel?) -> Void,
                                      onFailure: @escaping (String?, NetworkStatusTypes) -> Void) {
        let requestModel = DepositWithRegisteredCardRequestModel(initialRequestId: navigatedInitResponse?.initialRequestId,
                                                                 cardToken: selectedCardForPayment?.cardToken,
                                                                 amount: priceForLoad?.serviceAmountFormatAsString,
                                                                 currencyCode: "TRY",
                                                                 clientIp: SDKManager.clientIp,
                                                                 channelType: "THIRD_PARTY_APP")
        Networking.request(router: DepositsRouter.withRegisteredCard(requestModel: requestModel))
        { [weak self] (response: BaseResponse<DepositWithRegisteredCardResponseModel>?) in
            self?.depositWithRegisteredCardResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _, networkStatusType) in
            onFailure(error, networkStatusType)
        }
    }
    
    func getDepositWithNewCard(onSuccess: @escaping (DepositWithNewCardResponseModel?) -> Void,
                               onFailure: @escaping (String?, NetworkStatusTypes) -> Void) {
        let requestModel = DepositWithNewCardRequestModel(amount: priceForLoad?.serviceAmountFormatAsString,
                                                          initialRequestId: navigatedInitResponse?.initialRequestId,
                                                          currencyCode: "TRY",
                                                          clientIp: SDKManager.clientIp,
                                                          cardHolderName: getCardHolderName(),
                                                          cardNumber: getCardNumber(),
                                                          expireYear: getExpireYear(),
                                                          expireMonth: getExpireMonth(),
                                                          cvc: getCvcCode(),
                                                          channelType: "THIRD_PARTY_APP")
        Networking.request(router: DepositsRouter.withNewCard(requestModel: requestModel))
        { [weak self] (response: BaseResponse<DepositWithNewCardResponseModel>?) in
            self?.depositWithNewCardResponse = response?.data
            onSuccess(response?.data)
        } failure: { (error, _, networkStatusType) in
            onFailure(error, networkStatusType)
        }
    }
    
    func getProtectedBankAccounts(onSuccess: @escaping (ProtectedBankAccountsOuterResponseModel?) -> Void,
                                  onFailure: @escaping (String?) -> Void) {
        Networking.request(router: DepositsRouter.protectedBankAccounts,
                           shouldShowLoading: false,
                           success: { [weak self] (response: BaseResponse<ProtectedBankAccountsOuterResponseModel>) in
            self?.protectedBankAccountsResponse = response.data
            onSuccess(self?.protectedBankAccountsResponse)
        },
                           failure: { (error, _, networkStatusType) in
            onFailure(error)
        })
    }
    
    func getRetrievePWI(onSuccess: @escaping (PWIRetieveResponseModel?) -> Void,
                        onFailure: @escaping (String?) -> Void) {
        
        let requestModel = PWIRetrieveRequestModel(checkoutToken: navigatedInitializeResponse?.checkoutToken, locale: Language.TURKISH.rawValue)
        
        Networking.request(router: PWIRouter.retrievePWI(requestModel: requestModel))
        { [weak self] (response: BaseResponse<PWIRetieveResponseModel>?) in
            self?.pwiRetrieveResponse = response?.data
            self?.pwiRetrieveResponse?.checkoutDetail?.gsmNumber = self?.navigatedPhoneNumber ?? response?.data?.checkoutDetail?.gsmNumber
            onSuccess(response?.data)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
    
    func getInstallment(price: String?, binNumber: String?,
                        shouldShowLoading: Bool = true,
                        onSuccess: @escaping (InstallmentResponseModel?) -> Void,
                        onFailure: @escaping (String?) -> Void) {
        
        let requestModel = InstallmentRequestModel(locale: Language.TURKISH.rawValue, price: price, binNumber: binNumber)
        Networking.request(router: PWIRouter.retrieveInstallments(requestModel: requestModel),shouldShowLoading: shouldShowLoading)
        { [weak self] (response: InstallmentResponseModel) in
            
            self?.installmentDetailResponse = response
            onSuccess(response)
        } failure: { (error, _,  _) in
            onFailure(error)
        }
    }
    
    
//    {"conversationId":"","currency":"TRY","locale":"tr","paidPrice":50.19,"paymentCard":{"cardToken":"Q3SLzBl++tLZ9e7OfLkQK9Uq3DY="},"paymentChannel":"THIRD_PARTY_APP"}

//    func getPoint() {
//        let requestModel =
//
//    }
    
    //MARK: - Helper Methods
    private func setInitialSelectedCellsForFlow(){
        //First selected cells status can change by flow type.
        if let validatedItems = getCards() {
            selectedCells = validatedItems.map({ card -> Bool in
                return false
            })
        }
        switch SDKManager.flow {
        case .payWithIyzico:
            selectedCells.insert(true, at: 0) //For my account cell selected status
        case .topUp:
            if selectedCells.count != 0 {
                selectedCells[0] = true //For first credit card selected status
                selectedCardForPayment = getCardsResponse?.items?[0]
            }
        default:
            break
        }
        
        //For new card cell selected status
        selectedCells.append(false)
        sortPlusInstallmentCampaignList()
    }
    
    private func sortPlusInstallmentCampaignList() {
        let campaignList = pwiRetrieveResponse?.checkoutDetail?.plusInstallmentResponseList
        plusInstallmentBankList = campaignList?.sorted(by: { $0.startDate ?? 0 < $1.startDate ?? 0 })
    }
    
    private func sortCards() {
        guard let cardList = pwiRetrieveResponse?.memberCards else {
            return
        }
        var newCardList = cardList
        var iyzicoCardIndex = -1
        var iyzicoVirtualCardIndex = -1
        
        for card in cardList {
            if card.iyzicoCard == true {
                iyzicoCardIndex = cardList.firstIndex(where: { $0 == card }) ?? 0
                numberOfIyzicoCards += 1
            }
            if card.iyzicoVirtualCard == true {
                iyzicoVirtualCardIndex = cardList.firstIndex(where: { $0 == card }) ?? 0
                numberOfIyzicoCards += 1
            }
            if iyzicoCardIndex != -1 {
                newCardList.move(from: iyzicoCardIndex, to: 0)
            }
            if iyzicoVirtualCardIndex != -1 {
                newCardList.move(from: iyzicoVirtualCardIndex, to: 1)
            }
        }
//        print(memberCards as Any)
//        print(newCardList)
        memberCards = newCardList
        setInitialSelectedCellsForFlow()
    }
    
    func setSelectedCellsForFlow(indexPath: IndexPath, sectionType: IyzicoMenuSectionType) {
        //Resetting all other cells selected status except for selected cell
        switch SDKManager.flow {
        case .payWithIyzico:
            switch sectionType {
            case .account:
                changeAllElementsInSelectedCells(status: false, exceptForIndexs: [indexPath.row])
                selectedCells[0] = true
            case .creditCardList:
                let exceptForIndex = indexPath.row
                changeAllElementsInSelectedCells(status: false, exceptForIndexs: [exceptForIndex])
                selectedCells[indexPath.row] = true
                selectedCardType = getCard(indexPath)?.cardType // getCardsResponse?.items?[indexPath.row].cardType
            case .addNewCreditCard:
                changeAllElementsInSelectedCells(status: false, exceptForIndexs: [selectedCells.endIndex - 1])
                //                let selectedCellsLast = selectedCells[selectedCells.endIndex - 1]
                selectedCells[selectedCells.endIndex - 1] = true
            default:
                break
            }
        case .topUp:
            switch sectionType {
            case .creditCardList:
                let exceptForIndex = indexPath.row
                changeAllElementsInSelectedCells(status: false, exceptForIndexs: [exceptForIndex])
                selectedCells[indexPath.row] = true
            case .addNewCreditCard:
                changeAllElementsInSelectedCells(status: false, exceptForIndexs: [selectedCells.endIndex - 1])
                //                let selectedCellsLast = selectedCells[selectedCells.endIndex - 1]
                selectedCells[selectedCells.endIndex - 1] = true
            default:
                break
            }
        default:
            break
        }
    }
    
    func changeAllElementsInSelectedCells(status: Bool, exceptForIndexs: [Int]) {
        for (index, _) in selectedCells.enumerated() {
            exceptForIndexs.forEach { exceptForIndex in
                if index != exceptForIndex {
                    selectedCells[index] = status
                }
            }
        }
    }
    
    func checkForSelectedCells(inputsArray: [Bool]? = nil) -> Bool {
        if selectedCells[selectedCells.endIndex - 1] { //New card cell selected
            guard let validatedInputsArray = inputsArray else { return true }
            return !validatedInputsArray.contains(false)
        }
        else {
            return selectedCells.contains(true)
        }
    }
    
    func setSelectedCard(cell: UITableViewCell?) {
        if let creditCardCell = cell as? CreditCardCell {
            selectedCardForPayment = creditCardCell.cardModel
        }
    }
    
    func getUseBalanceVisibility(basketPrice: String?, myAccountBalance: String?) -> Bool {
        if SDKManager.flow == .topUp {
            return false
        }
        else {
            let basketPriceAsDouble = basketPrice?.asDouble ?? 0.00
            let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
            return (myAccountBalanceAsDouble > 0.00) && (basketPriceAsDouble > myAccountBalanceAsDouble)
        }
    }
    
    func canUserPaymentWithAccountBalance(myAccountBalance: String?) -> Bool {
        let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
        return myAccountBalanceAsDouble > 0
    }
    
    //    func canUserPaymentWithAccountBalance(with paymentType: IyzicoHomePaymentTypes) -> Bool {
    //        switch paymentType {
    //        case .creditCard(let creditCardPaymentType):
    //            switch creditCardPaymentType {
    //            case .withCreditCard(let selectionType):
    //                return selectionType != .mixed
    //            case .withNewCard(let selectionType):
    //                return selectionType != .mixed
    //            }
    //        default:
    //            return true
    //        }
    //    }
    
    //Mixed payment means user will user his my account balance + credit card balance
    func isMixedPayment(basketPrice: String?, myAccountBalance: String?) -> Bool {
        let basketPriceAsDouble = basketPrice?.asDouble ?? 0.00
        let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
        if (myAccountBalanceAsDouble < basketPriceAsDouble) && myAccountBalanceAsDouble > 0 {
            return true
        }
        return false
    }
    
    func isBalanceEligibletoPay(basketPrice: String?, myAccountBalance: String?) -> Bool {
        let basketPriceAsDouble = basketPrice?.asDouble ?? 0.00
        let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
        return myAccountBalanceAsDouble >= basketPriceAsDouble
    }
    
    func checkPayWithBalanceOrMixPayment(basketPrice: String?, myAccountBalance: String?) -> Bool {
        let basketPriceAsDouble = basketPrice?.asDouble ?? 0.00
        let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
        if myAccountBalanceAsDouble < basketPriceAsDouble {
            return true
        } else if  myAccountBalanceAsDouble >= basketPriceAsDouble {
            return true
        }
        return false
    }
    
    
    func getWillBeSpendFromCardAmount(basketPrice: String?, myAccountBalance: String?) -> String? {
        let basketPriceAsDouble = basketPrice?.asDouble ?? 0.00
        let myAccountBalanceAsDouble = myAccountBalance?.asDouble ?? 0.00
        if basketPriceAsDouble > myAccountBalanceAsDouble {
            return (basketPriceAsDouble - myAccountBalanceAsDouble).roundedTwoDigit.description
        }
        else {
            return (0.00).roundedTwoDigit.description
        }
    }
    
    func getCardHolderName() -> String? {
        return newCardInputsArray?.first?.input?.textField.text
    }
    
    func getCardNumber() -> String? {
        return newCardInputsArray?[1].input?.textField.text?.replacingOccurrences(of: " ", with: "")
    }
    
    func getExpireMonth() -> String? {
        return newCardInputsArray?[2].input?.textField.text?.prefix(2).description
    }
    
    func getExpireYear() -> String? {
        return newCardInputsArray?[2].input?.textField.text?.suffix(2).description
    }
    
    func getCvcCode() -> String? {
        return newCardInputsArray?[3].input?.textField.text
    }
}
//MARK:- HELPER FUNCS
extension IyzicoHomeVM {
    
    func getCardsCount() -> Int? {
        let count = SDKManager.flow == .payWithIyzico ? memberCards?.count : getCardsResponse?.items?.count
        return count
    }
    
    func getCard(_ indexPath: IndexPath) -> CardResponseModel? {
        let card = SDKManager.flow == .payWithIyzico ? memberCards?[indexPath.row] : getCardsResponse?.items?[indexPath.row]
        return card
    }
    
    func getCards() -> [CardResponseModel]? {
        let cards = SDKManager.flow == .payWithIyzico ? memberCards : getCardsResponse?.items
        
        return cards
    }
    
    func getBonus() -> CardBonusResponseModel? {
        return getBonusResponse
    }
    
    func getBanks() -> [ProtectedBankAccountsResponseModel]? {
        let banks = SDKManager.flow == .payWithIyzico ? pwiRetrieveResponse?.checkoutDetail?.bankTransferAccounts : protectedBankAccountsResponse?.items
        return banks
    }
    
    func getReferenceCode() -> String? {
        let code = SDKManager.flow == .payWithIyzico ? paymentBankTransferResponse?.code : protectedBankAccountsResponse?.referenceCode
        return code
    }
    
    func getBankTransferPaymentID() -> Int? {
        let bankTransferPaymentID = SDKManager.flow == .payWithIyzico ? paymentBankTransferResponse?.bankTransferPaymentID : nil
        return bankTransferPaymentID
    }
    
    func userHasCreditCard() -> Bool {
        let cards = SDKManager.flow == .payWithIyzico ? memberCards?.count ?? .zero > 0 : getCardsResponse?.items?.count ?? .zero > 0
        return cards //getCardsResponse?.items?.count != 0
    }
    
    func setDefaultPrice() {
        SDKManager.price = pwiRetrieveResponse?.checkoutDetail?.price
        NotificationCenter.default.post(name: .updatePrice, object: nil)
    }
}



//MARK: - PAYMENTS
extension IyzicoHomeVM {
    
    func payWithBalance(onSuccess: @escaping (PayWithBalanceResponseModel?) -> Void,
                        onFailure: @escaping (String?) -> Void) {
        
        let requestModel = PayWithBalanceRequestModel(paymentChannel: "THIRD_PARTY")
        Networking.request(router: PWIRouter.payWithBalance(requestModel: requestModel))
        { [weak self] (response: PayWithBalanceResponseModel) in
            
            self?.payWithBalanceResponse = response
            onSuccess(response)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
    
    func payWithMixedPaymentWithSavedCard(onSuccess: @escaping (MixedPaymentWithSavedCardResponseModel?) -> Void,
                                          onFailure: @escaping (String?) -> Void) {
        
        let rewardAmount = bonusUsageAmount
        let rewardUsage = isBonusEnabled ? 1 : 0
        let balanceAmount = pwiRetrieveResponse?.memberBalance?.amount
        let memberToken = pwiRetrieveResponse?.memberToken
        let cardToken = selectedCardForPayment != nil ? selectedCardForPayment?.cardToken : getCard(IndexPath(row: .zero, section: .zero))?.cardToken
        let requestModel = MixedPaymentCardRequestModel(paymentChannel: "THIRD_PARTY", memberBalanceAmount: balanceAmount?.asDouble, memberToken: memberToken, paymentCard: PaymentCard(cardToken: cardToken), reward: Reward(rewardAmount: rewardAmount, rewardUsage: rewardUsage))
        
        Networking.request(router: PWIRouter.mixedPaymentWithSavedCard(requestModel: requestModel))
        { [weak self] (response: MixedPaymentWithSavedCardResponseModel) in
            
            self?.mixedPaymentWithSavedCardResponse = response
            onSuccess(response)
        } failure: { (error, _,  _) in
            onFailure(error)
        }
    }
    
    func payWithMixedPaymentWithNewCard(onSuccess: @escaping (MixedPaymentWithSavedCardResponseModel?) -> Void,
                                        onFailure: @escaping (String?) -> Void) {
        
        let balanceAmount = pwiRetrieveResponse?.memberBalance?.amount
        let cardNumber = newCardInputsArray?[1].input?.textField.text?.removeWhiteSpaces
        let cardHolderName =  newCardInputsArray?[0].input?.textField.text
        let expireMonth =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").first
        let expireYear =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").last
        let cvc = newCardInputsArray?[3].input?.textField.text
        let rewardAmount = bonusUsageAmount
        let rewardUsage = isBonusEnabled ? 1 : 0
        
        let requestModel = MixedPaymentCardRequestModel(paymentChannel: "THIRD_PARTY", memberBalanceAmount: balanceAmount?.asDouble,
                                                        paymentCard: PaymentCard(cardNumber: cardNumber, cardHolderName: cardHolderName, expireYear: expireYear, expireMonth: expireMonth, cvc: cvc, registerConsumerCard: true, registerCard: 0), reward: Reward(rewardAmount: rewardAmount, rewardUsage: rewardUsage))
        
        Networking.request(router: PWIRouter.mixedPaymentWithNewCard(requestModel: requestModel))
        { [weak self] (response: MixedPaymentWithSavedCardResponseModel) in
            
            self?.mixedPaymentWithSavedCardResponse = response
            onSuccess(response)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
    
    func payWithPaymentWithNewCard(isNewCard: Bool,onSuccess: @escaping (MixedPaymentWithSavedCardResponseModel?) -> Void,
                                   onFailure: @escaping (String?) -> Void) {
        
        let price = installmentPrice?.asString
        let memberID = "\(pwiRetrieveResponse?.memberID ?? 0)"
        let memberToken = pwiRetrieveResponse?.memberToken
        let installment = installmentCount
        let gsmNumber = pwiRetrieveResponse?.checkoutDetail?.gsmNumber
        let buyerProtected = true
        let cardNumber = newCardInputsArray?[1].input?.textField.text?.removeWhiteSpaces
        let cardHolderName =  newCardInputsArray?[0].input?.textField.text
        let expireMonth =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").first
        let expireYear =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").last
        let cvc = newCardInputsArray?[3].input?.textField.text
        let rewardAmount = bonusUsageAmount
        let rewardUsage = isBonusEnabled ? 1 : 0
        var cardToken: String?
        if !isNewCard {
            cardToken = selectedCardForPayment != nil ? selectedCardForPayment?.cardToken : getCard(IndexPath(row: .zero, section: .zero))?.cardToken
        }
        
        
        var paymentCard = PaymentCard()
        if isNewCard {
            paymentCard = PaymentCard(cardNumber: cardNumber, cardHolderName: cardHolderName, expireYear: expireYear, expireMonth: expireMonth, cvc: cvc, registerConsumerCard: true, registerCard: 0)
        } else {
            paymentCard = PaymentCard(cardToken: cardToken)
        }
        
        let requestModel = PaymentCardRequestModel(paymentChannel: "THIRD_PARTY", paidPrice: price, memberID: memberID, installment: installment, gsmNumber: gsmNumber, buyerProtected: buyerProtected, memberToken: memberToken,
                                                   paymentCard: paymentCard, reward: Reward(rewardAmount: rewardAmount, rewardUsage: rewardUsage))
        
        Networking.request(router: PWIRouter.paymentWithNewCard(requestModel: requestModel))
        { [weak self] (response: MixedPaymentWithSavedCardResponseModel) in
            self?.mixedPaymentWithSavedCardResponse = response
            onSuccess(response)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
    
    func payWithPaymentWithNewCard3DS(isNewCard: Bool,onSuccess: @escaping (MixedPaymentWithSavedCardResponseModel?) -> Void,
                                      onFailure: @escaping (String?) -> Void) {
        
        let price = installmentPrice?.asString
        let memberID = "\(pwiRetrieveResponse?.memberID ?? 0)"
        let memberToken = pwiRetrieveResponse?.memberToken
        let installment = installmentCount
        let gsmNumber = pwiRetrieveResponse?.checkoutDetail?.gsmNumber
        let buyerProtected = true
        let cardNumber = newCardInputsArray?[1].input?.textField.text?.removeWhiteSpaces
        let cardHolderName =  newCardInputsArray?[0].input?.textField.text
        let expireMonth =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").first
        let expireYear =  newCardInputsArray?[2].input?.textField.text?.seperate(by: "/").last
        let cvc = newCardInputsArray?[3].input?.textField.text
        let rewardAmount = bonusUsageAmount
        let rewardUsage = isBonusEnabled ? 1 : 0
        var cardToken: String?
        if !isNewCard {
            cardToken = selectedCardForPayment != nil ? selectedCardForPayment?.cardToken : getCard(IndexPath(row: .zero, section: .zero))?.cardToken
        }
        
        var paymentCard = PaymentCard()
        if isNewCard {
            paymentCard = PaymentCard(cardNumber: cardNumber, cardHolderName: cardHolderName, expireYear: expireYear, expireMonth: expireMonth, cvc: cvc, registerConsumerCard: true, registerCard: 0)
        } else {
            paymentCard = PaymentCard(cardToken: cardToken)
        }
        
        let requestModel = PaymentCardRequestModel(paymentChannel: "THIRD_PARTY", paidPrice: price, memberID: memberID, installment: installment, gsmNumber: gsmNumber, buyerProtected: buyerProtected, memberToken: memberToken,
                                                   paymentCard: paymentCard, reward: Reward(rewardAmount: rewardAmount, rewardUsage: rewardUsage))
        
        Networking.request(router: PWIRouter.paymentWithNewCard3ds(requestModel: requestModel))
        { [weak self] (response: MixedPaymentWithSavedCardResponseModel) in
            self?.mixedPaymentWithSavedCardResponse = response
            onSuccess(response)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
    
    func payWithBankTransfer(bankID:Int?,
                             onSuccess: @escaping (PaymentBankTransferResponseModel?) -> Void,
                             onFailure: @escaping (String?) -> Void) {
        
        let memberID = pwiRetrieveResponse?.memberID
        let email = pwiRetrieveResponse?.checkoutDetail?.email
        let gsmNumber = pwiRetrieveResponse?.checkoutDetail?.gsmNumber
        let buyerProtected = true
        
        let requestModel = PaymentBankTransferRequestModel(bankID: bankID, memberID: memberID, email: email, gsmNumber: gsmNumber, paymentChannel: "THIRD_PARTY", buyerProtected: buyerProtected, locale: SDKManager.language)
        
        Networking.request(router: PWIRouter.paymentWithBankTransfer(requestModel: requestModel))
        { [weak self] (response: PaymentBankTransferResponseModel) in
            
            self?.paymentBankTransferResponse = response
            onSuccess(response)
        } failure: { (error, _, _) in
            onFailure(error)
        }
    }
}
