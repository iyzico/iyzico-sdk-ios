//
//  OTPVC.swift
//  iyzi-co-testApp
//
//  Created by Tolga İskender on 19.12.2020.
//

import UIKit

class OTPVC: BaseVC {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var changePhoneButton: UIButton!
    @IBOutlet weak var smsSendedContainerStackView: UIStackView!
    @IBOutlet weak var smsSendedImageView: UIImageView!
    @IBOutlet weak var smsSendedDescriptionLabel: UILabel!
    @IBOutlet weak var mobileCodeInputStackView: UIStackView!
    @IBOutlet weak var containerStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput1: IyzicoTextInput! {
        didSet {
            textInput1.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput1.textField.text = text
                guard text.isBackspace != true else {return}
                if self.viewModel.isPasted == false {
                    self.textInput2.textField.becomeFirstResponder()
                }
            }
            textInput1.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var textInput2: IyzicoTextInput! {
        didSet {
          
            textInput2.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput2.textField.text = text
                guard text.isBackspace != true else {return}
                if self.viewModel.isPasted == false {
                    self.textInput3.textField.becomeFirstResponder()
                }
            }
            
            textInput2.deleteBackward = { [unowned self] in
                self.textInput1.textField.becomeFirstResponder()
            }
            
            textInput2.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var textInput3: IyzicoTextInput! {
        didSet {
           
            textInput3.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput3.textField.text = text
                guard text.isBackspace != true else {return}
                if self.viewModel.isPasted == false {
                    self.textInput4.textField.becomeFirstResponder()
                }
            }
            
            textInput3.deleteBackward = { [unowned self] in
                self.textInput2.textField.becomeFirstResponder()
            }
            
            textInput3.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var textInput4: IyzicoTextInput! {
        didSet {
            
            textInput4.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput4.textField.text = text
                guard text.isBackspace != true else {return}
                if self.viewModel.isPasted == false {
                    self.textInput5.textField.becomeFirstResponder()
                }
            }
            
            textInput4.deleteBackward = { [unowned self] in
                self.textInput3.textField.becomeFirstResponder()
            }
            
            textInput4.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var textInput5: IyzicoTextInput! {
        didSet {

            textInput5.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput5.textField.text = text
                guard text.isBackspace != true else {return}
                if self.viewModel.isPasted == false {
                    self.textInput6.textField.becomeFirstResponder()
                }
            }
            
            textInput5.deleteBackward = { [unowned self] in
                self.textInput4.textField.becomeFirstResponder()
            }
            
            textInput5.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var textInput6: IyzicoTextInput! {
        didSet {
            
            textInput6.shouldChangeCharactersIn = { [unowned self] text in
                self.textInput6.textField.text = text
                if text.isBackspace != true {
                    self.view.endEditing(true)
                    self.getLoginComplete()
                }
            }
            
            textInput6.deleteBackward = { [unowned self] in
                self.textInput5.textField.becomeFirstResponder()
            }
            
            textInput6.textFieldDidEndEditing = { [unowned self] _ in
                self.checkTextInputs()
            }
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = StringConstant.shared.otpVCSendAgainTitleText
            messageLabel.textColor = .darkGrey
            messageLabel.font = .markPro16
        }
    }
    
    @IBOutlet weak var codeLabel: UILabel! {
        didSet {
            codeLabel.text = StringConstant.shared.otpVCSendAgainCodeText
            codeLabel.textColor = .darkGrey
            codeLabel.font = .markProBold28
        }
    }
    
    @IBOutlet weak var clockImageView: UIImageView! {
        didSet {
            clockImageView.image = Asset.basicClockBlack.image
        }
    }
    
    
    @IBOutlet weak var continueButton: IyzicoButton!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var sendAgainButton: UIButton!
    
    var viewModel = OTPVM()
    var timer: Timer?
   
    lazy var textInputs = [textInput1,
                           textInput2,
                           textInput3,
                           textInput4,
                           textInput5,
                           textInput6]
    
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.otpVC, bundle: bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        initializeEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUIForVcType()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isSwipeBackEnabled = true
        textInput1.textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isSwipeBackEnabled = false
        customizeForPayWithIyzico()
    }
}
 // MARK: - Action
extension OTPVC {
    
    @IBAction func didTappedSendAgainButton(_ sender: Any) {
        getResendSms()
    }
    
    @IBAction func didTappedChangePhoneButton(_ sender: Any) {
//        switch SDKManager.flow {
//        case .topUp, .payWithIyzico:
//            navigateToNewMemberVC()
//        case .settlement, .refund, .cashout:
//            openSupportPage()
//        }
        if viewModel.changeButtonType == .change {
            navigateToNewMemberVC()
        }
        else {
            openSupportPage()
        }
    }
    
    private func initializeEvents() {
        continueButton.didTappedButton = { [unowned self] in
            self.getLoginComplete()
        }
        
        textInputs.forEach { textInput in
            textInput?.didPastedTextAction = { [unowned self] in
                self.pastedText() { [weak self] status in
                    self?.viewModel.isPasted = status
                    if status {
                        self?.getLoginComplete()
                    }
                }
            }
        }
    }
    
    private func pastedText(completionHandler: (Bool) -> Void) {
        let pastedText = UIPasteboard.general.string
        if ValidationManager.otpValidation(text: pastedText ?? "") {
            for (index, textInput) in textInputs.enumerated() {
                textInput?.textField.text = pastedText?[index]
            }
            completionHandler(true)
        }
        else {
            completionHandler(false)
        }
    }
    
    private func continueButtonAction() {
        switch SDKManager.flow {
        case .topUp:
            let vc = IyzicoTransferVC(vcType: .topUp)
            vc.viewModel.navigatedInitializeResponse = viewModel.navigatedInitializeResponse
            navigationController?.pushViewController(vc, animated: true)
        case .settlement:
            navigationController?.pushViewController(SettlementVC(), animated: true)
        case .refund:
            ///TODO - Make control with service
            navigationController?.pushViewController(ResultVC(vcType: .refundSuccess), animated: true)
        case .cashout:
            let vc = IyzicoTransferVC(vcType: .cashout)
            vc.viewModel.navigatedInitializeResponse = viewModel.navigatedInitializeResponse
            navigationController?.pushViewController(vc, animated: true)
        case .payWithIyzico:
           let vc = IyzicoHomeVC(vcType: .payWithIyzico)
            vc.iyzicoHomeVM.navigatedInitializeResponse = viewModel.navigatedInitializeResponse
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    func customizeForPayWithIyzico() {
        if SDKManager.flow == .payWithIyzico {
            let userInfo: [String : Bool] = [ "isHidden": false]
            NotificationCenter.default.post(name: .hideBottomBar,
                                            object: nil,
                                            userInfo: userInfo)
        }
    }
}
// MARK: - SETUP
extension OTPVC {
    
    fileprivate func setUpVC() {
        setUpContentImageView()
        setUpPhoneLabel()
        setUpChangePhoneButton()
        setUpTextInput()
        setUpCountDownLabel()
        startCountDown()
        setUpSendAgainButton()
        setUpContinueButton()
        setupSmsSendedContainerStackView()
        setupSmsSendedImageView()
        setupSmsSendedDescriptionLabel()
//        setupChangePhoneButtonVisibility(isGsmVerified: viewModel.isGsmVerified)
    }
    
    fileprivate func setUpContentImageView() {
        contentImageView.image = Asset.verifyNumber.image
    }
    
    fileprivate func setUpPhoneLabel() {
        phoneLabel.font = .markProMedium14
        phoneLabel.textColor = .blueGrey
        phoneLabel.text = viewModel.getMaskedPhoneText()
//        phoneLabel.securePhoneText(number: viewModel.navigatedPhoneNumber ?? "")
    }
    
    fileprivate func setUpChangePhoneButton() {
        changePhoneButton.titleLabel?.font = .markProBold12
        changePhoneButton.setTitleColor(.clearBlue, for: .normal)
//        switch SDKManager.flow {
//        case .topUp, .payWithIyzico:
//            changePhoneButton.setTitle(StringConstant.shared.otpVCChangePhoneButtonTitle, for: .normal)
//        case .settlement, .refund, .cashout:
//            changePhoneButton.setTitle(StringConstant.shared.otpVCSupportButtonTitle, for: .normal)
//        }
        if viewModel.changeButtonType == .change {
            changePhoneButton.setTitle(StringConstant.shared.otpVCChangePhoneButtonTitle, for: .normal)
        }
        else {
            changePhoneButton.setTitle(StringConstant.shared.otpVCSupportButtonTitle, for: .normal)
        }
    }
    
    fileprivate func setUpTextInput() {
        textInput1.numberViewSetup()
        textInput2.numberViewSetup()
        textInput3.numberViewSetup()
        textInput4.numberViewSetup()
        textInput5.numberViewSetup()
        textInput6.numberViewSetup()
    }
    
    fileprivate func setUpCountDownLabel() {
        countDownLabel.font = .markProBold14
        countDownLabel.textColor = .darkGrey
    }
    
    fileprivate func setUpSendAgainButton() {
        sendAgainButton.setTitle(StringConstant.shared.otpVCSendAgainButtonTitle, for: .normal)
        sendAgainButton.setImage(Asset.refreshBlue.image, for: .normal)
        sendAgainButton.titleLabel?.font = .markProBold12
        sendAgainButton.setTitleColor(.clearBlue, for: .normal)
        sendAgainButton.imageEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: Constant.shared.otpVCButtonImageRightInset)
        sendAgainButton.titleEdgeInsets = UIEdgeInsets(top: .zero, left: Constant.shared.otpVCButtonTitleLeftInset, bottom: .zero, right: .zero)
    }
    
    fileprivate func setUpContinueButton() {
        continueButton.setUp(buttonType: .primaryLvl1(state: .passive),title: StringConstant.shared.continueButtonTitle)
    }
    
    private func setupSmsSendedContainerStackView() {
        smsSendedContainerStackView.isHidden = true
    }
    
    private func setupSmsSendedImageView() {
        smsSendedImageView.image = Asset.sendedIcon.image
    }
    
    private func setupSmsSendedDescriptionLabel() {
        smsSendedDescriptionLabel.text = StringConstant.shared.otpVCSmsSendedText
        smsSendedDescriptionLabel.font = .markProMedium14
        smsSendedDescriptionLabel.textColor = .mediumGreenTwo
    }
    
    fileprivate func openSupportPage() {
        let vc = EmailSupportVC(title: StringConstant.EmailSupportVCConstants.title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func checkTextInputs() {
        let isValid = ValidationManager.checkValidation(inputs: [textInput1,
                                                          textInput2,
                                                          textInput3,
                                                          textInput4,
                                                          textInput5,
                                                          textInput6])
        if isValid {
            continueButton.setUp(buttonType: .primaryLvl1(state: .normal),title: StringConstant.shared.continueButtonTitle)
        } else {
            continueButton.setUp(buttonType: .primaryLvl1(state: .passive),title: StringConstant.shared.continueButtonTitle)
        }
    }
    
    private func setupUIForVcType() {
        if SDKManager.flow == .payWithIyzico {
            configureNavBar(navBarBottomViewVisibility: true,
                            timerStackViewVisibility: true,
                            backButtonVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
        }
        else {
            configureNavBar(backButtonVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
            containerStackViewHeightConstraint.constant = 88
        }
    }
    
    private func configureSmsSendedView() {
        sendAgainButton.isHidden = true
        smsSendedContainerStackView.isHidden = false
    }
    
//    private func setupChangePhoneButtonVisibility(isGsmVerified: Bool?) {
//        if SDKManager.flow == .payWithIyzico || SDKManager.flow == .topUp {
//            changePhoneButton.isHidden = isGsmVerified ?? true
//        }
//    }
}

//MARK: - Helper Methods
extension OTPVC {
    private func startCountDown() {
        timer?.invalidate()
        
        sendAgainButton.isHidden = true
        clockImageView.image = Asset.basicClockBlack.image
        
        //Count down logic
        self.timer = countDownLabel.startTimerWithReturn(time: Constant.shared.otpVCSecond) { [weak self] second in
            if second == Constant.shared.otpVCSecond - Constant.shared.tryAgainButtonVisibilityByTime {
                self?.sendAgainButton.isHidden = false
                self?.smsSendedContainerStackView.isHidden = true
            }
            else if second == Constant.shared.invalidateTimer {
                self?.removeTextFieldInputs()
                self?.countDownLabel.textColor = .darkGrey
                self?.startCountDown()
            }
            else if second == Constant.shared.oneMinute {
                self?.clockImageView.image = Asset.basicClock.image
            }
        }
    }
    
    private func getVerificationCode() -> String {
        return [textInput1.textField.text ?? "",
                textInput2.textField.text ?? "",
                textInput3.textField.text ?? "",
                textInput4.textField.text ?? "",
                textInput5.textField.text ?? "",
                textInput6.textField.text ?? ""].joined(separator: "")
    }
    
    private func removeTextFieldInputs() {
        let array = [textInput1.textField,
                     textInput2.textField,
                     textInput3.textField,
                     textInput4.textField,
                     textInput5.textField,
                     textInput6.textField]
        array.forEach { textField in
            textField?.text = ""
        }
        textInput1.textField.becomeFirstResponder()
    }
    
    private func invalidateTimer() {
        if timer != nil {
            timer?.invalidate()
        }
    }
    
    private func navigateToNewMemberVC() {
        if SDKManager.flow == .payWithIyzico || SDKManager.flow == .topUp || SDKManager.flow == .cashout {
            let vc = NotaMemberVC()
            vc.viewModel.isUserNavigatedFromOTP = true
            vc.viewModel.initializeResponse = viewModel.navigatedInitializeResponse
            vc.viewModel.registerInitializeResponse = viewModel.navigatedRegisterInitializeResponse
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = NewMemberVC(vcType: SDKManager.flow)
            vc.viewModel.isUserNavigatedFromOTP = true
            vc.viewModel.initializeResponse = viewModel.navigatedInitializeResponse
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Service Calls
extension OTPVC {
    private func getLoginComplete() {
        #warning("Change in prod")
        self.viewModel.getLoginComplete(verificationCode: getVerificationCode(),
                                        clientIp: SDKManager.clientIp,
                                        loginChannel: "THIRD_PARTY_APP",
        onSuccess: { [weak self] (response: LoginCompleteResponseModel?) in
            self?.continueButtonAction()
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            self?.removeTextFieldInputs()
            Iyzico.delegate?.didOperationFailed(state: .error, message: InternalMessageState.error.message)
        })
    }
    
    private func getResendSms() {
        #warning("Change in prod")
        switch SDKManager.flow {
        case .cashout, .payWithIyzico, .topUp:
            viewModel.getResendSms(
            onSuccess: { [weak self] (response: QuickLoginInitializeResponseModel?) in
                self?.startCountDown()
                self?.configureSmsSendedView()
            }, onFailure: { [weak self] errorDescription in
                self?.showError(errorDescription: errorDescription)
                Iyzico.delegate?.didOperationFailed(state: .error, message: InternalMessageState.error.message)
            })
        default:
            break
        }
    }
}
