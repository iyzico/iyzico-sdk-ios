//
//  BaseVC.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 18.12.2020.
//

import UIKit

protocol BaseVCDelegate: class {
    func didTappedButtonOnKeyboard()
}

class BaseVC: UIViewController {
    weak var baseDelegate: BaseVCDelegate?
    let rootVC = UIApplication.getPresentedViewController()
    var didTappedButtonOnKeyboard: (()->())?
    let animator = UIViewPropertyAnimator(duration: Constant.shared.AMDuration, curve: .linear)
    var baseScrollView: UIScrollView?

    var isSwipeBackEnabled: Bool = false {
        didSet {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isSwipeBackEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        addAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    #if DEBUG
    deinit {
        print("OS reclaiming memory for: \(self.classForCoder)")
    }
    #endif
    
    //MARK: - Helper Methods
    func configureNavBar(headerContainerStackViewVisibility: Bool = true,
                         navBarBottomViewVisibility: Bool = false,
                         timerStackViewVisibility: Bool = false,
                         balanceContainerViewVisibility: Bool = false,
                         backButtonVisibility: Bool = false,
                         titleImageViewVisibility: Bool = true,
                         nameLabelTitle: String = "",
                         closeButtonType: NavBarDismissTypes,
                         leftTitledStackViewVisibility: Bool = false,
                         leftTitledTitleLabelText: String = "",
                         leftTitledCancelButtonVisibility: Bool = false,
                         closeButtonVisibility: Bool = true) {
        let userInfo: [String : Any] = [
            "headerContainerStackViewVisibility": headerContainerStackViewVisibility,
            "navBarBottomViewVisibility": navBarBottomViewVisibility,
            "timerStackViewVisibility": timerStackViewVisibility,
            "balanceContainerViewVisibility": balanceContainerViewVisibility,
            "backButtonVisibility" : backButtonVisibility,
            "nameLabelTitle" : nameLabelTitle,
            "cancelButtonTitle": closeButtonType,
            "leftTitledStackViewVisibility" : leftTitledStackViewVisibility,
            "leftTitledTitleLabelText": leftTitledTitleLabelText,
            "titleImageViewVisibility": titleImageViewVisibility,
            "closeButtonVisibility": closeButtonVisibility,
            "leftTitledCancelButtonVisibility": leftTitledCancelButtonVisibility
        ]
        
        NotificationCenter.default.post(name: .navBarConfiguration,
                                        object: nil,
                                        userInfo: userInfo)
    }
    
    fileprivate func hideNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func showLoading() {
        let vc = AlertManager()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        rootVC?.present(vc, animated: true, completion: nil)
    }
    
    func hideLoading() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(errorDescription: String?) {
        let vc = IyzicoPopUpView(iyzicoButton: .primaryLvl1(state: .normal),
                                 iyzicoButtonTitle: StringConstant.shared.iyzicoButtonError,
                                 popUpImage: Asset.nonLottieFail.name,
                                 descText: errorDescription ?? "")
        vc.loadViewIfNeeded()
        vc.closeLabel.text = StringConstant.shared.closeButtonTitle
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.didTappedCloseButtonAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func showPopUp(iyzicoButtonTitle: String = StringConstant.shared.iyzicoButtonTitle,
                   iyzicoButtonOptionalTitle: String = StringConstant.shared.iyzicoButtonOptionalTitle,
                   descText: String = StringConstant.shared.iyzicoPopUpViewDescText,
                   popUpImage: String = Asset.basicIcnLogout.name) {
        
        let vc = IyzicoPopUpView(iyzicoButton: .primaryLvl1(state: .normal),
                                 iyzicoButtonTitle: iyzicoButtonTitle,
                                 iyzicoButtonOptional: .tertiary(state: .normal),
                                 iyzicoButtonOptionalTitle: iyzicoButtonOptionalTitle,
                                 popUpImage: popUpImage,
                                 descText: descText)
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func addIyzicoButtonAboveKeyboard(buttonType: IyzicoButtonType, title: String? = nil, image: String? = nil, cornerRadius: CGFloat = .zero) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(tappedButtonOnKeyboard), name: .didTappedButtonAboveKeyboard, object: nil)
        
        let userInfo: [String: Any?] = ["buttonType": buttonType,
                                        "title": title,
                                        "image": image,
                                        "cornerRadius": cornerRadius]
        
        NotificationCenter.default.post(name: .keyboardButton, object: nil, userInfo: userInfo as [AnyHashable: Any])
    }
    
    @objc func tappedButtonOnKeyboard() {
        //didTappedButtonOnKeyboard?()
        baseDelegate?.didTappedButtonOnKeyboard()
    }
    
    private func addAllObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCancelPopUp),
                                               name: .showAppCancelPopUp,
                                               object: nil)
    }
    
    @objc
    func showCancelPopUp() {
        var descTextByFlow = ""
        var buttonTextByFlow = ""
        let desc = StringConstant.shared
        switch SDKManager.flow {
        case .topUp:
            descTextByFlow = desc.iyzicoPopUpViewTopUpDescriptionText
            buttonTextByFlow = desc.iyzicoPopUpViewTopUpButtonText
        case .settlement:
            descTextByFlow = desc.iyzicoPopUpViewSettlementDescriptionText
            buttonTextByFlow = desc.iyzicoPopUpViewSettlementButtonText
        case .refund:
            descTextByFlow = desc.iyzicoPopUpViewRefundDescriptionText
            buttonTextByFlow = desc.iyzicoPopUpViewRefundButtonText
        case .cashout:
            descTextByFlow = desc.iyzicoPopUpViewCashoutDescriptionText
            buttonTextByFlow = desc.iyzicoPopUpViewCashoutButtonText
        case .payWithIyzico:
            descTextByFlow = desc.iyzicoPopUpViewPwiDescriptionText
            buttonTextByFlow = desc.iyzicoPopUpViewPwiButtonText
        }
        
        let vc = IyzicoPopUpView(iyzicoButton: .primaryLvl1(state: .normal),
                                 iyzicoButtonTitle: buttonTextByFlow,
                                 iyzicoButtonOptional: .tertiary(state: .normal),
                                 iyzicoButtonOptionalTitle: StringConstant.shared.iyzicoButtonOptionalTitle,
                                 popUpImage: Asset.basicIcnLogout.name,
                                 descText: descTextByFlow)

        
        vc.didTappedCloseButtonAction = {
            vc.dismiss(animated: true, completion: nil)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

extension BaseVC: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Made for detect direction of dragging.
//        guard let translation = baseScrollView?.panGestureRecognizer.translation(in: baseScrollView?.superview) else { return }
//        if translation.y < 0 {
//
//        }
        if baseScrollView?.isDragging ?? false {
            view.endEditing(true)
        }
    }
}

//MARK: - Back Swipe Delegate
extension BaseVC: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewControllers = self.navigationController?.viewControllers else {
            return false
        }
        return viewControllers.count > 1
    }
}

// MARK: - BLUR
extension BaseVC {
    
    func addBlur(view: UIView) { /// call in viewWillApper
        view.addBlur(animator: animator)
    }
    
    func removeBlur() { /// call in viewWillDisApper
        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)
    }
}
