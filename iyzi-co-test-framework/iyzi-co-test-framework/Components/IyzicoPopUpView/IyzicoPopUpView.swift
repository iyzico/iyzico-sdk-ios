//
//  IyzicoPopUpView.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 10.12.2020.
//

import UIKit


class IyzicoPopUpView: BaseVC {
    
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var optinalButtonView: UIView!
    @IBOutlet weak var mainButton: IyzicoButton!
    @IBOutlet weak var optinalButton: IyzicoButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var mainButtonWidthConstraint: NSLayoutConstraint!
    
    
    private var popUpImage: String?
    private var iyzicoButton: IyzicoButtonType = .primaryLvl1(state: .normal) //main button required
    private var iyzicoButtonOptional: IyzicoButtonType? // optional
    private var iyzicoButtonTitle: String?
    private var iyzicoButtonOptionalTitle: String?
    private var descText: String?
    private var iyzicoButtonOptionalVisibility: Bool = false
    var didTappedCloseButtonAction: (() -> Void)?
    
    convenience init(iyzicoButton: IyzicoButtonType,
                            iyzicoButtonTitle: String,
                            iyzicoButtonOptional: IyzicoButtonType? = nil,
                            iyzicoButtonOptionalTitle: String? = nil,
                            popUpImage: String? = nil,
                            descText: String,
                            isMultipleButton: Bool = true) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.IyzicoPopUpView, bundle: bundle)
        self.popUpImage = popUpImage
        self.iyzicoButton = iyzicoButton
        self.iyzicoButtonOptional = iyzicoButtonOptional
        self.iyzicoButtonTitle = iyzicoButtonTitle
        self.iyzicoButtonOptionalTitle = iyzicoButtonOptionalTitle
        self.descText = descText
        iyzicoButtonOptionalVisibility = !isMultipleButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundOpacity()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeBlur()
    }
   
}
// MARK: - Setup Funcs
extension IyzicoPopUpView {
        
    fileprivate func setBackgroundOpacity() {
        self.addBlur(view: self.view)
    }
    
    fileprivate func setUpForPopUpImageView() {
        if popUpImage != nil {
            popUpImageView.setImage(named: popUpImage!, typeof: self)
        } else {
            imageContentView.isHidden = true
        }
      
    }
    
    fileprivate func setUpView() {
        setUpMainView()
        setUpMainButtonAction()
        setUpForPopUpImageView()
        setUpDetailButtonAction()
        setUpPopUp()
    }
    
    fileprivate func setUpPopUp() {
        setUpMainButton()
        if iyzicoButtonOptional != nil {
            setUpOptionalButton()
        }
        setUpDescLabel(text: descText ?? "")
        setUpCloseLabel()
        setUpForCloseImageView()
    }
    
    fileprivate func setUpMainView() {
        mainView.layer.cornerRadius = Constant.shared.viewCornerRadius
        mainView.layer.masksToBounds = true
    }
    
    fileprivate func setUpDescLabel(text: String) {
        descLabel.font = .markProMedium16
        descLabel.textColor = .charcoalGrey
        descLabel.text = text
        descLabel.numberOfLines = .zero
    }
    
    fileprivate func setUpCloseLabel() {
        closeLabel.font = .markPro16
        closeLabel.textColor = .white
        closeLabel.text = StringConstant.shared.cancelButtonTitleForPopUp
    }
    
    fileprivate func setUpForCloseImageView() {
        closeImage.setImage(named: Asset.basicClose.name, typeof: self)
    }

    
    fileprivate func setUpMainButton() {
        mainButton.cornerRadius = Constant.shared.buttonCornerRadius
        
        switch iyzicoButton {
            case .primaryLvl1(state: .normal):
                mainButton.primaryLvl1UI(state: .normal, title: iyzicoButtonTitle)
            case .primaryLvl2(state: .normal):
                mainButton.primaryLvl2UI(state: .normal, title: iyzicoButtonTitle)
            case .primarySticky(state: .normal):
                mainButton.primaryStickyUI(state: .normal, title: iyzicoButtonTitle)
            case .secondary(state: .normal):
                mainButton.secondaryLvl1UI(state: .normal, title: iyzicoButtonTitle)
            case .tertiary(state: .normal):
                mainButton.tertiaryUI(state: .normal, title: iyzicoButtonTitle)
            case .error(state: .normal):
                mainButton.errorUI(state: .normal, title: iyzicoButtonTitle)
            case .warm(state: .normal):
                mainButton.warmUI(state: .normal, title: iyzicoButtonTitle)
            case .success(state: .normal):
                mainButton.successUI(state: .normal, title: iyzicoButtonTitle)
            case .amount(state: .normal):
                mainButton.amountUI(state: .normal, title: iyzicoButtonTitle)
            default:
                return
        }
    }
    
    fileprivate func setUpOptionalButton() {
        optinalButtonView.isHidden = iyzicoButtonOptionalVisibility
        optinalButton.cornerRadius = Constant.shared.buttonCornerRadius
        
        switch iyzicoButtonOptional {
            case .primaryLvl1(state: .normal):
                optinalButton.primaryLvl1UI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .primaryLvl2(state: .normal):
                optinalButton.primaryLvl2UI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .primarySticky(state: .normal):
                optinalButton.primaryStickyUI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .secondary(state: .normal):
                optinalButton.secondaryLvl1UI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .tertiary(state: .normal):
                optinalButton.tertiaryUI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .error(state: .normal):
                optinalButton.errorUI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .warm(state: .normal):
                optinalButton.warmUI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .success(state: .normal):
                optinalButton.successUI(state: .normal, title: iyzicoButtonOptionalTitle)
            case .amount(state: .normal):
                optinalButton.amountUI(state: .normal, title: iyzicoButtonOptionalTitle)
            default:
                return
        }
    }
    
    fileprivate func setUpNotificationButton(title:String) {
        mainButton.secondaryLvl1UI(state: .normal, title: title)
        mainButton.cornerRadius = Constant.shared.buttonCornerRadius
    }

    fileprivate func setUpMainButtonAction() {
        mainButton.didTappedButton = { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func setUpDetailButtonAction() {
        optinalButton.didTappedButton = { //[unowned self] in
            SDKManager.closeSDK()
        }
    }
}
// MARK: - Helper Funs
extension IyzicoPopUpView {
     
}
// MARK: - Action
extension IyzicoPopUpView {
    @IBAction func didTappedCloseButton(_ sender: Any) {
        didTappedCloseButtonAction?()
    }
}
