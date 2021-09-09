//
//  SettlementVC.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

class SettlementVC: BaseVC {
    
    @IBOutlet weak var balanceToDeliveryLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var alwaysDeliveryLabel: UILabel!
    @IBOutlet weak var alwaysDeliverySubLabel: UILabel!
    @IBOutlet weak var deliverySwitch: UISwitch!
    @IBOutlet weak var deliveryButton: IyzicoButton!
    
    private typealias constants = StringConstant.SettlementVCConstants
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.SettlementVC, bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalances()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavBar(balanceContainerViewVisibility: true,
                        nameLabelTitle: SDKManager.brand ?? "",
                        closeButtonType: .cancel)
    }
    
    //MARK: - Events
    private func initializeEvents() {
        deliveryButton.didTappedButton = { [unowned self] in
            ///TODO - Make control with service
            self.navigationController?.pushViewController(ResultVC(vcType: .settlementSuccess), animated: true)
        }
    }
    
    @IBAction func deliverySwitchValueChanged(_ sender: UISwitch) {
        
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupBalanceToDeliveryLabel()
        setupBalanceLabel()
        setupAlwaysDeliveryLabel()
        setupAlwaysDeliverySubLabel()
        setupDeliveryButton()
    }
    
    private func setupBalanceToDeliveryLabel() {
        balanceToDeliveryLabel.text = constants.balanceToDeliveryLabelText
        balanceToDeliveryLabel.font = .markPro14
        balanceToDeliveryLabel.textColor = .darkGrey
    }
    
    private func setupBalanceLabel() {
        balanceLabel.textColor = .darkGrey
        balanceLabel.font = .markProBold14
        #warning("price")
        balanceLabel.text = SDKManager.walletPrice?.addTLWithAlignment(alignment: .left)
    }
    
    private func setupAlwaysDeliveryLabel() {
        alwaysDeliveryLabel.text = constants.alwaysDeliveryLabelText
        alwaysDeliveryLabel.font = .markProMedium14
        alwaysDeliveryLabel.textColor = .darkGrey
    }
    
    private func setupAlwaysDeliverySubLabel() {
        alwaysDeliverySubLabel.text = constants.alwaysDeliverySubLabelText
        alwaysDeliverySubLabel.font = .markPro12
    }
    
    private func setupDeliveryButton() {
        deliveryButton.setUp(buttonType: .primaryLvl1(state: .normal), title: constants.deliveryButtonTitle)
    }
    
    //MARK: - Service Calls
    private func getBalances() {
        NotificationCenter.default.post(name: .getBalances, object: nil)
    }
}
