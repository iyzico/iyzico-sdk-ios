//
//  IyzicoTransferVC.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 22.12.2020.
//

import UIKit

class IyzicoTransferVC: BaseVC {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moneyButton: IyzicoButton!
    @IBOutlet weak var moneyButton2: IyzicoButton!
    @IBOutlet weak var moneyButton3: IyzicoButton!
    @IBOutlet weak var moneyButton4: IyzicoButton!
    @IBOutlet weak var tranferableContainerStackView: UIStackView!
    @IBOutlet weak var transferableBalanceTitleLabel: UILabel!
    @IBOutlet weak var transferableBalancePriceLabel: UILabel!
    @IBOutlet weak var iyzicoButton: IyzicoButton!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var containerButtonsView: UIView!
    @IBOutlet weak var transferAllAmountCheckBox: IyzicoCheckBox!
    @IBOutlet weak var amountView: IyzicoAmountView!
    
    var viewModel = TransferVM()
    var vcType: IyzicoTransferVCTypes = .topUp
    var buttons:[IyzicoButton] = []

    convenience init(vcType: IyzicoTransferVCTypes) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.IyzicoTransferVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseDelegate = self
        setUpUI()
        initializeEvents()
        
    }
    
    @IBAction func transferAllAmountButtonTapped(_ sender: Any) {
        transferAllAmountButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalances()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseDelegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavBar(balanceContainerViewVisibility: true, closeButtonType: .cancel)
        amountView.naturalNumberTextField.becomeFirstResponder()
        amountView.setCursorPosition(position: amountView.getCommaLocation() - 1)
    }
}

// MARK: - ACTION
extension IyzicoTransferVC: IyzicoCheckBoxDelegate {
    func didTappedCheckBox(_ selected: Bool) {
        
    }
    
    fileprivate func buttonActions() {
        moneyButton.didTappedButton = { [unowned self] in
            selectedButton(button: moneyButton)
            updateAmount(amount: moneyButton.button.titleLabel?.text?.addDecimalDefaultNumber ?? "")
            amountView.setupPlaceholderColor(isByRange: true)
            handleKeyboardButtonVisibility()
        }
        moneyButton2.didTappedButton = { [unowned self] in
            selectedButton(button: moneyButton2)
            updateAmount(amount: moneyButton2.button.titleLabel?.text?.addDecimalDefaultNumber ?? "")
            amountView.setupPlaceholderColor(isByRange: true)
            handleKeyboardButtonVisibility()
        }
        moneyButton3.didTappedButton = { [unowned self] in
            selectedButton(button: moneyButton3)
            updateAmount(amount: moneyButton3.button.titleLabel?.text?.addDecimalDefaultNumber ?? "")
            amountView.setupPlaceholderColor(isByRange: true)
            handleKeyboardButtonVisibility()
        }
        moneyButton4.didTappedButton = { [unowned self] in
            selectedButton(button: moneyButton4)
            updateAmount(amount: moneyButton4.button.titleLabel?.text?.addDecimalDefaultNumber ?? "")
            amountView.setupPlaceholderColor(isByRange: true)
            handleKeyboardButtonVisibility()
        }
        
    }
    
    @IBAction func didTappedSwitch(_ sender: Any) {
        let sender = sender as! UISwitch
        print(sender.isOn)
    }
    
    private func transferAllAmountButtonAction() {
        transferAllAmountCheckBox.isSelected.toggle()
        transferAllAmountCheckBox.setSelected()
        let defaultAmount = StringConstant.shared.iyzicoTransferVCDefaultAmount
        let priceText = transferAllAmountCheckBox.isSelected ? (transferableBalancePriceLabel.text ?? defaultAmount) : defaultAmount
        updateAmount(amount: priceText)
        amountView.changePriceFormatBeforeComma(isDeliveryBalance: true)
        if transferAllAmountCheckBox.isSelected {
            view.endEditing(true)
        }
        checkAmountInputValidation(text: amountView.naturalNumberTextField.text,
                                   afterCommaText: amountView.getAfterCommaText())
    }
}

 // MARK: - SETUP
extension IyzicoTransferVC {
    fileprivate func setUpUI() {
        baseDelegate = self
        setUpAmountLabel()
        setUpButtons()
        setUpIyzicoButton()
        setupTransferableBalanceTitleLabel()
        setupTransferableBalancePriceLabel()
        setupForVcType()
        setupTransferAllAmountCheckBox()
        setupAmountView()
        setupKeyboardButton()
    }
    
    private func setupForVcType() {
        switch vcType {
        case .cashout:
            bottomContainerView.isHidden = false
            iyzicoButton.button.setTitle(StringConstant.shared.iyzicoTransferVCIyzicoButtonCashoutTitle, for: .normal)
        case .topUp:
            bottomContainerView.isHidden = true
            iyzicoButton.button.setTitle(StringConstant.shared.iyzicoTransferVCIyzicoButtonTopUpTitle, for: .normal)
        }
    }
    
    fileprivate func setUpAmountLabel() {
        amountLabel.font = .markPro14
        amountLabel.textColor = .darkGrey
        amountLabel.text = SDKManager.flow == .topUp ? StringConstant.shared.iyzicoTransferVCAmountTitle : StringConstant.shared.iyzicoTransferVCCashoutTitle
    }
    
    fileprivate func setUpButtons() {
        if SDKManager.flow == .cashout {
            containerButtonsView.isHidden = true
        }
        let cornerRadius = Constant.shared.iyzicoButtonCornerRadius20
        moneyButton.setUp(buttonType: .amount(state: .normal), title: "₺20", cornerRadius: cornerRadius)
        moneyButton2.setUp(buttonType: .amount(state: .normal), title: "₺50", cornerRadius: cornerRadius)
        moneyButton3.setUp(buttonType: .amount(state: .normal), title: "₺100", cornerRadius: cornerRadius)
        moneyButton4.setUp(buttonType: .amount(state: .normal), title: "₺250", cornerRadius: cornerRadius)
        buttons =  [moneyButton, moneyButton2, moneyButton3, moneyButton4]
        buttonActions()
    }
    
    fileprivate func selectedButton(button: IyzicoButton) {
        for btn in buttons {
            if btn == button {
                button.setSelectedUI(borderColor: .clearBlue3, titleColor: .clearBlue3)
                iyzicoButton.setUp(buttonType: .primaryLvl1(state: .normal), title: StringConstant.shared.iyzicoTransferVCIyzicoButtonTopUpTitle)
            } else {
                btn.deSelectedUI(borderColor: .blueGrey, titleColor: .blueGrey)
            }
        }
    }
    fileprivate func removeAllSelectedButton() {
        buttons.forEach { (btn) in
            btn.deSelectedUI(borderColor: .blueGrey, titleColor: .blueGrey)
        }
    }
    
    fileprivate func setUpIyzicoButton() {
        iyzicoButton.setUp(buttonType: .primaryLvl1(state: .passive), title:
                            SDKManager.flow == .topUp ? StringConstant.shared.iyzicoTransferVCIyzicoButtonTopUpTitle : StringConstant.shared.iyzicoTransferVCIyzicoButtonCashoutTitle)
    }
    
    private func setupTransferableBalanceTitleLabel() {
        transferableBalanceTitleLabel.text = StringConstant.shared.iyzicoTransferVCTransferTitle
        transferableBalanceTitleLabel.font = .markPro14
        transferableBalanceTitleLabel.textColor = .darkGrey
    }
    
    private func setupTransferableBalancePriceLabel() {
        #warning("price")
        transferableBalancePriceLabel.text = SDKManager.walletPrice?.addTLWithAlignment(alignment: .left)
        transferableBalancePriceLabel.font = .markProBold14
        transferableBalancePriceLabel.textColor = .darkGrey
    }
    
    private func setupTransferAllAmountCheckBox() {
        transferAllAmountCheckBox.delegate = self
        transferAllAmountCheckBox.borderColor = UIColor.silverTwo.cgColor
        transferAllAmountCheckBox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
        transferAllAmountCheckBox.cornerRadius = Constant.shared.defaultCheckBoxCornerRadius
        transferAllAmountCheckBox.checkBoxType = .check
    }
    
    private func setupAmountView() {
        amountView.delegate = self

    }
    
    private func setupKeyboardButton() {
        addIyzicoButtonAboveKeyboard(buttonType: .primaryLvl1(state: .passive), title:
                                                SDKManager.flow == .topUp ? StringConstant.shared.iyzicoTransferVCIyzicoButtonTopUpTitle : StringConstant.shared.iyzicoTransferVCIyzicoButtonCashoutTitle)
    }
}

//MARK: - IyzicoAmountView Delegate
extension IyzicoTransferVC: IyzicoAmountViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func shouldChangeCharactersIn(_ textField: UITextField) {
        removeAllSelectedButton()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        checkAmountInputValidation(text: textField.text, afterCommaText: amountView.getAfterCommaText())
        removeAllSelectedButton()
        checkTransferAllAmountCheckBoxSelected()
    }
}

//MARK: - Helper Methods
extension IyzicoTransferVC {
    private func initializeEvents() {
        iyzicoButton.didTappedButton = { [unowned self] in
            self.iyzicoButtonAction()
        }
    }
    
    private func iyzicoButtonAction() {
        switch SDKManager.flow {
        case .cashout:
            viewModel.getCashoutComplete(amount: amountView.naturalNumberTextField.text?.serviceAmountFormatAsString,
            onSuccess: { [weak self] (response: CashoutCompleteResponseModel?) in
                guard let validatedDepositStatus = response?.depositStatus else { return }
                if validatedDepositStatus == .WAITING_FOR_PROVISION {
                    self?.navigateToWaitingResultVC(message: validatedDepositStatus.rawValue, amount: self?.amountView.naturalNumberTextField.text?.serviceAmountFormatAsString)
                }
                else {
                    self?.navigateToSuccessResultVC(message: validatedDepositStatus.rawValue, amount: self?.amountView.naturalNumberTextField.text?.serviceAmountFormatAsString)
                }
            },
            onFailure: { [weak self] (errorDescription, networkStatusType) in
                if networkStatusType == .responseFailure {
                    self?.navigateToErrorResultVC()
                }
                else {
                    self?.showError(errorDescription: errorDescription)
                }
            })
        case .topUp:
            navigateToIyzicoHomeVC()
        default: break
        }
    }
    
    private func updateAmount(amount: String) {
        amountView.naturalNumberTextField.text = amount
    }
    
    private func checkAmountInputValidation(text: String?, afterCommaText: String) {
        let keyboardButton = amountView.naturalNumberTextField.inputAccessoryView as? IyzicoButton
        if !ValidationManager.amountValidation(amount: text,
                                            afterCommaText: amountView.getAfterCommaText()) {
            keyboardButton?.makePassive()
            self.iyzicoButton.makePassive()
        } else {
            keyboardButton?.makeActive()
            self.iyzicoButton.makeActive()
        }
    }
    
    private func handleKeyboardButtonVisibility() {
        if let button = amountView.naturalNumberTextField.inputAccessoryView as? IyzicoButton {
            button.makeActive()
        }
    }
    
    private func checkTransferAllAmountCheckBoxSelected() {
        if transferableBalancePriceLabel.text != amountView.naturalNumberTextField.text {
            transferAllAmountCheckBox.deSelect()
        }
        else {
            transferAllAmountCheckBox.select()
        }
    }
    
    private func navigateToSuccessResultVC(message: String?, amount: String?) {
        let vc = ResultVC(vcType: .cashoutSuccess)
        vc.amount = amount
        vc.message = message
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToWaitingResultVC(message: String?, amount: String?) {
        let vc = ResultVC(vcType: .cashoutWaiting)
        vc.amount = amount
        vc.message = message
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToErrorResultVC() {
        navigationController?.pushViewController(ResultVC(vcType: .error), animated: true)
    }
    
    private func navigateToIyzicoHomeVC() {
        let vc = IyzicoHomeVC(vcType: .topUp)
        vc.iyzicoHomeVM.priceForLoad = amountView.naturalNumberTextField.text
        vc.iyzicoHomeVM.navigatedInitResponse = viewModel.navigatedInitializeResponse
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Service Calls
extension IyzicoTransferVC {
    private func getBalances() {
        NotificationCenter.default.post(name: .getBalances, object: nil)
    }
}

extension IyzicoTransferVC: BaseVCDelegate {
    func didTappedButtonOnKeyboard() {
        iyzicoButtonAction()
    }
}
