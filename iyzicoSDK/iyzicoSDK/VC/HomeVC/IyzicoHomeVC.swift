//
//  IyzicoHomeVC.swift
//  iyzicoSDK
//
//  Created by Kasım Sağır on 21.12.2020.
//

import UIKit

class IyzicoHomeVC: BaseVC, NewCardCellDelegate, MyAccountCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var iyzicoButton: IyzicoButton!
    
    private var menu: [IyzicoMenu] = [
        IyzicoMenu(title: StringConstant.shared.iyzicoHomeVCTitleText,
                   sectionType: .protectedPaymentMethod),
        IyzicoMenu(image: Asset.iconsBasicAccount.name,
                   title: StringConstant.shared.iyzicoMenuTitle1,
                   sectionType: .account),
        IyzicoMenu(image: Asset.iconsBasicCards.name,
                   title: StringConstant.shared.iyzicoMenuTitle2,
                   sectionType: .creditCardList),
        IyzicoMenu(image: Asset.iconsBasicCards.name,
                   title: StringConstant.shared.iyzicoMenuTitle2,
                   sectionType: .addNewCreditCard),
        IyzicoMenu(image: Asset.iconsBasicCards.name,
                   title: StringConstant.shared.iyzicoMenuTitle2,
                   sectionType: .installment),
        IyzicoMenu(image: Asset.iconsBasicEFT.name,
                   title: StringConstant.shared.iyzicoMenuTitle3,
                   sectionType: .eft)
    ]
    
    private var banklist = ["Akbank","Garanti Bankası","Ziraat Bankası", "İş Bankası","Yapı Kredi Bankası"]
    private var headerArray: [IyzicoMenuHeaderView] = []
    private var vcType: HomeVCTypeEnum = .payWithIyzico
    var iyzicoHomeVM = IyzicoHomeVM()
    var mainVM = MainVM()
    private typealias paymentSelection = IyzicoHomePaymentSelectionTypes
    
    convenience init(vcType: HomeVCTypeEnum) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.IyzicoHomeVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
    }
    
    //MARK: - Events
    private func initializeEvents() {
        iyzicoButton.didTappedButton = { [unowned self] in
            self.makePayment()
        }
    }
    
    private func initializeHeaderSectionsEvents(section: Int) {
        headerArray[section].didTappedHeader = { [unowned self] in
            self.extendCell(in: section)
            self.configurePaymentTypeUI(isFirstTime: false, section: section)
            self.checkForIyzicoButtonSelectedStatusByExpand(section: section)
            self.clearNewCardInputs()
        }
    }
    
    func didGetAllInputs(inputModels: [IyzicoTextInputModel]) {
        iyzicoHomeVM.newCardInputsArray = inputModels
    }
    
    func checkCardInstallment(binNumber: String?) {
        if binNumber?.count == 6 {
            getInstallment(binNumber: binNumber, shouldShowLoading: false, reloadTableView: false, reloadSection: true)
        } else if (binNumber?.count ?? .zero) < 6 {
            showInfoView()
            UIView.performWithoutAnimation {
                self.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue], with: .none)
            }
        }
    }
    
    func didTappedRefreshButton(cell: BaseTableViewCell) {
        if let cell = cell as? MyAccountCell {
            let previousAmountValue = cell.balanceLabel.text?.formatToDouble(shouldDropFirst: true) ?? Double(0.0)
            ///TODO - Make it seperate functions.
            //Rotating button image
            cell.animateRefreshButton() { [weak self] in
                self?.mainVM.getBalances(
                onSuccess: { (response: BalancesResponseModel?) in
                    //Calculating amount difference
                    let refreshedAmountValue = response?.amount?.formatToDouble(shouldDropFirst: false) ?? Double(0.0)
                    let balanceDifference = (refreshedAmountValue - previousAmountValue).addTLWithAlignment(alignment: .left)
                    cell.animateBalanceLabel(balanceLabelText: response?.amount?.addTLWithNoDots ?? "",
                                             balanceDifference: balanceDifference)
                }, onFailure: { errorDescription in
                    cell.refreshButton.imageView?.removeRotateAnimation()
                })
            }
        }
    }
    
    func expandAddCard(cell: NewCardCell) {
        //Dont forget to change index path if new sections comes in feature.
        handleCellSelect(indexPath: IndexPath(row: 0, section: IyzicoMenuSectionType.addNewCreditCard.rawValue))
        setPaymentTypeForNewCardOnExpand()
        tableView.scrollToRow(at: IndexPath(row: .zero,
                                            section: IyzicoMenuSectionType.addNewCreditCard.rawValue),
                              at: .top,
                              animated: true)
        showInfoView()
    }
    
//    func didTappedAmountButton(priceCheckBox: IyzicoCheckBox) {
//        priceCheckBox.setSelected()
//        iyzicoHomeVM.priceCheckBoxSelectedStatus = priceCheckBox.isSelected
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        setPaymentTypeForUseBalance(isMixedPayment: iyzicoHomeVM.priceCheckBoxSelectedStatus)
//    }
    
    func showInfoView() {
        iyzicoHomeVM.showInfoView = true
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        initializeTableView()
        setupAmountLabel()
        fillHeaderItems()
        setupPriceLabel()
        customizeForVCType()
        addObservers()
        initializeEvents()
        setupIyzicoButton()
        if SDKManager.flow == .payWithIyzico {
            getPWIRetrieve()
        } else {
            getCards()
        }
    }
    
    private func setNavBar() {
        if vcType == .topUp {
            configureNavBar(timerStackViewVisibility: true,
                            balanceContainerViewVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
        }
        else {
            configureNavBar(navBarBottomViewVisibility: true,
                            timerStackViewVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
        }
    }
    
    private func initializeTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = .init(frame: .zero)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: .zero,
                                                left: CGFloat(Constant.shared.padding),
                                                bottom: .zero,
                                                right: CGFloat(Constant.shared.padding))
        tableView.contentInset = UIEdgeInsets(top: .zero,
                                              left: .zero,
                                              bottom: CGFloat(Constant.shared.padding),
                                              right: .zero)
        
        tableView.registerCell(type: MyAccountCell.self)
        tableView.registerCell(type: CreditCardCell.self)
        tableView.registerCell(type: NewCardCell.self)
        tableView.registerCell(type: BankCell.self)
        tableView.registerCell(type: InfoCell.self)
        tableView.registerCell(type: InstallmentTableCell.self)
    }
    
    private func customizeForVCType() {
        if vcType == .topUp {
            priceView.isHidden = false
        }
    }
    
    private func setupAmountLabel() {
        amountLabel.text = StringConstant.shared.iyzicoHomeVCAmountText
        amountLabel.font = .markProBold16
        amountLabel.textColor = .darkGrey
    }
    
    private func setupPriceLabel() {
        priceLabel.font = .markProBold16
        priceLabel.textColor = .darkGrey
        priceLabel.text = iyzicoHomeVM.priceForLoad
    }
    
    private func setupIyzicoButton() {
        let constant = StringConstant.shared
        let title = SDKManager.flow == .payWithIyzico ? constant.payWithIyzico : constant.iyzicoTransferVCIyzicoButtonTopUpTitle
        iyzicoButton.setUp(buttonType: .primaryLvl1(state: .passive),title: title)
    }
    
    //MARK: - Helper Methods
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(completeOrder),
                                               name: .completeOrder,
                                               object: nil)
    }
    
    @objc func completeOrder(notification: NSNotification) {
        let info = notification.userInfo
        let protectedBankAccount = info?["bankInfo"] as? ProtectedBankAccountsResponseModel
        let vc = ResultVC(vcType: .transferDetailSuccess)
        vc.resultVM.protectedBankAccount = protectedBankAccount
        vc.resultVM.priceForLoad = iyzicoHomeVM.priceForLoad
        vc.resultVM.priceForPayment = SDKManager.price?.addTLWithAlignment(alignment: .left)
        vc.resultVM.navigatedReferenceCode = iyzicoHomeVM.getReferenceCode()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleCellSelect(indexPath: IndexPath) {
        let sectionType = IyzicoMenuSectionType(rawValue: indexPath.section) ?? .account
        iyzicoHomeVM.setSelectedCellsForFlow(indexPath: indexPath, sectionType: sectionType)
        if sectionType != .eft {
            checkForIyzicoButtonSelectedStatus()
        }
        tableView.reloadData()
    }
    
    private func checkForIyzicoButtonSelectedStatus(conditionsArray: [Bool]? = nil) {
        if iyzicoHomeVM.checkForSelectedCells(inputsArray: conditionsArray) {
            iyzicoButton.makeActive()
        }
        else {
            iyzicoButton.makePassive()
        }
    }
    
    private func checkForNewCardInputs() -> Bool {
        iyzicoHomeVM.newCardInputsArray?.forEach({ inputModel in
            inputModel.input?.showErrorByType(requiredMessage: inputModel.requiredMessage ?? "",
                                              notValidMessage: inputModel.notValidMessage ?? "")
        })
        tableView.reloadData()
        let isNewCardInputsValid = !(iyzicoHomeVM.newCardInputsArray?.map{ $0.input?.isInputValid }.contains(false) ?? true)
        return isNewCardInputsValid
    }
    
    private func clearNewCardInputs() {
        iyzicoHomeVM.newCardInputsArray?.forEach({ inputModel in
            inputModel.input?.textField.text = ""
            inputModel.input?.removeErrorUI()
            inputModel.input?.isInputValid = false
            inputModel.input?.addBorder(borderColor: UIColor.gray400.cgColor)
            inputModel.input?.titleLabel.font = .markPro12
        })
    }
    
    private func checkForIyzicoButtonSelectedStatusByExpand(section: Int) {
        let allExtendedCondition = menu.map({ $0.isExtended }).contains(true)
        let eftExtendedCondition = section != 4 //4 is EFT section number
        if allExtendedCondition && eftExtendedCondition {
            iyzicoButton.makeActive()
        }
        else {
            iyzicoButton.makePassive()
        }
    }
    
    private func setIyzicoButtonSelectedStatus(isSelected: Bool) {
        if isSelected {
            iyzicoButton.makeActive()
        }
        else {
            iyzicoButton.makePassive()
        }
    }
    
    private func extendCell(in section: Int) {
        menu[section].isExtended.toggle()
       
        deleteInsertCell(in: section)
        
        for i in .zero..<menu.count {
            if menu[i].isExtended && (i != section && i != IyzicoMenuSectionType.addNewCreditCard.rawValue) && i != IyzicoMenuSectionType.installment.rawValue {
                menu[i].isExtended.toggle()
                deleteInsertCell(in: i)
            }
        }
        
        for i in .zero..<headerArray.count {
            if i != section {
                headerArray[i].setExtended(false)
            }
        }
    }
    
    private func deleteInsertCell(in section: Int) {
        var indexPaths = [IndexPath]()
        
        switch menu[section].sectionType {
            case .account:
                indexPaths = [IndexPath(row: .zero, section: section)]
                break
            case .creditCardList:
                let validatedCardsModel = iyzicoHomeVM.getCards() ?? []
                for row in validatedCardsModel.indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                
                if SDKManager.flow == .payWithIyzico {
                    getFirstInstallment()
                }
              
                break
            case .eft:
//                var count = self.banklist.count
                var count = iyzicoHomeVM.getBanks()?.count ?? 0
                if vcType == .topUp {
                    count += 1
                }
                for row in .zero..<count {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPaths.append(indexPath)
                }
                break
            default:
                break
        }
        
        if !menu[section].isExtended {
            if menu[section].sectionType == .account && vcType == .topUp { return }// if vcType is topUp and section is account we dont open it
            
            self.tableView.deleteRows(at: indexPaths, with: .fade)
            if menu[section].sectionType == .creditCardList {
                menu[IyzicoMenuSectionType.addNewCreditCard.rawValue].isExtended = false
              
                if SDKManager.flow == .payWithIyzico {
                    iyzicoHomeVM.setDefaultPrice()
                }
                self.tableView.deleteRows(at: [IndexPath(row: .zero,
                                                         section: IyzicoMenuSectionType.addNewCreditCard.rawValue)],
                                          with: .fade)
                if vcType == .payWithIyzico {
                    menu[IyzicoMenuSectionType.installment.rawValue].isExtended = false
                    self.tableView.deleteRows(at: [IndexPath(row: .zero,
                                                             section: IyzicoMenuSectionType.installment.rawValue)],
                                              with: .fade)
                }
                
            }
            
        }
        else {
            if menu[section].sectionType == .account && vcType == .topUp { return } // if vcType is topUp and section is account we dont open it
            
            self.tableView.insertRows(at: indexPaths, with: .fade)
            if menu[section].sectionType == .creditCardList {
                menu[IyzicoMenuSectionType.addNewCreditCard.rawValue].isExtended = true
                headerArray[section].isExtended = true
                headerArray[section].IyzicoHeaderArrowView.image = Asset.icnUparrow.image
                self.tableView.insertRows(at: [IndexPath(row: .zero,
                                                         section: IyzicoMenuSectionType.addNewCreditCard.rawValue)],
                                          with: .fade)
                if vcType == .payWithIyzico {
                    menu[IyzicoMenuSectionType.installment.rawValue].isExtended = true
                    self.tableView.insertRows(at: [IndexPath(row: .zero,
                                                             section: IyzicoMenuSectionType.installment.rawValue)],
                                              with: .fade)
                }
                
            }
        }
    }
    
    private func fillHeaderItems() {
        menu.forEach { (menu) in
            headerArray.append(IyzicoMenuHeaderView(image: menu.image,
                                                    title: menu.title,
                                                    isExtended: menu.isExtended))
        }
        headerArray.first?.IyzicoHeaderArrowView.isHidden = true
        headerArray.first?.IyzicoHeaderImageView.isHidden = true
        headerArray.first?.IyzicoHeaderLabel.font = .markPro16
    }
    
    private func presentEftDetail(index: Int) {
        let flow = SDKManager.flow
        let vc = IyzicoEFTDetailVC(bankImage: Asset.addEmail.name,
                                   eftDetailType: flow == .topUp ? .bank : .transfer)
        vc.viewModel.protectedBankAccount = iyzicoHomeVM.getBanks()?[index]
        vc.viewModel.priceForLoad = iyzicoHomeVM.priceForLoad
        vc.viewModel.priceForPayment = SDKManager.price?.addTLWithAlignment(alignment: .left)
        vc.viewModel.navigatedReferenceCode = iyzicoHomeVM.getReferenceCode()
        vc.viewModel.bankTransferPaymentID = iyzicoHomeVM.getBankTransferPaymentID()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configurePaymentTypeUI(isFirstTime: Bool, section: Int? = nil) {
        let userHasCreditCard = iyzicoHomeVM.userHasCreditCard()
        switch SDKManager.flow {
        case .payWithIyzico:
            let basketPrice = SDKManager.flow == .topUp ? iyzicoHomeVM.priceForLoad?.serviceAmountFormatAsString : SDKManager.price?.roundedTwoDigitWithDot
            let myAccountBalance = getBalance()
            let isMixedPayment = iyzicoHomeVM.isMixedPayment(basketPrice: basketPrice,
                                                             myAccountBalance: myAccountBalance)
            if isFirstTime {
                if isMixedPayment {
                    if userHasCreditCard {
                        iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [1])
                        //Selecting first card by default
                        iyzicoHomeVM.selectedCells[1] = true
                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.mixed))
                    }
                    else {
                        configurePaymentTypeUIByNewCard()
                        iyzicoHomeVM.paymentType = .creditCard(.withNewCard(.mixed))
                    }
                    extendCell(in: 2)
                } else if (myAccountBalance?.asDouble ?? 0) > 0 {
                    iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                    iyzicoHomeVM.selectedCells[0] = true
                    extendCell(in: IyzicoMenuSectionType.account.rawValue)
                    iyzicoHomeVM.paymentType = .myAccount
                } else {
                    iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [1])
                    //Selecting first card by default
                    iyzicoHomeVM.selectedCells[1] = true
                    iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                    extendCell(in: 2)
                    showInfoView()
                }
            }
            else {
                guard let validatedSection = section else { return }
                let sectionType = IyzicoMenuSectionType(rawValue: validatedSection)
                switch sectionType {
                case .account:
                    iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                    iyzicoHomeVM.selectedCells[0] = true
                    iyzicoHomeVM.paymentType = .myAccount
                case .creditCardList:
                    let selectionType = isMixedPayment ? paymentSelection.mixed : paymentSelection.basic
                    if userHasCreditCard {
                        iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [1])
                        //Selecting first card by default
                        iyzicoHomeVM.selectedCells[1] = true
                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
                    }
                    else {
                        configurePaymentTypeUIByNewCard()
                        iyzicoHomeVM.paymentType = .creditCard(.withNewCard(selectionType))
                    }
                default:
                    iyzicoHomeVM.paymentType = .none
                }
            }
        case .topUp:
            if userHasCreditCard {
                iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                //Selecting first card by default
                iyzicoHomeVM.selectedCells[0] = true
                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
            }
            else {
                configurePaymentTypeUIByNewCard()
                iyzicoHomeVM.paymentType = .creditCard(.withNewCard(.basic))
            }
            if isFirstTime {
                extendCell(in: 2) //2 is index of Credit Card section
            }
            if let validatedSection = section,
               let sectionType = IyzicoMenuSectionType(rawValue: validatedSection) {
                let isCreditCardList = sectionType == .creditCardList
                iyzicoHomeVM.paymentType = isCreditCardList ? .creditCard(.withCreditCard(.basic)) : .none
            }
        default:
            iyzicoHomeVM.paymentType = .none
        }
        tableView.reloadData()
        checkForIyzicoButtonSelectedStatus()
        setPaymentTypeByExpandStatus()
    }
    
    private func configurePaymentTypeUIByNewCard() {
        let newCardCellIndex = iyzicoHomeVM.selectedCells.endIndex - 1
        iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [newCardCellIndex])
        iyzicoHomeVM.selectedCells[newCardCellIndex] = true
    }
    
    private func configureUseBalanceVisibility(cell: UITableViewCell) {
        guard let installmentTableCell = cell as? InstallmentTableCell else { return }
        let myAccountBalance = getBalance()//mainVM.balancesResponse?.amount
        #warning("price")
        installmentTableCell.priceContainerStackView.isHidden = !iyzicoHomeVM.getUseBalanceVisibility(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                                                             myAccountBalance: myAccountBalance)
        //// SONRADAN EKLEDNI
        if !installmentTableCell.priceContainerStackView.isHidden {
            iyzicoHomeVM.priceCheckBoxSelectedStatus = iyzicoHomeVM.isUserDisabledPriceCheckbox ?  !installmentTableCell.priceContainerStackView.isHidden : false
        }
       
    }
    
    private func makePayment() {
        ///TODO - Make default selection at viewDidLoad with service
        switch vcType {
        case .payWithIyzico:
            switch iyzicoHomeVM.paymentType {
            case .myAccount:
                ///TODO - Make payment with account service
                payWithBalance()
                //self.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
//                break
            case .creditCard(let creditCardPaymentType):
                switch creditCardPaymentType {
                case .withCreditCard(let selectionType):
                    switch selectionType {
                    case .basic:
                        ///TODO - Make payment with credit card + basic service
                        payWithJustCreditCard(isNewCard: false)
//                        break
                    case .mixed:
                        ///TODO - Make payment with credit card + mixed service
                        payWithMixedPaymentWithSavedCard()
//                        break
                    }
                case .withNewCard(let selectionType):
                    ///TODO - Check CVC validation again, something is wrong.
                    if checkForNewCardInputs() {
                        switch selectionType {
                        case .basic:
                            ///TODO - Make payment with new credit card + basic service
                            payWithJustCreditCard(isNewCard: true)
//                            break
                        case .mixed:
                            ///TODO - Make payment with new credit card + mixed service
                            payWithMixedPaymentWithNewCard()
//                            break
                        }
                    }
                }
            default:
                break
            }
        case .topUp:
            switch iyzicoHomeVM.paymentType {
            case .creditCard(let creditCardType):
                switch creditCardType {
                case .withCreditCard:
                    getDepositWithRegisteredCard()
                case .withNewCard:
                    ///TODO - Make with service
                    if checkForNewCardInputs() {
                        getDepositWithNewCard()
                    }
                }
            default:
                break
            }
        }
    }
    
    private func setPaymentTypeForCreditCardList(cell: UITableViewCell?) {
        let isMixedPayment = iyzicoHomeVM.priceCheckBoxSelectedStatus
        let payWithIyzicoSelectionType = isMixedPayment ? paymentSelection.mixed : paymentSelection.basic
        let selectionType = vcType == .payWithIyzico ? payWithIyzicoSelectionType : .basic
        if let _ = cell as? MyAccountCell {
            iyzicoHomeVM.paymentType = .myAccount
        }
        else if let _ = cell as? CreditCardCell {
            iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
        }
        else if let _ = cell as? NewCardCell {
            iyzicoHomeVM.paymentType = .creditCard(.withNewCard(selectionType))
        }
        else {
            iyzicoHomeVM.paymentType = .none
        }
    }
    
    private func setPaymentTypeForUseBalance(isMixedPayment: Bool) {
        switch iyzicoHomeVM.paymentType {
        case .creditCard(let creditCardPaymentType):
            let selectionType = isMixedPayment ? paymentSelection.mixed : paymentSelection.basic
            switch creditCardPaymentType {
            case .withCreditCard:
                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
            case .withNewCard:
                iyzicoHomeVM.paymentType = .creditCard(.withNewCard(selectionType))
            }
        default:
            break
        }
    }
    
    private func setPaymentTypeForNewCardOnExpand() {
        let isPayWithIyzico = vcType == .payWithIyzico
        let selectionTypeForPayWithIyzico: paymentSelection = (iyzicoHomeVM.priceCheckBoxSelectedStatus ? .mixed : .basic)
        let selectionType: paymentSelection = isPayWithIyzico ? selectionTypeForPayWithIyzico : .basic
        iyzicoHomeVM.paymentType = .creditCard(.withNewCard(selectionType))
        ///TODO - When clicking new card cell again, if user has no balance payment type turning to .mixed. Fix this.
    }
    
    private func setPaymentTypeByExpandStatus() {
        if !menu.map({ $0.isExtended }).contains(true) {
            iyzicoHomeVM.paymentType = .none
        }
    }
    
    //MARK: - Navigation
    private func navigateToTopUpSuccessResultVC() {
        let vc = ResultVC(vcType: .topUpSuccess)
        vc.resultVM.topUpPriceForLoad = iyzicoHomeVM.priceForLoad
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTopUpWaitingResultVC() {
        let vc = ResultVC(vcType: .topUpWaiting)
        vc.resultVM.topUpPriceForLoad = iyzicoHomeVM.priceForLoad
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToErrorResultVC() {
        let vc = ResultVC(vcType: .error)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func chooseResultVC(depositStatus: DepositStatus?) {
        guard let validatedDepositStatus = depositStatus else { return }
        switch SDKManager.flow {
        case .payWithIyzico:
            break
        case .topUp:
            if validatedDepositStatus == .WAITING_FOR_PROVISION {
                navigateToTopUpWaitingResultVC()
            }
            else {
                navigateToTopUpSuccessResultVC()
            }
        default:
            break
        }
    }
    
    //MARK: - Service Calls
    private func getCards() {
        iyzicoHomeVM.getCards(
        onSuccess: { [weak self] (response: CardItemsResponseModel?) in
            self?.mainVM.getBalances(
            onSuccess: { [weak self] (response: BalancesResponseModel?) in
                self?.iyzicoHomeVM.getProtectedBankAccounts(
                onSuccess: { [weak self] response in
                    self?.configurePaymentTypeUI(isFirstTime: true)
                },
                onFailure: { [weak self] errorDescription in
                    self?.showError(errorDescription: errorDescription)
                })
            }, onFailure: { errorDescription in
                self?.showError(errorDescription: errorDescription)
            })
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            self?.configurePaymentTypeUI(isFirstTime: true)
        })
    }
    
    private func getDepositWithRegisteredCard() {
        iyzicoHomeVM.getDepositWithRegisteredCard(
        onSuccess: { [weak self] (response: DepositWithRegisteredCardResponseModel?) in
            self?.chooseResultVC(depositStatus: response?.depositStatus)
        },
        onFailure: { [weak self] (errorDescription, networkStatusType) in
            if networkStatusType == .responseFailure {
                self?.navigateToErrorResultVC()
            }
            else {
                self?.showError(errorDescription: errorDescription)
            }
        })
    }
    
    private func getDepositWithNewCard() {
        iyzicoHomeVM.getDepositWithNewCard(
        onSuccess: { [weak self] (response: DepositWithNewCardResponseModel?) in
            self?.chooseResultVC(depositStatus: response?.depositStatus)
        },
        onFailure: { [weak self] (errorDescription, networkStatusType) in
            if networkStatusType == .responseFailure {
                self?.navigateToErrorResultVC()
            }
            else {
                self?.showError(errorDescription: errorDescription)
            }
        })
    }
    
    private func getPWIRetrieve() {
        iyzicoHomeVM.getRetrievePWI { [weak self] (response: PWIRetieveResponseModel?) in
            guard let self = self else {return}
            self.configurePaymentTypeUI(isFirstTime: true)
            self.tableView.reloadData()
        } onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func getInstallment(binNumber: String? , shouldShowLoading: Bool = true, reloadTableView: Bool = true, reloadSection: Bool = false ) {
        let price = iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price?.asString
        //let binNumber = iyzicoHomeVM.selectedCardForPayment?.binNumber
        iyzicoHomeVM.getInstallment(price: price, binNumber: binNumber, shouldShowLoading: shouldShowLoading) { [weak self] (response: InstallmentResponseModel?) in
            guard let self = self else {return}
            if reloadTableView {
               // self.menu[IyzicoMenuSectionType.installment.rawValue].isExtended = true
                self.iyzicoHomeVM.showInfoView = false
                self.tableView.reloadData()
            } else if reloadSection {
               // self.menu[IyzicoMenuSectionType.installment.rawValue].isExtended = true
                self.iyzicoHomeVM.showInfoView = false
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue], with: .none)
                }
            }
          
        } onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
}

// MARK: - TableView Delegate Methods
extension IyzicoHomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !menu[section].isExtended {
            return .zero
        }
        switch menu[section].sectionType {
        case .protectedPaymentMethod:
            return .zero
        case .account:
            if vcType == .topUp {
                return .zero
            }
            return 1
        case .creditCardList:
            guard let count = iyzicoHomeVM.getCardsCount() else { return 0 }
            return count
        case .addNewCreditCard:
            return 1 // kredi kartı ekleme alanında kaç tane alan varsa
        case .installment:
            if vcType == .topUp {
                return 1
            }
            return 1 // kredi kartı ekleme alanında kaç tane alan varsa
        case .eft:
//            if vcType == .topUp {
//                return banklist.count + 1 // for info cell
//            }
//            return banklist.count
            guard let banks = iyzicoHomeVM.getBanks() else { return 0 }
            if vcType == .topUp {
                return banks.count + 1 // for info cell
            }
            return banks.count
        case .none:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch menu[indexPath.section].sectionType {
        case .account:
            let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.MyAccountCell, for: indexPath) as! MyAccountCell
            cell.delegate = self
            let basketPrice = SDKManager.flow == .topUp ? iyzicoHomeVM.priceForLoad?.serviceAmountFormatAsString : SDKManager.price?.roundedTwoDigitWithDot
            let myAccountBalance = getBalance()
            let isMixedPayment = iyzicoHomeVM.isMixedPayment(basketPrice: basketPrice,
                                                             myAccountBalance: myAccountBalance)
            cell.checkBox.isHidden =  myAccountBalance?.asDouble == 0 ? !isMixedPayment : isMixedPayment
            setIyzicoButtonSelectedStatus(isSelected: myAccountBalance?.asDouble == 0 ? isMixedPayment : !isMixedPayment)
//            if iyzicoHomeVM.paymentType == .myAccount {
//                let balance = iyzicoHomeVM.isBalanceEligibletoPay(basketPrice: basketPrice, myAccountBalance: myAccountBalance)
//                cell.checkBox.isHidden = balance
//                self.setIyzicoButtonSelectedStatus(isSelected: balance)
//
//            }
            if iyzicoHomeVM.selectedCells[0] {
                cell.checkBox.select()
            }
            else {
                cell.checkBox.deSelect()
            }
            cell.balanceLabel.text = myAccountBalance?.addTLWithNoDots
            return cell
        case .creditCardList:
            let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.CreditCardCell, for: indexPath) as! CreditCardCell
            cell.setCell(indexPath: indexPath)
            cell.cardModel = iyzicoHomeVM.getCard(indexPath)
            let selectedIndex = SDKManager.flow == .payWithIyzico ? indexPath.row + 1 : indexPath.row
            if iyzicoHomeVM.selectedCells[selectedIndex] {
                cell.iyzicoCardView.checkBox.select()
                self.iyzicoHomeVM.selectedCardType = cell.cardModel?.cardType
            }
            else {
                cell.iyzicoCardView.checkBox.deSelect()
            }
            return cell
        case .addNewCreditCard:
            let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.NewCardCell, for: indexPath) as! NewCardCell
            ///TODO - Make isHidden false use balance view if user balance 0.
            cell.delegate = self
            cell.delegate?.didGetAllInputs(inputModels: cell.getAllInputs())
//            cell.priceLabel.text = getBalance()?.addTLWithNoDots
//
//            if iyzicoHomeVM.priceCheckBoxSelectedStatus {
//                cell.priceCheckBox.select()
//            }
//            else {
//                cell.priceCheckBox.deSelect()
//            }
            let selectedCells = iyzicoHomeVM.selectedCells
            cell.iyzicoCheckBox.isSelected = selectedCells[selectedCells.endIndex - 1]
            if cell.iyzicoCheckBox.isSelected {
                cell.iyzicoCheckBox.select()
            }
            else {
                cell.iyzicoCheckBox.deSelect()
            }
            cell.expandCard(isHidden: !cell.iyzicoCheckBox.isSelected)
//            if !cell.infoView.isHidden && SDKManager.flow == .payWithIyzico {
//                iyzicoHomeVM.setDefaultPrice()
//            }
//            if SDKManager.flow == .topUp {
//                cell.hideInstallment()
//            } else  {
//                cell.showInstallment(model: iyzicoHomeVM.installmentDetailResponse?.installmentDetails)
//            }
//
//            cell.withDrawView.isHidden = !iyzicoHomeVM.priceCheckBoxSelectedStatus
//            #warning("price")
//            let willBeSpendFromCardAmount = iyzicoHomeVM.getWillBeSpendFromCardAmount(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
//                                                                                      myAccountBalance: getBalance())?.addTLWithNoDots ?? ""
//            cell.withDrawAmountLabel.text = "Kartınızdan \(willBeSpendFromCardAmount) çekilecektir.".uppercased()
//            configureUseBalanceVisibility(cell: cell)
            return cell
            
        case .installment:
            let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InstallmentTableCell, for: indexPath) as! InstallmentTableCell
            cell.delegate = self
            iyzicoHomeVM.setDefaultPrice()
            cell.priceLabel.text = getBalance()?.addTLWithNoDots
            
            if iyzicoHomeVM.priceCheckBoxSelectedStatus {
                cell.priceCheckBox.select()
            }
            else {
                cell.priceCheckBox.deSelect()
            }
            if iyzicoHomeVM.showInfoView {
                cell.showInfoView()
            } else {
                cell.showInstallment(model: iyzicoHomeVM.installmentDetailResponse?.installmentDetails)
            }
           
            cell.withDrawView.isHidden = !iyzicoHomeVM.priceCheckBoxSelectedStatus
            #warning("price")
            let willBeSpendFromCardAmount = iyzicoHomeVM.getWillBeSpendFromCardAmount(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                                                      myAccountBalance: getBalance())?.addTLWithNoDots ?? ""
            cell.withDrawAmountLabel.text = "Kartınızdan \(willBeSpendFromCardAmount) çekilecektir.".uppercased()
            configureUseBalanceVisibility(cell: cell)
            return cell
        case .eft:
            let index = EftEnum(rawValue: indexPath.row)
            if index == .info && vcType == .topUp {
                let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InfoCell, for: indexPath) as! InfoCell
                cell.setCell(text:  StringConstant.shared.iyzicoHomeVCInfoText)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.BankCell, for: indexPath) as! BankCell
            
//            if vcType == .topUp {
//                cell.setCell(bankName: banklist[indexPath.row - 1], bankImage: Asset.cards.name)
//            } else {
//                cell.setCell(bankName: banklist[indexPath.row], bankImage: Asset.cards.name)
//            }
            guard let banks = iyzicoHomeVM.getBanks() else { return UITableViewCell() }
            if vcType == .topUp {
//                cell.setCell(bankName: banks[indexPath.row - 1].bankName ?? "", bankImage: Asset.cards.name)
                cell.setCell(bankName: banks[indexPath.row - 1].bankName ?? "",
                             bankLogoUrl: banks[indexPath.row - 1].bankLogoUrl,
                             placeholderBankLogo: Asset.cards.image)
            } else {
//                cell.setCell(bankName: banks[indexPath.row].bankName ?? "", bankImage: Asset.cards.name)
                cell.setCell(bankName: banks[indexPath.row].bank ?? "",
                             bankLogoUrl: banks[indexPath.row].bankLogoUrl,
                             placeholderBankLogo: Asset.cards.image)
            }
         
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let type: IyzicoMenuSectionType = IyzicoMenuSectionType(rawValue: section) ?? .none
        if type == .eft {
            return 64
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if menu[section].sectionType == .addNewCreditCard || menu[section].sectionType == .installment { return nil }
        if vcType == .topUp && menu[section].sectionType == .account { return nil }
        initializeHeaderSectionsEvents(section: section)
        return headerArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if menu[section].sectionType == .addNewCreditCard || menu[section].sectionType == .installment { return .zero }
        if vcType == .topUp && menu[section].sectionType == .account { return .zero }
        return Constant.shared.iyzicoHomeVCHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellForRow = tableView.cellForRow(at: indexPath)
        let isNewCardCell = (cellForRow)?.isKind(of: NewCardCell.self) ?? false
        let isCreditCardCell = (cellForRow)?.isKind(of: CreditCardCell.self) ?? false
        if !isNewCardCell {
            iyzicoHomeVM.setSelectedCard(cell: cellForRow)
            handleCellSelect(indexPath: indexPath)
            clearNewCardInputs()
        }
        
        if isCreditCardCell && SDKManager.flow == .payWithIyzico {
            getInstallment(binNumber: iyzicoHomeVM.selectedCardForPayment?.binNumber)
        }
        
        if menu[indexPath.section].sectionType == .eft {
            if SDKManager.flow == .topUp && indexPath.row != 0 {
                presentEftDetail(index: indexPath.row - 1)
            } else if SDKManager.flow == .payWithIyzico {
                let bankID = iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.bankTransferAccounts?[indexPath.row].bankId
                payWithBankTransfer(bankID: bankID,index: indexPath.row)
            } else if SDKManager.flow != .topUp {
                presentEftDetail(index: indexPath.row)
            }
        }
        setPaymentTypeForCreditCardList(cell: cellForRow)
    }
}


//MARK:- HELPER FUNCS
extension IyzicoHomeVC {
    
    fileprivate func getBalance() -> String? {
       let balance = SDKManager.flow == .payWithIyzico ? iyzicoHomeVM.pwiRetrieveResponse?.memberBalance?.amount : mainVM.balancesResponse?.amount
        if balance == nil {
            return "0.00"
        }
        return balance
    }
    
    fileprivate func getFirstInstallment() {
        let userHasCreditCard = iyzicoHomeVM.userHasCreditCard()
        if userHasCreditCard {
            let binNumber = iyzicoHomeVM.getCard(IndexPath(row: .zero, section: .zero))?.binNumber
            getInstallment(binNumber: binNumber, shouldShowLoading: false)
        }
    }
}

//MARK: - PAYMENTS SERVICE CALLS

extension IyzicoHomeVC {
    
    private func payWithBalance() {
        iyzicoHomeVM.payWithBalance { [weak self] (response: PayWithBalanceResponseModel?) in
            self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithMixedPaymentWithSavedCard() {
        iyzicoHomeVM.payWithMixedPaymentWithSavedCard { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithMixedPaymentWithNewCard() {
        iyzicoHomeVM.payWithMixedPaymentWithNewCard { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithJustCreditCard(isNewCard: Bool) {
        let threeDS = iyzicoHomeVM.installmentDetailResponse?.installmentDetails?.first?.force3Ds == 1 ? true : false
        if !threeDS {
            payWithPaymentWithNewCardNon3ds(isNewCard: isNewCard)
        } else {
            payWithPaymentWithNewCardWith3ds(isNewCard: isNewCard)
        }
    }
    
    private func payWithPaymentWithNewCardNon3ds(isNewCard: Bool) {
        iyzicoHomeVM.payWithPaymentWithNewCard(isNewCard: isNewCard) { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithPaymentWithNewCardWith3ds(isNewCard: Bool) {
        iyzicoHomeVM.payWithPaymentWithNewCard3DS(isNewCard: isNewCard) { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            let vc = ResultVC(vcType: .threeDSecure)
            vc.resultVM.html = response?.threeDSHTMLContent
            self?.navigationController?.pushViewController(vc, animated: true)
            //self?.navigationController?.pushViewController(vc, animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithBankTransfer(bankID: Int?, index: Int) {
        iyzicoHomeVM.payWithBankTransfer(bankID: bankID)  { [weak self] (response: PaymentBankTransferResponseModel?) in
            self?.presentEftDetail(index: index)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }

}

//MARK:- InstallmentTableCellDelegate
extension IyzicoHomeVC: InstallmentTableCellDelegate {
    
    func didTappedAmountButton(priceCheckBox: IyzicoCheckBox) {
        priceCheckBox.setSelected()
        iyzicoHomeVM.priceCheckBoxSelectedStatus = priceCheckBox.isSelected
        iyzicoHomeVM.isUserDisabledPriceCheckbox =  priceCheckBox.isSelected
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue], with: .none)
        }
        setPaymentTypeForUseBalance(isMixedPayment: iyzicoHomeVM.priceCheckBoxSelectedStatus)
    }
    
    func getInstallmentNumber(installment: Int?, totalPrice: Double?) {
        iyzicoHomeVM.installmentCount = installment
        iyzicoHomeVM.installmentPrice = totalPrice
    }
    
}
