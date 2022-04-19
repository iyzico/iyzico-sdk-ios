//
//  NewMemberVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

class NewMemberVC: BaseVC, BaseVCDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var infoView: IyzicoTermAndCond!
    @IBOutlet weak var secondInfoView: IyzicoTermAndCond!
    @IBOutlet weak var continueButton: IyzicoButton!
    @IBOutlet weak var emailTextInputView: IyzicoTextInput! {
        didSet {
            emailTextInputView.textField.autocorrectionType = .no
            emailTextInputView.textFieldDidBeginEditing = { [unowned self] text in
//                self.continueButton.isHidden = true
                if let button = emailTextInputView.textField.inputAccessoryView as? IyzicoButton {
                    showButton(button: button)
                }
            }
            emailTextInputView.textFieldDidEndEditing = { [unowned self] text in
                if text == "" {
                    self.emailTextInputView.showError(text: "Email zorunlu")
                }
//                else if ValidationManager.validate(text: emailTextInputView.textField.text, regexType: .email) {
//                    self.emailTextInputView.showError(text: "Email hatalı")
//                }
            }
            emailTextInputView.textFieldDidChange = { [unowned self] text in
                if let button = emailTextInputView.textField.inputAccessoryView as? IyzicoButton {
                    showButton(button: button)
                }
                self.setUserChangedEmailAddress()
            }
        }
    }
    @IBOutlet weak var phoneTextInputView: IyzicoTextInput! {
        didSet {
            phoneTextInputView.textField.autocorrectionType = .no
            phoneTextInputView.textFieldDidBeginEditing = { [unowned self] text in
//                self.continueButton.isHidden = true
                if let button = phoneTextInputView.textField.inputAccessoryView as? IyzicoButton {
                    showButton(button: button)
                }
            }
            phoneTextInputView.textFieldDidEndEditing = { [unowned self] text in
                if text == StringConstant.shared.defaultPhoneCode {
                    self.phoneTextInputView.showError(text: "Telefon zorunlu")
                }
//                else if ValidationManager.validate(text: phoneTextInputView.textField.text, regexType: .phone) {
//                    self.phoneTextInputView.showError(text: "Telefon hatalı")
//                }
            }
            phoneTextInputView.textFieldDidChange = { [unowned self] text in
                if let button = phoneTextInputView.textField.inputAccessoryView as? IyzicoButton {
                    showButton(button: button)
                }
                self.setUserChangedPhoneNumber(text: text)
            }
        }
    }
    
    private typealias constants = StringConstant.NewMemberVCConstants
    var vcType: IyzicoFlowType = .payWithIyzico
    var viewModel = NewMemberVM()
    
    convenience init(vcType: IyzicoFlowType) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.NewMemberVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIForVcType()
        baseDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        focusEmailTextInput()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseDelegate = nil
    }
    //MARK: - Events
    private func initializeEvents() {
        infoView.didTappedTextView = { [unowned self] _ in
            let vc = EmailSupportVC(title: StringConstant.EmailSupportVCConstants.title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        secondInfoView.didTappedTextView = { [unowned self] text in
            if text == "kvkkAgreements" {
                self.navigationController?.pushViewController(WebVC(vcType: .kvkkAgreement), animated: true)
            }
            else {
                self.navigationController?.pushViewController(WebVC(vcType: .boundsAgreement), animated: true)
            }
        }
        
        continueButton.didTappedButton = { [unowned self] in
            if vcType == .payWithIyzico || vcType == .topUp  || vcType == .cashout {
                if isEmailValid() {
                    self.chooseInitializeService()
                }
            } else {
                if isTextFieldsValid() {
                    self.chooseInitializeService()
                }
            }
            
        }
        
        addIyzicoButtonAboveKeyboard(buttonType: .primaryLvl1(state: .normal),title: StringConstant.shared.continueButtonTitle)
    }
    
    func didTappedChangePhoneButton() {
        emailTextInputView.makeDisable()
        phoneTextInputView.textField.becomeFirstResponder()
    }
    
    func didTappedButtonOnKeyboard() {
        if vcType == .payWithIyzico || vcType == .topUp || vcType == .cashout {
            if isEmailValid() {
                self.chooseInitializeService()
            }
        } else {
            if isTextFieldsValid() {
                self.chooseInitializeService()
            }
        }
    }
    
    private func focusEmailTextInput() {
        if vcType == .payWithIyzico || vcType == .topUp || vcType == .cashout {
            emailTextInputView.textField.becomeFirstResponder()
        }
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        baseDelegate = self
        setupScrollView()
        setupTitleLabel()
        setupTitleDescriptionLabel()
        setupEmailTextInputView()
        setupPhoneTextInputView()
        setupInfoView()
        setupSecondInfoView()
        setupContinueButton()
    }
    
    private func setupUIForVcType() {
        switch vcType {
        case .topUp:
            configureNavBar(closeButtonType: .cancel)
            infoView.isHidden = true
            phoneTextInputView.isHidden = true
        
            checkForUserNavigatedFromOTP()
        case .settlement:
            configureNavBar(closeButtonType: .cancel)
            emailTextInputView.makeDisable()
        case .refund:
            configureNavBar(closeButtonType: .cancel)
            emailTextInputView.makeDisable()
        case .cashout:
            configureNavBar(closeButtonType: .cancel)
            emailTextInputView.makeDisable()
            phoneTextInputView.isHidden = true
        case .payWithIyzico:
            configureNavBar(navBarBottomViewVisibility: true,
                            timerStackViewVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
            infoView.isHidden = true
            phoneTextInputView.isHidden = true
            checkForUserNavigatedFromOTP()
        }
    }
    
    private func setupScrollView() {
        baseScrollView = scrollView
        scrollView.delegate = self
    }
    
    private func setupTitleLabel() {
        titleLabel.text = constants.titleLabelText
        titleLabel.font = .markProBold20
    }
    
    private func setupTitleDescriptionLabel() {
        titleDescriptionLabel.text = constants.titleDescriptionLabelText
        titleDescriptionLabel.font = .markPro14
    }
    
    private func setupEmailTextInputView() {
        emailTextInputView.textViewSetup(textInputType: .text, title: constants.emailTextInputViewTitle)
        emailTextInputView.textField.text = SDKManager.email
        emailTextInputView.configureTextInputLayout(shouldTitleStackViewVisible: true, placeholder: StringConstant.shared.emailPlaceHolder)
    }
    
    private func setupPhoneTextInputView() {
        phoneTextInputView.phoneViewSetup(textInputType: .phone, title: constants.phoneTextInputViewTitle)
        phoneTextInputView.textField.text = SDKManager.phone
        phoneTextInputView.configureTextInputLayout(shouldTitleStackViewVisible: true, placeholder: StringConstant.shared.phonePlaceHolder)
    }
    
    private func setupInfoView() {
        infoView.setUpTermView(title: constants.infoViewText,
                               highlightedTexts: [constants.infoViewHighlightedText],
                               plainFont: .markProMedium12,
                               linkNames: ["otherMailAddress"],
                               highletedFont: .markProMedium12,
                               alignment: .left)
        infoView.checkBoxisEnable = false
        infoView.switchisEnable = false
        infoView.infoImageView.image =  Asset.iconInfo.image
        infoView.termTextView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
    }
    
    private func setupSecondInfoView() {
        secondInfoView.setUpTermView(title: constants.secondInfoViewText,
                                     highlightedTexts: [constants.kvkkHighlightedText],
                                     plainFont: .markPro14,
                                     linkNames: ["kvkkAgreements"],
                                     highletedFont: .markProBold14,
                                     alignment: .center)
        secondInfoView.isInfoImageViewEnable = false
        secondInfoView.checkBoxisEnable = false
        secondInfoView.switchisEnable = false
        secondInfoView.infoImageView.image = Asset.iconInfo.image
    }
    
    private func setupContinueButton() {
        if isTextFieldsValid() {
            continueButton.setUp(buttonType: .primaryLvl1(state: .normal), title: constants.continueButtonTitle)
        } else {
            continueButton.setUp(buttonType: .primaryLvl1(state: .passive), title: constants.continueButtonTitle)
        }
    }
    
    private func pushtoNotaMemberVC() {
        let vc = NotaMemberVC()
        SDKManager.email = emailTextInputView.textField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Helper Methods
    private func configureTextInputViewsVisibility(emailTextInputViewVisibility: Bool, phoneTextInputViewVisibility: Bool) {
        emailTextInputView.isHidden = !emailTextInputViewVisibility
        phoneTextInputView.isHidden = !phoneTextInputViewVisibility
    }
    
    private func navigateToOtpVC(isGsmVerified: Bool?) {
        let vc = OTPVC()
        vc.viewModel.isGsmVerified = isGsmVerified
        vc.viewModel.navigatedPhoneNumber = viewModel.loginInitializeResponse?.gsmNumber
        vc.viewModel.navigatedGsmUpdateResponse = viewModel.gsmUpdateResponse
        vc.viewModel.navigatedLoginInitializeResponse = viewModel.loginInitializeResponse
        vc.viewModel.navigatedRegisterInitializeResponse = viewModel.registerInitializeResponse
        vc.viewModel.navigatedInitializeResponse = viewModel.initializeResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func isTextFieldsValid() -> Bool {
        let isEmailValid = ValidationManager.validate(text: emailTextInputView.textField.text, regexType: .email)
        let isPhoneValid = ValidationManager.validate(text: phoneTextInputView.textField.text, regexType: .phone)
        return isEmailValid && isPhoneValid
    }
    
    private func isEmailValid() -> Bool {
        let isEmailValid = ValidationManager.validate(text: emailTextInputView.textField.text, regexType: .email)
        return isEmailValid
    }
    
    private func showButton(button: IyzicoButton? = nil) {
        self.continueButton.isHidden = false
        if isTextFieldsValid() {
            continueButton.makeActive()
            button?.makeActive()
        } else {
            continueButton.makePassive()
            button?.makePassive()
        }
    }
    
    private func chooseInitializeService() {
        switch SDKManager.flow {
            case .topUp:
                getTopUpInitialize()
            case .payWithIyzico:
                getPWIInitialize()
            default:
                getCashoutInitialize()
        }
    }
    
    private func chooseAuthenticationService(isMemberExist: Bool?) {
        guard let validatedIsMemberExist = isMemberExist else { return }
        if validatedIsMemberExist {
            getLoginInitialize(shouldShowLoading: false)
        }
        else {
            if vcType == .payWithIyzico || vcType == .topUp || vcType == .cashout {
                hideLoading()
                pushtoNotaMemberVC()
            } else {
                getRegisterInitialize(shouldShowLoading: false)
            }
          
        }
    }
    
    private func setUserChangedEmailAddress() {
        viewModel.isUserChangedEmailAddress = SDKManager.email != emailTextInputView.textField.text
        SDKManager.PWIrequest.buyer?.email = emailTextInputView.textField.text
    }
    
    private func setUserChangedPhoneNumber(text: String?) {
        if phoneTextInputView.textField.text != SDKManager.phone?.addWhitespacesToPhone {
            self.viewModel.isPhoneNumberChanged = true
        }
        else {
            self.viewModel.isPhoneNumberChanged = false
        }
        SDKManager.PWIrequest.buyer?.gsmNumber = phoneTextInputView.textField.text?.removeWhiteSpaces
    }
    
    private func checkGsmVerified(isGsmVerified: Bool?) {
        let validatedIsGsmVerified = isGsmVerified ?? false
        if validatedIsGsmVerified || viewModel.isPhoneNumberChanged == false {
            self.navigateToOtpVC(isGsmVerified: validatedIsGsmVerified)
        }
        else {
            getGsmUpdate(
            onSuccess: { [weak self] (response: GsmUpdateResponseModel?) in
                self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
            })
        }
    }
    
    private func checkForUserNavigatedFromOTP() {
        if viewModel.isUserNavigatedFromOTP {
            emailTextInputView.makeDisable()
            emailTextInputView.textField.becomeFirstResponder()
            viewModel.isPhoneNumberChanged = false
        }
    }
    
    private func changeSDKInitializeValues() {
        SDKManager.email = emailTextInputView.textField.text
        SDKManager.phone = viewModel.loginInitializeResponse?.gsmNumber
    }
    
    //MARK: - Service Calls
    private func getGsmUpdate(onSuccess: @escaping (GsmUpdateResponseModel?) -> Void) {
        viewModel.getGsmUpdate(phone: phoneTextInputView.textField.text,
                               shouldShowLoading: false,
        onSuccess: { (response: GsmUpdateResponseModel?) in
            onSuccess(response)
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        })
    }
    
    private func getLoginInitialize(shouldShowLoading: Bool) {
        #warning("Change in prod")
        viewModel.getLoginInitialize(email: emailTextInputView.textField.text,
                                     clientIp: SDKManager.clientIp,
                                     loginChannel: "THIRD_PARTY_APP",
                                     shouldShowLoading: shouldShowLoading,
        onSuccess: { [weak self] (response: QuickLoginInitializeResponseModel?) in
            self?.changeSDKInitializeValues()
            self?.checkGsmVerified(isGsmVerified: response?.gsmVerified)
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
        })
    }
    
    private func getRegisterInitialize(shouldShowLoading: Bool) {
        #warning("Change in prod")
        viewModel.getRegisterInitialize(name: SDKManager.name,
                                        surname: SDKManager.surname,
                                        email: emailTextInputView.textField.text,
                                        phoneNumber: phoneTextInputView.textField.text?.servicePhoneNumberFormat,
                                        registerChannel: "THIRD_PARTY_APP",
                                        shouldShowLoading: shouldShowLoading,
        onSuccess: { [weak self] (response: QuickRegisterInitializeResponseModel?) in
            self?.changeSDKInitializeValues()
            self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
        }, onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
        })
    }
    
    private func getCashoutInitialize() {
        #warning("Change in prod")
        viewModel.getCashoutInitialize(email: emailTextInputView.textField.text,
                                       amount: "₺50000,00".serviceAmountFormatAsString,
                                       currencyType: "TRY",
                                       shouldHideLoading: false,
        onSuccess: { [weak self] (response: InitResponseModel?) in
            self?.chooseAuthenticationService(isMemberExist: response?.memberExist)
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
        })
    }

    private func getTopUpInitialize() {
        viewModel.getTopUpInitialize(email: emailTextInputView.textField.text,
                                     transactionType: .DEPOSIT,
                                     shouldHideLoading: false,
        onSuccess: { [weak self] (response: InitResponseModel?) in
            self?.chooseAuthenticationService(isMemberExist: response?.memberExist)
        },
        onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        })
    }
    
    private func getPWIInitialize() {
        viewModel.getPWIInitialize(request: SDKManager.PWIrequest,
                                   shouldHideLoading: false,
                                   onSuccess: { [weak self] (response: InitResponseModel?) in
                                    self?.chooseAuthenticationService(isMemberExist: response?.memberExist)
                                   },
                                   onFailure: { [weak self] errorDescription in
                                    self?.showError(errorDescription: errorDescription)
                                   })
    }
}
