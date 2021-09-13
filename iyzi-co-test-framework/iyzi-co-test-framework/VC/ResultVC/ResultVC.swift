//
//  ResultVC.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

class ResultVC: BaseVC, ResultCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seeBankInformationButton: IyzicoButton!
    @IBOutlet weak var returnToAppButton: IyzicoButton!
    
    var vcType: ResultVCTypes = .success
    lazy var constants = ResultCellConstants.shared.getType(vcType: vcType)
    var resultVM = ResultVM()
    
    convenience init(vcType: ResultVCTypes) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.ResultVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeTableView()
        initializeEvents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalances()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logMessageToDeveloper()
    }
    
    //MARK: - Events
    private func initializeEvents() {
        seeBankInformationButton.didTappedButton = { [unowned self] in
            if self.vcType == .error {
                SDKManager.closeSDK()
            } else {
                let vc = IyzicoEFTDetailVC(bankImage: Asset.addEmail.name,
                                           eftDetailType: .info)
                vc.viewModel.protectedBankAccount = resultVM.protectedBankAccount
                vc.viewModel.priceForLoad = resultVM.priceForLoad
                vc.viewModel.priceForPayment = resultVM.priceForPayment
                vc.viewModel.navigatedReferenceCode = resultVM.navigatedReferenceCode
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        
        }
        
        returnToAppButton.didTappedButton = {
            if self.vcType == .error {
                let vc = NewMemberVC(vcType: SDKManager.flow)
                self.navigationController?.setViewControllers([vc], animated: true)
                NotificationCenter.default.post(name: .restartTimerAtPayWithIyzicoFlow, object: nil)
            } else {
                SDKManager.closeSDK()
            }
        }
    }
    
    func appStoreButtonTapped() {
        StringConstant.ResultVC.appStoreIyzicoLink.openUrl()
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupReturnToAppButton()
        setupSeeBankInformationButton()
    }
    
    private func setupNavBar() {
        switch vcType {
            case .topUpSuccess, .cashoutSuccess, .settlementSuccess, .refundSuccess, .cashoutWaiting, .topUpWaiting:
                configureNavBar(balanceContainerViewVisibility: true,
                                nameLabelTitle: SDKManager.brand ?? "",
                                closeButtonType: .close)
            case .transferDetailSuccess, .success, .error:
                configureNavBar(navBarBottomViewVisibility: true,
                                nameLabelTitle: SDKManager.brand ?? "",
                                closeButtonType: .close)
            case .threeDSecure:
                configureNavBar(navBarBottomViewVisibility: true,
                                nameLabelTitle: SDKManager.brand ?? "",
                                closeButtonType: .close)
                pushTo3DS()
            case .successWithProducts:
                //Discarded feature
                break
        }
    }
    
    private func setupReturnToAppButton() {
        if vcType == .error {
            returnToAppButton.setUp(buttonType: .primaryLvl1(state: .normal),
                                           title: constants.tryAgain)
        } else {
            returnToAppButton.setUp(buttonType: .primaryLvl1(state: .normal), title: constants.returnToAppButton)
        }
       
    }
    
    private func setupSeeBankInformationButton() {
        if vcType == .error {
            seeBankInformationButton.setUp(buttonType: .secondary(state: .normal),
                                           title: constants.returnToAppButton)
        } else {
            seeBankInformationButton.setUp(buttonType: .secondary(state: .normal),
                                           title: constants.seeBankInformationButton)
        }
        
    }
    
    func configureButtonsVisibility(_ seeBankInformationButtonVisibility: Bool, _ returnToAppButtonVisibility: Bool) {
        seeBankInformationButton.isHidden = seeBankInformationButtonVisibility
        returnToAppButton.isHidden = returnToAppButtonVisibility
    }
    
    //MARK: - Helper Methods
    private func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCells(types: [ResultCell.self])
    }
    
    private func logMessageToDeveloper() {
        switch vcType {
        case .cashoutSuccess,
             .refundSuccess,
             .topUpSuccess,
             .settlementSuccess,
             .transferDetailSuccess,
             .threeDSecure,
             .success:
            Iyzico.delegate?.didOperationSuccess(message: ResultCode.success.message)
        case .error:
            Iyzico.delegate?.didOperationFailed(state: .error, message: ResultCode.error.message)
        default:
            break
        }
    }
    
    func pushTo3DS() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [unowned self] in
            let vc = WebVC(vcType: .html)
            vc.html = self.resultVM.html
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Service Calls
    private func getBalances() {
        NotificationCenter.default.post(name: .getBalances, object: nil)
    }
}

//MARK: - Table View Methods
extension ResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ResultCell.self, for: indexPath) as! ResultCell
        cell.delegate = self
        let constants = ResultCellConstants.shared.getType(vcType: vcType)
        switch vcType {
        case .topUpSuccess:
            constants.titleLabel = resultVM.topUpPriceForLoad ?? ""
        default:
            break
        }
        cell.constants = constants
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
