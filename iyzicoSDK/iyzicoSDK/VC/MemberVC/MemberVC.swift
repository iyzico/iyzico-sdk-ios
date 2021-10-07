//
//  MemberVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.02.2021.
//

import UIKit

class MemberVC: BaseVC {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var memberButton: IyzicoMemberView!
    @IBOutlet weak var changeAccountButton: UIButton!
    
    private typealias uiConstants = StringConstant.MemberVC
    var memberVM = MemberVM()
    var newMemberVM = NewMemberVM()
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.MemberVC, bundle: bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(closeButtonType: .cancel)
    }
    
    //MARK: - Events
    private func initializeEvents() {
        memberButton.memberButtonAction = { [unowned self] in
            self.getLoginInitialize()
        }
    }
    
    @IBAction func changeAccountButtonTapped(_ sender: Any) {
        navigateToNewMemberVC()
    }
    
    //MARK: - Helper Methods
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupTitleLabel()
        setupSubTitleLabel()
        setupMemberButton()
        setupChangeAccountButton()
    }
    
    private func setupTitleLabel(){
        titleLabel.font = .markProBold24
        titleLabel.textColor = .darkGrey
        switch SDKManager.flow {
        case .refund:
            titleLabel.text = uiConstants.refundTitle
        case .settlement, .cashout:
            titleLabel.text = uiConstants.settlementTitle
        default:
            titleLabel.text = uiConstants.titleLabel
        }
    }
    
    private func setupSubTitleLabel(){
        subTitleLabel.font = .markPro14
        subTitleLabel.textColor = .darkGrey
        subTitleLabel.text = uiConstants.subTitleLabel
    }
    
    private func setupMemberButton(){
        memberButton.emailLabel.text = SDKManager.email
        memberButton.descriptionLabel.text = uiConstants.memberButtonDescription
    }
    
    private func setupChangeAccountButton(){
        changeAccountButton.setTitle(uiConstants.changeAccountButton, for: .normal)
        changeAccountButton.setTitleColor(.clearBlue3, for: .normal)
        changeAccountButton.titleLabel?.font = .markProBold16
        switch SDKManager.flow {
        case .cashout, .settlement, .refund:
            changeAccountButton.isHidden = true
        default:
            changeAccountButton.isHidden = false
        }
    }
    
    //MARK: - Helper Methods
    private func navigateToOtpVC(isGsmVerified: Bool?) {
        let vc = OTPVC()
        customizeForPayWithIyzico()
//        vc.delegate = self
        vc.viewModel.navigatedPhoneNumber = SDKManager.phone?.removeWhiteSpaces
        vc.viewModel.navigatedLoginInitializeResponse = newMemberVM.loginInitializeResponse
        //        vc.viewModel.navigatedRegisterInitializeResponse = newMemberVM.registerInitializeResponse
        vc.viewModel.isGsmVerified = isGsmVerified
        vc.viewModel.navigatedInitializeResponse = newMemberVM.initializeResponse
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToNewMemberVC() {
        let vc = NewMemberVC(vcType: SDKManager.flow)
        vc.viewModel.initializeResponse = newMemberVM.initializeResponse
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Service Calls
    private func getLoginInitialize() {
#warning("Change in prod")
        newMemberVM.getLoginInitialize(email: SDKManager.email,
                                       clientIp: SDKManager.clientIp,
                                       loginChannel: "THIRD_PARTY_APP",
                                       shouldShowLoading: true,
        onSuccess: { [weak self] (response: QuickLoginInitializeResponseModel?) in
//            let isGsmVerified = response?.gsmVerified ?? false
//            if isGsmVerified {
//                self?.navigateToOtpVC(isGsmVerified: isGsmVerified)
//            }
//            else {
//                self?.getGsmUpdate(
//                onSuccess: { [weak self] (response: GsmUpdateResponseModel?) in
//                    self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
//                })
//            }
            self?.navigateToOtpVC(isGsmVerified: response?.gsmVerified)
        },
                                       onFailure: { [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
            Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
        })
    }
    
    func customizeForPayWithIyzico() {
        if SDKManager.flow == .payWithIyzico {
            let userInfo: [String : Bool] = [ "isHidden": true]
            NotificationCenter.default.post(name: .hideBottomBar,
                                            object: nil,
                                            userInfo: userInfo)
        }
    }
    
//    private func getGsmUpdate(onSuccess: @escaping (GsmUpdateResponseModel?) -> Void) {
//        ///TODO - add area code to phone
//        newMemberVM.getGsmUpdate(phone: SDKManager.phone?.removeWhiteSpaces,
//                                 shouldShowLoading: false,
//        onSuccess: { (response: GsmUpdateResponseModel?) in
//            onSuccess(response)
//        },
//        onFailure: { [weak self] errorDescription in
//            self?.showError(errorDescription: errorDescription)
//        })
//    }
}
