//
//  NotaMemberVC.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 26.08.2021.
//

import UIKit

class NotaMemberVC: BaseVC {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var inputContentView: UIView!
    @IBOutlet weak var emailTextField: IyzicoTextInput!
    @IBOutlet weak var phoneTextField: IyzicoTextInput! {
        didSet {
            phoneTextField.textField.autocorrectionType = .no
            phoneTextField.textFieldDidBeginEditing = {  _ in

            }
            phoneTextField.textFieldDidEndEditing = { [unowned self] text in
                if text == StringConstant.shared.defaultPhoneCode {
                    self.phoneTextField.showError(text: "Telefon zorunlu")
                }
            }
            phoneTextField.textFieldDidChange = { [unowned self] _ in
                if self.isValidPhone() {
                    self.continueButton.makeActive()
                } else {
                    self.continueButton.makePassive()
                }
            }
        }
    }
    @IBOutlet weak var termStackView: UIStackView! {
        didSet {
            termStackView.setCustomSpacing(.zero, after: contactView)
            termStackView.setCustomSpacing(.zero, after: kvkkView)
            termStackView.setCustomSpacing(.zero, after: agreementView)
        }
    }
    @IBOutlet weak var continueButton: IyzicoButton!
    @IBOutlet weak var contactView: IyzicoTermAndCond!
    @IBOutlet weak var kvkkView: IyzicoTermAndCond!
    @IBOutlet weak var agreementContentView: UIView!
    @IBOutlet weak var agreementView: IyzicoTermAndCond!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    private typealias constants = StringConstant.NewMemberVCConstants
    private typealias notaMemberConstants = StringConstant.NotaMemberVCConstants
    var viewModel = NewMemberVM()
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.notaMemberVC, bundle: bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SDKManager.flow == .topUp || SDKManager.flow == .cashout {
            configureNavBar(navBarBottomViewVisibility: false,
                            timerStackViewVisibility: false,
                            nameLabelTitle: "",
                            closeButtonType: .cancel)
        } else {
            configureNavBar(navBarBottomViewVisibility: true,
                            timerStackViewVisibility: true,
                            nameLabelTitle: SDKManager.brand ?? "",
                            closeButtonType: .cancel)
        }
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if viewModel.isUserNavigatedFromOTP {
           setPhonetoTextfield()
            phoneTextField.textField.becomeFirstResponder()
        }
    }
    
    private func setupUI() {
        setupEmailTextField()
        setupPhoneTextField()
        setupContactView()
        setupKVKKView()
        setupAgreementView()
        setupContinueButton()
        setupErrorLabel()
        contentStackView.setCustomSpacing(.zero, after: termView)
        contentStackView.setCustomSpacing(8, after: inputContentView)
    }
    
    func setPhonetoTextfield() {
        phoneTextField.textField.text = SDKManager.phone
        continueButton.makeActive()
    }
    
}

//MARK:- UI
extension NotaMemberVC {
    
    private func setupEmailTextField() {
        emailTextField.textViewSetup(textInputType: .text, title: constants.emailTextInputViewTitle)
        emailTextField.textField.text = SDKManager.email
        emailTextField.textField.textColor = .gunmetal
        emailTextField.configureTextInputLayout(shouldTitleStackViewVisible: true, placeholder: StringConstant.shared.emailPlaceHolder)
        emailTextField.rightView.isHidden = false
        if SDKManager.flow == .cashout {
            emailTextField.rightButton.isHidden = true
        } else {
            emailTextField.rightButton.isHidden = false
        }
       // emailTextField.rightButton.isHidden = false
        emailTextField.rightButtonTrailingConst.constant = 16
        emailTextField.rightViewWidthConst.constant = 42
        emailTextField.rightButton.setImage(Asset.edit.image, for: .normal)
        emailTextField.makeDisableforEmail()
        
        emailTextField.rightButtonTapped = { [unowned self] in
            guard  let vcs = self.navigationController?.viewControllers  else { return }
            for vc in vcs {
                if vc is NewMemberVC {
                    self.navigationController?.popToViewController(vc,animated:true)
                    break
                }
            }
        }
        
    }
    
    private func setupPhoneTextField() {
        phoneTextField.phoneViewSetup(textInputType: .phone, title: constants.phoneTextInputViewTitle)
        phoneTextField.textField.text = "+90"
        phoneTextField.configureTextInputLayout(shouldTitleStackViewVisible: true, placeholder: StringConstant.shared.phonePlaceHolder)
    }
    
    private func setupContactView() {
        
        contactView.setUpTermView(title: notaMemberConstants.contactPermissionText,
                                  highlightedTexts: [notaMemberConstants.contactPermissionHighlight],
                                  plainFont: .markPro14,
                                  linkNames: ["contact"],
                                  highletedFont: .markProBold14,
                                  alignment: .left)
        contactView.termTextView.textColor = .gunmetal
        contactView.stackViewLeadingConst.constant = 16
        contactView.checkBoxisEnable = true
        contactView.switchisEnable = false
        contactView.isInfoImageViewEnable = false
        contactView.checkBox.borderWidth = 2
        contactView.checkBox.topAnchor.constraint(equalTo: contactView.checkBoxView.layoutMarginsGuide.topAnchor, constant: .zero).isActive = true
        contactView.termTextView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        contactView.didTappedTextView = { [unowned self] text in
            self.navigationController?.pushViewController(WebVC(vcType: .contact), animated: true)
        }
    }
    
    private func setupKVKKView() {
        
        kvkkView.setUpTermView(title: notaMemberConstants.kvkkPermissionText,
                                  highlightedTexts: [notaMemberConstants.kvkkPermissionHighlight],
                                  plainFont: .markPro14,
                                  linkNames: ["kvkk"],
                                  highletedFont: .markProBold14,
                                  alignment: .left)
        kvkkView.termTextView.textColor = .gunmetal
        kvkkView.stackViewLeadingConst.constant = 16
        kvkkView.checkBoxisEnable = true
        kvkkView.switchisEnable = false
        kvkkView.isInfoImageViewEnable = false
        kvkkView.checkBox.borderWidth = 2
        kvkkView.checkBox.topAnchor.constraint(equalTo: kvkkView.checkBoxView.layoutMarginsGuide.topAnchor, constant: .zero).isActive = true
        kvkkView.termTextView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        kvkkView.didTappedTextView = { [unowned self] text in
            self.navigationController?.pushViewController(WebVC(vcType: .kvkk), animated: true)
        }
    }
    
    private func setupAgreementView() {
        
        agreementView.setUpTermView(title: notaMemberConstants.userAgreementPermissionText,
                                  highlightedTexts: [notaMemberConstants.userAgreementPermissionHighlight],
                                  plainFont: .markPro14,
                                  linkNames: ["agreement"],
                                  highletedFont: .markProBold14,
                                  alignment: .left)
        agreementView.termTextView.textColor = .gunmetal
        agreementView.stackViewLeadingConst.constant = 16
        agreementView.checkBoxisEnable = true
        agreementView.switchisEnable = false
        agreementView.isInfoImageViewEnable = false
        agreementView.checkBox.borderWidth = 2
        agreementView.checkBox.delegate = self
        agreementView.checkBox.topAnchor.constraint(equalTo: agreementView.checkBoxView.layoutMarginsGuide.topAnchor, constant: .zero).isActive = true
        agreementView.termTextView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        agreementView.didTappedTextView = { [unowned self] text in
            self.navigationController?.pushViewController(WebVC(vcType: .agreement), animated: true)
        }
    }
    
    private func setupErrorLabel() {
        errorLabel.textColor = .red900
        errorLabel.font = .markProMedium12
        errorLabel.numberOfLines = .zero
        errorLabel.text = notaMemberConstants.userAgreementPermissionErrorText
    }
    
    private func setupContinueButton() {
        continueButton.setUp(buttonType: .primaryLvl1(state: .passive), title: constants.continueButtonTitle)
        continueButton.didTappedButton = { [unowned self] in
            isValid()
        }
    }
    
    private func showError() {
        self.agreementView.checkBox.borderColor = UIColor.red900.cgColor
        self.agreementContentView.backgroundColor = .veryLightPink
        self.errorView.isHidden = false
    }
    
    private func hideError(selected: Bool) {
        self.agreementView.checkBox.borderColor =  selected ? UIColor.green800.cgColor : UIColor.gray400.cgColor
        self.agreementContentView.backgroundColor = .white
        self.errorView.isHidden = true
    }
    
    private func isValidPhone() -> Bool {
        let isPhoneValid = ValidationManager.validate(text: phoneTextField.textField.text, regexType: .phone)
        return isPhoneValid
    }
    private func isAgreementAccepted() -> Bool {
        let isCheckBoxSelected = agreementView.checkBox.isSelected
        return isCheckBoxSelected
    }
    
    private func isValid() {
        if !isValidPhone() && !isAgreementAccepted() {
            self.phoneTextField.showError(text: "Telefon zorunlu")
            showError()
        } else if !isValidPhone() && isAgreementAccepted() {
            self.phoneTextField.showError(text: "Telefon zorunlu")
        } else if isValidPhone() && !isAgreementAccepted() {
            showError()
        } else {
            switch SDKManager.flow {
                case .cashout:
                    getCashoutInitialize()
                case .topUp:
                    getTopUpInitialize()
                case .payWithIyzico:
                    getPWIInitialize()
                default:
                    break
            }
        }
    }
    
    
    private func navigateToOtpVC(isGsmVerified: Bool?) {
        let vc = OTPVC()
        SDKManager.phone = phoneTextField.textField.text
        vc.viewModel.isGsmVerified = isGsmVerified
        vc.viewModel.navigatedGsmUpdateResponse = viewModel.gsmUpdateResponse
        vc.viewModel.navigatedPhoneNumber = phoneTextField.textField.text?.removeWhiteSpaces
        vc.viewModel.navigatedRegisterInitializeResponse = viewModel.registerInitializeResponse
        vc.viewModel.navigatedInitializeResponse = viewModel.initializeResponse
        vc.viewModel.navigatedLoginInitializeResponse = viewModel.loginInitializeResponse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func chooseAuthenticationService() {
        if viewModel.isUserNavigatedFromOTP {
            getGmsUpdate(
                onSuccess: { [weak self] (response: GsmUpdateResponseModel?) in
                    self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
                })
        } else {
            getRegisterInitialize(shouldShowLoading: false)
        }
    }
     
}

//MARK:- CHECKBOX Delegate
extension NotaMemberVC: IyzicoCheckBoxDelegate {
    
    func didTappedCheckBox(_ selected: Bool) {
        hideError(selected: selected)
    }
}

//MARK:- SERVICE
extension NotaMemberVC {
    
    private func changeSDKInitializeValues() {
        SDKManager.phone = phoneTextField.textField.text
    }
    
    private func getRegisterInitialize(shouldShowLoading: Bool) {
        #warning("Change in prod")
        let outlineAgreementStatus = agreementView.checkBox.isSelected ? "ACCEPTED": nil
        let pdppPermission = kvkkView.checkBox.isSelected ? "PERMITTED_ON_REGISTER": nil
        let communicationsPermission = contactView.checkBox.isSelected ? "PERMITTED": nil
        viewModel.getRegisterInitialize(name: SDKManager.name,
                                        surname: SDKManager.surname,
                                        email: emailTextField.textField.text,
                                        phoneNumber: phoneTextField.textField.text?.servicePhoneNumberFormat,
                                        registerChannel: "THIRD_PARTY_APP",
                                        outlineAgreementStatus: outlineAgreementStatus,
                                        pdppPermission: pdppPermission,
                                        communicationsPermission: communicationsPermission,
                                        shouldShowLoading: shouldShowLoading,
                                        onSuccess: { [weak self] (response: QuickRegisterInitializeResponseModel?) in
                                            self?.changeSDKInitializeValues()
                                            self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
                                        }, onFailure: { [weak self] errorDescription in
                                            self?.showError(errorDescription: errorDescription)
                                            Iyzico.delegate?.didOperationFailed(state: .error, message: InternalMessageState.error.message)
                                        })
    }
    
    private func getGmsUpdate(onSuccess: @escaping (GsmUpdateResponseModel?) -> Void) {
        viewModel.getGsmUpdate(phone: phoneTextField.textField.text,
                               shouldShowLoading: false,
                               onSuccess: { (response: GsmUpdateResponseModel?) in
                                onSuccess(response)
                               },
                               onFailure: { [weak self] errorDescription in
                                self?.showError(errorDescription: errorDescription)
                               })
    }
    
    private func getPWIInitialize() {
        SDKManager.PWIrequest.buyer?.gsmNumber = phoneTextField.textField.text?.removeWhiteSpaces
        viewModel.getPWIInitialize(request: SDKManager.PWIrequest,
                                   onSuccess: { [weak self] (response: InitResponseModel?) in
                                    self?.chooseAuthenticationService()
                                   },
                                   onFailure: { [weak self] errorDescription in
                                    print((errorDescription ?? "22") as String)
                                    self?.showError(errorDescription: errorDescription)
                                   })
    }
    
    private func getCashoutInitialize() {
        #warning("Change in prod")
        viewModel.getCashoutInitialize(email: SDKManager.email,
                                         amount: "₺50000,00".serviceAmountFormatAsString,
                                         currencyType: "TRY",
                                         onSuccess: { [weak self] (response: InitResponseModel?) in
                                            self?.chooseAuthenticationService()
                                         },
                                         onFailure: { [weak self] errorDescription in
                                            self?.showError(errorDescription: errorDescription)
                                         })
    }
    
    private func getTopUpInitialize() {
        viewModel.getTopUpInitialize(email: SDKManager.email,
                                       transactionType: .DEPOSIT,
                                       onSuccess: { [weak self] (response: InitResponseModel?) in
                                        self?.chooseAuthenticationService()
                                       },
                                       onFailure: { [weak self] errorDescription in
                                        self?.showError(errorDescription: errorDescription)
                                       })
    }
    
}
