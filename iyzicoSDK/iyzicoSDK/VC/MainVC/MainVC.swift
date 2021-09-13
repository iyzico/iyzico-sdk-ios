//
//  MainVC.swift
//  iyzi-co-testApp
//
//  Created by Tolga İskender on 18.12.2020.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var iyzicoNavBar: IyzicoNavBar!
    @IBOutlet weak var mainView: UIView!

    var rootVC: UIViewController?
    var hideBottomBarWhenClickBackButtonOnOTP: Bool = false
    
    var viewModel = MainVM()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addRootViewController()
        addObservers()
        initializeEvents()
        self.presentationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public convenience init() {
        
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.MainVC, bundle: bundle)
        
    }
    
    
}

//MARK: - Helper Methods
extension MainVC {
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configureNavBar),
                                               name: .navBarConfiguration,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCountdownFinishedPopUp),
                                               name: .didFinishTimerAtPayWithIyzicoFlow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getBalances),
                                               name: .getBalances,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeObservers),
                                               name: .removePwiTimerObservers,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePrice),
                                               name: .updatePrice,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideBottomBar),
                                               name: .hideBottomBar,
                                               object: nil)
    }
    
    @objc
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .didFinishTimerAtPayWithIyzicoFlow, object: nil)
    }
}

//MARK: - Events
extension MainVC {
    private func initializeEvents() {
        iyzicoNavBar.backButton.didTappedButton = { [unowned self] in
            if hideBottomBarWhenClickBackButtonOnOTP {
                self.iyzicoNavBar.navBarBottomView.isHidden = true
                self.hideBottomBarWhenClickBackButtonOnOTP = false
            }
            self.popViewController()
        }
        
        iyzicoNavBar.supportBackButton.didTappedButton = { [unowned self] in
            self.popViewController()
        }
    }
    
    @objc
    private func showCountdownFinishedPopUp() {
        let vc = IyzicoPopUpView(iyzicoButton: .tertiary(state: .normal),
                                 iyzicoButtonTitle: StringConstant.shared.iyzicoPopUpViewTryAgainTitle,
                                 iyzicoButtonOptional: .tertiary(state: .normal),
                                 iyzicoButtonOptionalTitle: StringConstant.shared.iyzicoButtonOptionalTitle,
                                 popUpImage: Asset.basicHourglassHighResIcon.name,
                                 descText: StringConstant.shared.iyzicoPopUpViewTimeOutDesc)
        vc.loadViewIfNeeded()
        vc.mainButton.button.addBorder(borderColor: UIColor.clearBlue3.cgColor)
        vc.mainButton.button.setTitleColor(.clearBlue3, for: .normal)
        vc.mainButtonWidthConstraint.constant = 157
        vc.optinalButtonView.isHidden = true
        vc.mainButton.didTappedButton = {
            vc.dismiss(animated: true) { [unowned self] in
                let vc = NewMemberVC(vcType: .payWithIyzico)
                self.rootVC?.navigationController?.setViewControllers([vc], animated: true)
                NotificationCenter.default.post(name: .restartTimerAtPayWithIyzicoFlow, object: nil)
            }
        }
        vc.didTappedCloseButtonAction = {
            SDKManager.closeSDK()
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    private func configureNavBar(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let headerContainerStackViewVisibilty = userInfo["headerContainerStackViewVisibility"] as? Bool,
              let navBarBottomViewVisibility = userInfo["navBarBottomViewVisibility"] as? Bool,
              let timerStackViewVisibility = userInfo["timerStackViewVisibility"] as? Bool,
              let balanceContainerViewVisibility = userInfo["balanceContainerViewVisibility"] as? Bool,
              let backButtonVisibility = userInfo["backButtonVisibility"] as? Bool,
              let nameLabelTitle = userInfo["nameLabelTitle"] as? String,
              let cancelButtonType = userInfo["cancelButtonTitle"] as? NavBarDismissTypes,
              let leftTitledStackViewVisibility = userInfo["leftTitledStackViewVisibility"] as? Bool,
              let leftTitledTitleLabelText = userInfo["leftTitledTitleLabelText"] as? String,
              let titleImageViewVisibility = userInfo["titleImageViewVisibility"] as? Bool,
              let closeButtonVisibility = userInfo["closeButtonVisibility"] as? Bool,
              let leftTitledCancelButtonVisibility = userInfo["leftTitledCancelButtonVisibility"] as? Bool else { return }
        iyzicoNavBar.headerContainerStackView.isHidden = !headerContainerStackViewVisibilty
        iyzicoNavBar.navBarBottomView.isHidden = !navBarBottomViewVisibility
        iyzicoNavBar.timerStackView.isHidden = !timerStackViewVisibility
        iyzicoNavBar.balanceContainerView.isHidden = !balanceContainerViewVisibility
        iyzicoNavBar.backButton.isHidden = !backButtonVisibility
        iyzicoNavBar.nameLabel.text = nameLabelTitle
        iyzicoNavBar.closeButtonType = cancelButtonType
        iyzicoNavBar.titleImageView.isHidden = !titleImageViewVisibility
        iyzicoNavBar.cancelButton.isHidden = !closeButtonVisibility
        switch cancelButtonType {
        case .cancel:
            iyzicoNavBar.cancelButton.setTitle(StringConstant.shared.cancelButtonTitle, for: .normal)
        case .close:
            iyzicoNavBar.cancelButton.setTitle(StringConstant.shared.closeButtonTitle, for: .normal)
        }
        iyzicoNavBar.leftTitledStackView.isHidden = !leftTitledStackViewVisibility
        iyzicoNavBar.leftTitledTitleLabel.text = leftTitledTitleLabelText
        iyzicoNavBar.leftTitledCancelButton.isHidden = !leftTitledCancelButtonVisibility
    }
}

// MARK: - setUpNavBar
extension MainVC {
    
    @objc
    func hideBottomBar(notification: NSNotification) {
        let info = notification.userInfo
        let isHidden = info?["isHidden"] as! Bool
        self.hideBottomBarWhenClickBackButtonOnOTP = isHidden
    }
    
}

// MARK: - Push
extension MainVC {
    
    fileprivate func addRootViewController() {
        guard let validatedRootVC = rootVC else { return }
        let navVC = UINavigationController(rootViewController: validatedRootVC)
        self.add(navVC, containerView: mainView)
    }
    
    fileprivate func popViewController() {
        rootVC?.navigationController?.popViewController(animated: true)
    }
}

extension MainVC: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false // <-prevents the modal sheet from being closed
    }
}

//MARK: - Service Calls
extension MainVC {
    @objc
    func getBalances() {
        switch SDKManager.flow {
        case .cashout, .refund, .settlement, .topUp:
            viewModel.getBalances(
            onSuccess: { [weak self] (response: BalancesResponseModel?) in
    //            self?.iyzicoNavBar.iyzicoBalanceAmountLabel.text = response?.amount?.roundedTwoDigit.addTL
    //            self?.iyzicoNavBar.iyzicoBalanceAmountLabel.text = response?.amount?.addTL
                self?.iyzicoNavBar.iyzicoBalanceAmountLabel.text = response?.amount?.addTLWithNoDots
            }, onFailure: { errorDescription in
                Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
            })
        default:
            break
        }
    }
    
    @objc
    func updatePrice() {
        self.iyzicoNavBar.priceLabel.text =  SDKManager.price?.addTLWithAlignment(alignment: .left)
    }
}
