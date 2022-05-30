//
//  IyzicoHomeVC.swift
//  iyzicoSDK
//
//  Created by Kasım Sağır on 21.12.2020.
//

import UIKit

class IyzicoHomeVC: BaseVC, NewCardCellDelegate, MyAccountCellDelegate, IyzicoCardBonusViewDelegate {
    
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
    private var selectedIndex = 0
    
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
            iyzicoHomeVM.makePaymentTapped = true
            self.makePayment()
        }
    }
    
    private func initializeHeaderSectionsEvents(section: Int) {
        headerArray[section].didTappedHeader = { [unowned self] in
            if self.menu[section].sectionType != .protectedPaymentMethod {
                self.extendCell(in: section)
                self.configurePaymentTypeUI(isFirstTime: false, section: section)
                self.checkForIyzicoButtonSelectedStatusByExpand(section: section)
                self.clearNewCardInputs()
            }
            if self.menu[section].sectionType == .creditCardList && iyzicoHomeVM.userHasCreditCard() && menu[section].isExtended && SDKManager.flow == .payWithIyzico {
                getFirstInstallment()
            }
            
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
            DispatchQueue.main.async {
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
        iyzicoHomeVM.selectedCardForPayment = nil
        handleCellSelect(indexPath: IndexPath(row: 0, section: IyzicoMenuSectionType.addNewCreditCard.rawValue))
        setPaymentTypeForNewCardOnExpand()
        tableView.scrollToRow(at: IndexPath(row: .zero,
                                            section: IyzicoMenuSectionType.addNewCreditCard.rawValue),
                              at: .top,
                              animated: true)
        showInfoView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
//        UIView.performWithoutAnimation {
//            self.tableView.reloadData()
//        }
        iyzicoHomeVM.addCardSelected = true
        iyzicoHomeVM.priceCheckBoxSelectedStatus = false
    }
    
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
        //        tableView.registerCell(type: UseBalanceCell.self)
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
        iyzicoHomeVM.selectedCell = tableView.cellForRow(at: indexPath)
        if sectionType != .eft {
            checkForIyzicoButtonSelectedStatus()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        iyzicoHomeVM.isAddCardBonusAvailable = false
    }
    
    //    private func fillInputs() {
    //        iyzicoHomeVM.newCardInputsArray?.forEach({ inputModel in
    //            inputModel.input?.textField.text =
    //            inputModel.input?.removeErrorUI()
    //            inputModel.input?.isInputValid = true
    //            inputModel.input?.addBorder(borderColor: UIColor.gray400.cgColor)
    //            inputModel.input?.titleLabel.font = .markPro12
    //        })
    //    }
    
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
//                iyzicoHomeVM.isCreditCardListCellOpened = true
//                if SDKManager.flow == .payWithIyzico {
//                    getFirstInstallment()
//                }
                
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
                let isFundEnabled = iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.fundEnabled
                if isFirstTime {
                    if isMixedPayment {
                        if isFundEnabled == true {
                            if userHasCreditCard {
                                if iyzicoHomeVM.numberOfIyzicoCards == iyzicoHomeVM.memberCards?.count {
                                    configurePaymentTypeUIByNewCard()
                                    iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                } else {
                                    iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [iyzicoHomeVM.numberOfIyzicoCards])
                                    iyzicoHomeVM.selectedCells[iyzicoHomeVM.numberOfIyzicoCards] = true
                                    iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[iyzicoHomeVM.numberOfIyzicoCards]
                                    if iyzicoHomeVM.selectedCardForPayment?.threeDSVerified == true {
                                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.mixed))
                                    } else {
                                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                    }
                                    getFirstInstallment()
                                }
                            } else {
                                configurePaymentTypeUIByNewCard()
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                            }
                        } else {
                            if userHasCreditCard {
                                if iyzicoHomeVM.numberOfIyzicoCards == iyzicoHomeVM.memberCards?.count {
                                    configurePaymentTypeUIByNewCard()
                                    iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                } else {
                                    iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [iyzicoHomeVM.numberOfIyzicoCards])
                                    iyzicoHomeVM.selectedCells[iyzicoHomeVM.numberOfIyzicoCards] = true
                                    iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[iyzicoHomeVM.numberOfIyzicoCards]
                                    iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                    getFirstInstallment()
                                }
                            } else {
                                configurePaymentTypeUIByNewCard()
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                            }
                        }
                        extendCell(in: 2)
                    } else {
                        if isFundEnabled == true {
                            if myAccountBalance?.asDouble == 0.0 {
                                if userHasCreditCard {
                                    if iyzicoHomeVM.numberOfIyzicoCards == iyzicoHomeVM.memberCards?.count {
                                        configurePaymentTypeUIByNewCard()
                                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                        getFirstInstallment()
                                    } else {
                                        iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [iyzicoHomeVM.numberOfIyzicoCards])
                                        iyzicoHomeVM.selectedCells[iyzicoHomeVM.numberOfIyzicoCards] = true
                                        iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[iyzicoHomeVM.numberOfIyzicoCards]
                                        iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.mixed))
                                        getFirstInstallment()
                                    }
                                } else {
                                    configurePaymentTypeUIByNewCard()
                                    iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                                }
                                extendCell(in: 2)
                            } else {
                                iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                                iyzicoHomeVM.selectedCells[0] = true
                                extendCell(in: IyzicoMenuSectionType.account.rawValue)
                                iyzicoHomeVM.paymentType = .myAccount
                            }
                        } else {
                            if userHasCreditCard {
                                iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                                iyzicoHomeVM.selectedCells[0] = true
                                iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[0]
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.mixed))
                                getFirstInstallment()
                            } else {
                                configurePaymentTypeUIByNewCard()
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(.basic))
                            }
                            
                            extendCell(in: 2)
                        }
                    }
                } else {
                    guard let validatedSection = section else { return }
                    let sectionType = IyzicoMenuSectionType(rawValue: validatedSection)
                    switch sectionType {
                        case .account:
                            iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                            iyzicoHomeVM.selectedCells[0] = true
                            iyzicoHomeVM.paymentType = .myAccount
                        case .creditCardList:
                            var selectionType = isMixedPayment ? paymentSelection.mixed : paymentSelection.basic
                            
                            if userHasCreditCard && iyzicoHomeVM.isIyzicoDisabled && (iyzicoHomeVM.memberCards?.count ?? 0 > iyzicoHomeVM.numberOfIyzicoCards) {
                                
                                iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [iyzicoHomeVM.numberOfIyzicoCards])
                                //Selecting first card by default
                                iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[iyzicoHomeVM.numberOfIyzicoCards]
                                iyzicoHomeVM.selectedCells[iyzicoHomeVM.numberOfIyzicoCards] = true
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
                            } else if userHasCreditCard && !iyzicoHomeVM.isIyzicoDisabled {
                                iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [0])
                                //Selecting first card by default
                                
                                iyzicoHomeVM.selectedCardForPayment = iyzicoHomeVM.memberCards?[0]
                                iyzicoHomeVM.selectedCells[0] = true
                                iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
                            } else {
                                selectionType = .basic
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        checkForIyzicoButtonSelectedStatus()
        setPaymentTypeByExpandStatus()
    }
    
    private func configurePaymentTypeUIByNewCard() {
        let newCardCellIndex = iyzicoHomeVM.selectedCells.endIndex - 1
        iyzicoHomeVM.changeAllElementsInSelectedCells(status: false, exceptForIndexs: [newCardCellIndex])
        iyzicoHomeVM.selectedCells[newCardCellIndex] = true
    }
    
    private func configureUseBalanceVisibility(cell: UITableViewCell, isThreeDSVerified: Bool) {
        guard let installmentTableCell = cell as? InstallmentTableCell else { return }
        let myAccountBalance = getBalance()//mainVM.balancesResponse?.amount
        installmentTableCell.priceContainerStackView.isHidden = (!iyzicoHomeVM.getUseBalanceVisibility(basketPrice: SDKManager.price?.roundedTwoDigitWithDot, myAccountBalance: myAccountBalance) || iyzicoHomeVM.addCardSelected || !isThreeDSVerified || iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.fundEnabled == false)
        //// SONRADAN EKLEDNI
        //        if !installmentTableCell.priceContainerStackView.isHidden {
        //            iyzicoHomeVM.priceCheckBoxSelectedStatus = iyzicoHomeVM.isUserDisabledPriceCheckbox ?  !installmentTableCell.priceContainerStackView.isHidden : false
        //        }
        
    }
    
    private func makePayment() {
        ///TODO - Make default selection at viewDidLoad with service
        switch vcType {
            case .payWithIyzico:
#warning("paymentType business degisecek, detaylar gelecek. bakiyemi kullan/bonus kullan")
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
        let isMixedPayment = iyzicoHomeVM.selectedCardForPayment?.threeDSVerified == true && iyzicoHomeVM.isIyzicoDisabled && iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.fundEnabled == true
        let payWithIyzicoSelectionType = isMixedPayment ? paymentSelection.mixed : paymentSelection.basic
        let selectionType = vcType == .payWithIyzico ? payWithIyzicoSelectionType : .basic
        if let _ = cell as? MyAccountCell {
            iyzicoHomeVM.paymentType = .myAccount
        }
        else if let _ = cell as? CreditCardCell {
            iyzicoHomeVM.paymentType = .creditCard(.withCreditCard(selectionType))
        }
        else if let _ = cell as? NewCardCell {
            iyzicoHomeVM.paymentType = .creditCard(.withNewCard(.basic))
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
                        iyzicoHomeVM.paymentType = .creditCard(.withNewCard(.basic))
                }
            default:
                break
        }
    }
    
    private func setPaymentTypeForNewCardOnExpand() {
        let isPayWithIyzico = vcType == .payWithIyzico
        let selectionTypeForPayWithIyzico: paymentSelection = .basic
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
                self?.getBalanceService()
            },
            onFailure: { [weak self] errorDescription, errorCode in
                self?.showError(errorDescription: errorDescription)
                self?.getBalanceService()
                //     if errorCode == ErrorCodes.notValidEmail.rawValue {
                print(errorCode as Any)
                //}
            })
    }
    
    private func getBonus(indexPath: IndexPath?) {
        if SDKManager.flow == .payWithIyzico {
            iyzicoHomeVM.getBonus(
                onSuccess: { [weak self] (response: CardBonusResponseModel?) in
                    if let index = indexPath {
                        self?.iyzicoHomeVM.memberCards?[index.row].isBonusHidden = false
                        DispatchQueue.main.async {
                            self?.tableView.reloadRows(at: [index], with: .none)
                        }
                    }
                },
                onFailure: { [weak self] _,_ in
                    if let index = indexPath {
                        self?.iyzicoHomeVM.memberCards?[index.row].isBonusHidden = true
                        DispatchQueue.main.async {
                            self?.tableView.reloadSections([IyzicoMenuSectionType.creditCardList.rawValue], with: .none)
                        }
                    }
                })
        }
        
    }
    
    private func getBalanceService() {
        self.mainVM.getBalances(
            onSuccess: { [weak self] (response: BalancesResponseModel?) in
                self?.getProtectedBankAccounts()
            }, onFailure: { errorDescription in
                self.showError(errorDescription: errorDescription)
                self.getProtectedBankAccounts()
            })
    }
    
    private func getProtectedBankAccounts() {
        self.iyzicoHomeVM.getProtectedBankAccounts(
            onSuccess: { [weak self] response in
                self?.configurePaymentTypeUI(isFirstTime: true)
            },
            onFailure: { [weak self] errorDescription in
                self?.showError(errorDescription: errorDescription)
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue],
                                                   with: .none)
                }
            } else if reloadSection {
                // self.menu[IyzicoMenuSectionType.installment.rawValue].isExtended = true
                self.iyzicoHomeVM.showInfoView = false
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue],
                                                   with: .none)
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
                //                if iyzicoHomeVM.useBalance ise return 0
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
                let useBalanceVisibility = iyzicoHomeVM.getUseBalanceVisibility(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                                                myAccountBalance: getBalance())
                let isDisabled = (useBalanceVisibility || getBalance()?.asDouble == 0.0) && (iyzicoHomeVM.memberCards?[indexPath.row].iyzicoCard == true || iyzicoHomeVM.memberCards?[indexPath.row].iyzicoVirtualCard == true) && SDKManager.flow == .payWithIyzico
                if isDisabled == true {
                    iyzicoHomeVM.isIyzicoDisabled = isDisabled
                }
                if iyzicoHomeVM.isBonusEnabled {
                    cell.iyzicoCardView.bonusTotalView.useBonusCheckbox.select()
                } else {
                    cell.iyzicoCardView.bonusTotalView.useBonusCheckbox.deSelect()
                }
                selectedIndex = indexPath.row
                cell.delegate = self
                var newCardModel = iyzicoHomeVM.getCard(indexPath)
                newCardModel?.isDisabled = isDisabled
                cell.cardModel = newCardModel
                selectedIndex = indexPath.row
                cell.iyzicoCardView.bonusTotalView.delegate = self
                cell.isUserInteractionEnabled = !isDisabled
                cell.setCell(indexPath: indexPath, isDisabled: isDisabled, numOfIyzicoCards: iyzicoHomeVM.numberOfIyzicoCards)
                if iyzicoHomeVM.selectedCells[selectedIndex] {
                    cell.iyzicoCardView.checkBox.select()
                    self.iyzicoHomeVM.selectedCardType = cell.cardModel?.cardType
                    if iyzicoHomeVM.memberCards?[selectedIndex].isBonusHidden == false {
                        if iyzicoHomeVM.priceCheckBoxSelectedStatus {
                            
                            let mix = ((getBalance()?.asDouble ?? 0.0) + (iyzicoHomeVM.getBonusResponse?.amount ?? 0.0))
                            if mix > iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0 {
                                let newPoint = (iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0) - (getBalance()?.asDouble ?? 0.0)
                                if newPoint > iyzicoHomeVM.getBonusResponse?.amount ?? 0.0 {
                                    cell.setBonusView(isHidden: false,
                                                      enableSecondLabel: false,
                                                      totalBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0,
                                                      usableBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0)
                                    iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.getBonusResponse?.amount ?? 0
                                } else {
                                    cell.setBonusView(isHidden: false,
                                                      enableSecondLabel: true,
                                                      totalBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0,
                                                      usableBonusAmount: newPoint)
                                    iyzicoHomeVM.bonusUsageAmount = newPoint
                                }
                            } else {
                                cell.setBonusView(isHidden: false,
                                                  enableSecondLabel: false,
                                                  totalBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0,
                                                  usableBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0)
                                iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.getBonusResponse?.amount ?? 0.0
                            }
                        } else {
                            if iyzicoHomeVM.getBonusResponse?.amount ?? 0 > iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0 {
                                cell.setBonusView(isHidden: false,
                                                  enableSecondLabel: true,
                                                  totalBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0,
                                                  usableBonusAmount: iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0)
                                iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0
                            } else {
                                cell.setBonusView(isHidden: false,
                                                  enableSecondLabel: false,
                                                  usableBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0)
                                iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.getBonusResponse?.amount ?? 0.0
                            }
                        }
                    } else {
                        cell.setBonusView(isHidden: true)
                    }
                    
                } else {
                    cell.iyzicoCardView.checkBox.deSelect()
                    cell.iyzicoCardView.bonusTotalView.useBonusCheckbox.deSelect()
                    cell.setBonusView(isHidden: true, enableSecondLabel: false)
                }
                cell.iyzicoCardView.bonusTotalView.delegate = self
                let plusInstallmentBanklist = iyzicoHomeVM.plusInstallmentBankList
#warning("vm'de yapilacak")
                if indexPath.row == 0 {
                    switch plusInstallmentBanklist?.count {
                        case 0:
                            cell.setInfoView(isHidden: true)
                        case 1:
                            if vcType == .payWithIyzico {
                                cell.installmentOfferLabel.addAttribute(text: "\(plusInstallmentBanklist?[0].cardBankDtoList?[0].cardBankName ?? "") kartınla yapacağın taksitli alışverişlerde vade farksız + \(plusInstallmentBanklist?[0].plusInstallment ?? "0") Taksit!", attText: "vade farksız + \(plusInstallmentBanklist?[0].plusInstallment ?? "0") Taksit!",
                                                                        color: .mediumGreenTwo,
                                                                        highletedFont: .markProBold14,
                                                                        isCenter: true)
                                cell.setInfoView(isHidden: false)
                            } else {
                                cell.setInfoView(isHidden: true)
                            }
                            
                        default:
                            if vcType == .payWithIyzico {
                                let plusInstallmentCountText = plusInstallmentBanklist?[0].plusInstallment == plusInstallmentBanklist?[1].plusInstallment ? "+ \(plusInstallmentBanklist?[0].plusInstallment ?? "0")" : "+ \(plusInstallmentBanklist?[0].plusInstallment ?? "0") ve + \(plusInstallmentBanklist?[1].plusInstallment ?? "0")"
                                cell.installmentOfferLabel.addAttribute(text: "\(plusInstallmentBanklist?[0].cardBankDtoList?[0].cardBankName ?? "") veya \(plusInstallmentBanklist?[1].cardBankDtoList?[0].cardBankName ?? "") kartınla yapacağın taksitli alışverişlerde vade farksız  \(plusInstallmentCountText) Taksit!", attText: "vade farksız  \(plusInstallmentCountText) Taksit!",
                                                                        color: .mediumGreenTwo,
                                                                        highletedFont: .markProBold14,
                                                                        isCenter: true)
                                cell.setInfoView(isHidden: false)
                            } else {
                                cell.setInfoView(isHidden: true)
                            }
                    }
                }
                return cell
            case .addNewCreditCard:
                let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.NewCardCell, for: indexPath) as! NewCardCell
                ///TODO - Make isHidden false use balance view if user balance 0.
                
                cell.setCellWithBonus(cardName: iyzicoHomeVM.getCardHolderName(),
                                      cardNumber: iyzicoHomeVM.getCardNumber(),
                                      cvv: iyzicoHomeVM.getCvcCode(),
                                      skt: iyzicoHomeVM.newCardInputsArray?[2].input?.textField.text)
                
                cell.delegate = self
                cell.delegate?.didGetAllInputs(inputModels: cell.getAllInputs())
                cell.totalBonusView.delegate = self
                
                let selectedCells = iyzicoHomeVM.selectedCells
                if selectedCells[selectedCells.endIndex - 1] {
                    if iyzicoHomeVM.isAddCardBonusAvailable {
                        if iyzicoHomeVM.getBonusResponse?.amount ?? 0 > iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0 {
                            cell.setBonusView(isHidden: false,
                                              enableSecondLabel: true,
                                              totalBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0,
                                              usableBonusAmount: iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0)
                            iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.price ?? 0.0
                        } else {
                            cell.setBonusView(isHidden: false,
                                              enableSecondLabel: false,
                                              usableBonusAmount: iyzicoHomeVM.getBonusResponse?.amount ?? 0.0)
                            iyzicoHomeVM.bonusUsageAmount = iyzicoHomeVM.getBonusResponse?.amount ?? 0.0
                        }
                    } else {
                        cell.setBonusView(isHidden: true)
                    }
                    cell.iyzicoCheckBox.select()
                } else {
                    cell.iyzicoCheckBox.deSelect()
                    cell.setBonusView(isHidden: true)
                    cell.totalBonusView.useBonusCheckbox.deSelect()
                }
                
                if let count = iyzicoHomeVM.getCardsCount() {
                    if count == 0 {
                        cell.setInfoView(model: iyzicoHomeVM.plusInstallmentBankList)
                    } else {
                        cell.setInfoView(model: nil)
                    }
                }
                cell.expandCard(isHidden: !cell.iyzicoCheckBox.isSelected)
                return cell
                
            case .installment:
                let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InstallmentTableCell, for: indexPath) as! InstallmentTableCell
                cell.delegate = self
                iyzicoHomeVM.setDefaultPrice()
                cell.priceLabel.text = getBalance()?.addTLWithNoDots
                if iyzicoHomeVM.isIyzicoDisabled && iyzicoHomeVM.selectedCardForPayment?.threeDSVerified == true && iyzicoHomeVM.newCardSelected && iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.fundEnabled == true {
                    cell.priceCheckBox.select()
                    iyzicoHomeVM.priceCheckBoxSelectedStatus = true
                } else {
                    cell.priceCheckBox.deSelect()
                    iyzicoHomeVM.priceCheckBoxSelectedStatus = false
                }
                if iyzicoHomeVM.makePaymentTapped == false {
                    if iyzicoHomeVM.showInfoView {
                        cell.showInfoView()
                    } else {
                        if iyzicoHomeVM.selectedCardForPayment?.threeDSVerified == false {
                            cell.priceCheckBox.isSelected = false
                        }
                        cell.showInstallment(model: iyzicoHomeVM.installmentDetailResponse?.installmentDetails)
                    }
                }
                
                cell.withDrawView.isHidden = !iyzicoHomeVM.priceCheckBoxSelectedStatus
                let willBeSpendFromCardAmount = iyzicoHomeVM.getWillBeSpendFromCardAmount(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                                                          myAccountBalance: getBalance())?.addTLWithNoDots ?? ""
                cell.withDrawAmountLabel.text = "Kartından \(willBeSpendFromCardAmount) çekilecektir."
                configureUseBalanceVisibility(cell: cell, isThreeDSVerified: iyzicoHomeVM.selectedCardForPayment?.threeDSVerified ?? false)
                return cell
            case .eft:
                let index = EftEnum(rawValue: indexPath.row)
                if index == .info && vcType == .topUp {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InfoCell, for: indexPath) as! InfoCell
                    cell.setCell(text:  StringConstant.shared.iyzicoHomeVCInfoText)
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.BankCell, for: indexPath) as! BankCell
                guard let banks = iyzicoHomeVM.getBanks() else { return UITableViewCell() }
                if vcType == .topUp {
                    cell.setCell(bankName: banks[indexPath.row - 1].bankName ?? "",
                                 bankLogoUrl: banks[indexPath.row - 1].bankLogoUrl,
                                 placeholderBankLogo: Asset.cards.image)
                } else {
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
//        if iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.bankTransferEnabled == false { return nil }
        if vcType == .topUp && menu[section].sectionType == .account { return nil }
        initializeHeaderSectionsEvents(section: section)
        return headerArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if menu[section].sectionType == .addNewCreditCard || menu[section].sectionType == .installment { return .zero }
        if vcType == .topUp && menu[section].sectionType == .account { return .zero }
        if iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.bankTransferEnabled == false && menu[section].sectionType == .eft { return .zero }
        if iyzicoHomeVM.pwiRetrieveResponse?.checkoutDetail?.fundEnabled == false && menu[section].sectionType == .account { return .zero}
        return Constant.shared.iyzicoHomeVCHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cellForRow = tableView.cellForRow(at: indexPath)
        if let creditCardCell = cellForRow as? CreditCardCell, creditCardCell.cardModel?.cardToken == iyzicoHomeVM.selectedCardForPayment?.cardToken {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellForRow = tableView.cellForRow(at: indexPath)
        let isNewCardCell = (cellForRow)?.isKind(of: NewCardCell.self) ?? false
        let isCreditCardCell = (cellForRow)?.isKind(of: CreditCardCell.self) ?? false
        if !isNewCardCell {
            iyzicoHomeVM.addCardSelected = false
            iyzicoHomeVM.setSelectedCard(cell: cellForRow)
            handleCellSelect(indexPath: indexPath)
            clearNewCardInputs()
        } else {
            iyzicoHomeVM.priceCheckBoxSelectedStatus = false
            iyzicoHomeVM.paymentType = .creditCard(.withNewCard(.basic))
        }
        
#warning("MODELE GOMULECEK")
        
        if isCreditCardCell && SDKManager.flow == .payWithIyzico {
            //            iyzicoHomeVM.newCardSelected = true
            //            if iyzicoHomeVM.selectedCardForPayment?.threeDSVerified == true {
            //                iyzicoHomeVM.priceCheckBoxSelectedStatus = true
            //            } else {
            //                iyzicoHomeVM.priceCheckBoxSelectedStatus = false
            //            }
            iyzicoHomeVM.isBonusEnabled = false
            getBonus(indexPath: indexPath)
            getInstallment(binNumber: iyzicoHomeVM.selectedCardForPayment?.binNumber, reloadTableView: false, reloadSection: true)
            if iyzicoHomeVM.getUseBalanceVisibility(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                    myAccountBalance: getBalance()) {
                iyzicoHomeVM.priceCheckBoxSelectedStatus = true
            } else {
                iyzicoHomeVM.priceCheckBoxSelectedStatus = false
            }
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
    
    func setBonusUsage(enabled: Bool) {
        iyzicoHomeVM.isBonusEnabled = enabled
        print("isBonusEnabled: \(enabled)")
    }
    
    func checkCardBonus() {
        if SDKManager.flow == .payWithIyzico {
            iyzicoHomeVM.getNewCardBonus { [weak self] model in
                guard let self = self else {
                    return
                }
                self.iyzicoHomeVM.isAddCardBonusAvailable = true
                self.iyzicoHomeVM.bonusUsageAmount = model?.amount ?? 0.0
                DispatchQueue.main.async {
                    self.tableView.reloadSections([IyzicoMenuSectionType.addNewCreditCard.rawValue],
                                                   with: .none)
                }
                
            } onFailure: { [weak self] _, _ in
                self?.iyzicoHomeVM.isAddCardBonusAvailable = false
                //                self?.tableView.reloadSections([IyzicoMenuSectionType.addNewCreditCard.rawValue], with: .none)
            }
        }
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
            var binNumber: String? = ""
            let isIyzicoCardSelected: Bool = iyzicoHomeVM.numberOfIyzicoCards == 0 || iyzicoHomeVM.isIyzicoDisabled == false
            if iyzicoHomeVM.getUseBalanceVisibility(basketPrice: SDKManager.price?.roundedTwoDigitWithDot,
                                                    myAccountBalance: getBalance()) {
                if isIyzicoCardSelected {
                    binNumber = iyzicoHomeVM.getCard(IndexPath(row: .zero, section: .zero))?.binNumber
                } else {
                    binNumber = iyzicoHomeVM.getCard(IndexPath(row: .zero + iyzicoHomeVM.numberOfIyzicoCards, section: .zero))?.binNumber
                }
            } else {
                binNumber = iyzicoHomeVM.getCard(IndexPath(row: .zero, section: .zero))?.binNumber
            }
            getBonus(indexPath: IndexPath(row: isIyzicoCardSelected ? .zero : .zero + iyzicoHomeVM.numberOfIyzicoCards,
                                          section: IyzicoMenuSectionType.creditCardList.rawValue))
            getInstallment(binNumber: binNumber, shouldShowLoading: false)
        }
    }
}

//MARK: - PAYMENTS SERVICE CALLS

extension IyzicoHomeVC {
#warning("payment tipleri kontrol edilecek")
    private func payWithBalance() {
        iyzicoHomeVM.payWithBalance { [weak self] (response: PayWithBalanceResponseModel?) in
            self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithMixedPaymentWithSavedCard() {
        iyzicoHomeVM.payWithMixedPaymentWithSavedCard { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            if response?.threeDSHtmlContent != nil && response?.threeDSHtmlContent != "" {
                if response?.threeDSHtmlContent?.contains("doctype") == false {
                    let vc = ResultVC(vcType: .threeDSecureWithURL)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ResultVC(vcType: .threeDSecure)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
            }
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    //NOT AVAILABLE ANYMORE
    private func payWithMixedPaymentWithNewCard() {
        iyzicoHomeVM.payWithMixedPaymentWithNewCard { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            if response?.threeDSHtmlContent != nil && response?.threeDSHtmlContent != "" {
                if response?.threeDSHtmlContent?.contains("doctype") == false {
                    let vc = ResultVC(vcType: .threeDSecureWithURL)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ResultVC(vcType: .threeDSecure)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
            }
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithJustCreditCard(isNewCard: Bool) {
        let forceThreeDS = iyzicoHomeVM.installmentDetailResponse?.installmentDetails?.first?.force3Ds == 1 ? true : false
        if !forceThreeDS {
            payWithPaymentWithNewCardNon3ds(isNewCard: isNewCard)
        } else {
            payWithPaymentWithNewCardWith3ds(isNewCard: isNewCard)
        }
        
    }
    
    private func payWithPaymentWithNewCardNon3ds(isNewCard: Bool) {
        iyzicoHomeVM.payWithPaymentWithNewCard(isNewCard: isNewCard) { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            if response?.threeDSHtmlContent != nil && response?.threeDSHtmlContent != "" {
                if response?.threeDSHtmlContent?.contains("doctype") == false {
                    let vc = ResultVC(vcType: .threeDSecureWithURL)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ResultVC(vcType: .threeDSecure)
                    vc.resultVM.html = response?.threeDSHtmlContent
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self?.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
            }
            
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
    
    private func payWithPaymentWithNewCardWith3ds(isNewCard: Bool) {
        iyzicoHomeVM.payWithPaymentWithNewCard3DS(isNewCard: isNewCard) { [weak self] (response: MixedPaymentWithSavedCardResponseModel?) in
            if response?.threeDSHtmlContent?.contains("doctype") == false {
                let vc = ResultVC(vcType: .threeDSecureWithURL)
                vc.resultVM.html = response?.threeDSHtmlContent
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ResultVC(vcType: .threeDSecure)
                vc.resultVM.html = response?.threeDSHtmlContent
                self?.navigationController?.pushViewController(vc, animated: true)
            }
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
        iyzicoHomeVM.priceCheckBoxSelectedStatus = priceCheckBox.isSelected
        iyzicoHomeVM.isUserDisabledPriceCheckbox = priceCheckBox.isSelected
        iyzicoHomeVM.newCardSelected.toggle()
        DispatchQueue.main.async {
            self.tableView.reloadSections([IyzicoMenuSectionType.installment.rawValue], with: .none)
            self.tableView.reloadSections([IyzicoMenuSectionType.creditCardList.rawValue], with: .none)
        }
        setPaymentTypeForUseBalance(isMixedPayment: iyzicoHomeVM.priceCheckBoxSelectedStatus && iyzicoHomeVM.isMixedPayment(basketPrice: SDKManager.price?.roundedTwoDigitWithDot, myAccountBalance: getBalance()))
    }
    
    func getInstallmentNumber(installment: Int?, totalPrice: Double?) {
        iyzicoHomeVM.installmentCount = installment
        iyzicoHomeVM.installmentPrice = totalPrice
    }
    
}

extension IyzicoHomeVC: CreditCardCellDelegate {
    func saveCardModel(data: Data?, index: IndexPath?) {
        if let data = data, let index = index {
            self.iyzicoHomeVM.memberCards?[index.row].cardImage = data
        }
    }
    
    
}
