//
//  EmailSupportVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

class EmailSupportVC: BaseVC {
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var getSupportButton: IyzicoButton!
    
    private typealias constants = StringConstant.EmailSupportVCConstants
    
    convenience init(title: String) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.EmailSupportVC, bundle: bundle)
        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(headerContainerStackViewVisibility: false,
                        backButtonVisibility: true,
                        closeButtonType: .close,
                        leftTitledStackViewVisibility: true,
                        leftTitledTitleLabelText: constants.title)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isSwipeBackEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isSwipeBackEnabled = false
    }
    
    //MARK: - Events
    private func initializeEvents() {
        getSupportButton.didTappedButton = { [unowned self] in
//            StringConstant.shared.iyzicoGetSupportPhoneNumber.callPhoneNumber()
            self.showBottomAlert()
        }
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupDescription1Label()
        setupDescription2Label()
        setupGetSupportButton()
        setUpRightBarButton()
    }
    
    
    private func setupDescription1Label() {
        description1Label.text = constants.description1LabelText
        description1Label.font = .markProBold16
        description1Label.textColor = .darkGrey
    }
    
    private func setupDescription2Label() {
        description2Label.text = constants.description2LabelText
        description2Label.font = .markPro16
        description2Label.textColor = .darkGrey
    }
    
    private func setupGetSupportButton() {
        getSupportButton.setUp(buttonType: .tertiary(state: .normal), title: constants.getSupportButtonTitle, image: Asset.basicIcnSupport.name,cornerRadius: Constant.shared.emailSupportVCButtonCornerRadius)
        getSupportButton.customizeButtonTitleEdgeInsets(contentHorizontalAlignment: .left, leftSpacing:  Constant.shared.emailSupportVCButtonLeftEdgeInset, rightSpacing: .zero, topSpacing: .zero, bottomSpacing: .zero)
    }
    
    fileprivate func setUpRightBarButton() {
        let button = UIButton(type: .custom)
        button.setTitle(StringConstant.shared.closeButtonTitle, for: .normal)
        button.titleLabel?.font = .markProBold16
        button.setTitleColor(.clearBlue3, for: .normal)
        
        button.addTarget(self, action: #selector(didTappedRightBarButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - Helper Methods
    private func showBottomAlert() {
        var config = BSConfiguration()
        config.cornerRadius = 8.0
        let bsController = BottomSheetController(contentViewController: BottomAlertVC(), configuration: config)
        self.present(bsController, animated: true, completion: nil)
    }
}

//MARK:- Action
extension EmailSupportVC {
    @objc func didTappedRightBarButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
