//
//  EFTDetailVC.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 22.12.2020.
//

import UIKit

class IyzicoEFTDetailVC: BaseVC {
    
    @IBOutlet weak var contentView: IyzicoDragDissmisView!
  
    @IBOutlet weak var dissmissView: UIView!
    @IBOutlet weak var dividerImageView: UIImageView! {
        didSet {
            dividerImageView.image = Asset.divider.image
            dividerImageView.tintColor = .paleGreyTwo
        }
    }
    @IBOutlet weak var bankImageView: UIImageView!{
        didSet {
            let image = viewModel.protectedBankAccount?.bankLogoUrl
            bankImageView.setImageWithCaching(urlString: image, placeholderImage:  Asset.calendar.image) {_ in }
        }
    }
    @IBOutlet weak var bankNameLabel: UILabel!{
        didSet {
            bankNameLabel.font = .markProBold18
            bankNameLabel.textColor = .darkGrey
//            bankNameLabel.text = "Türkiye İş Bankası"
            bankNameLabel.text = viewModel.protectedBankAccount?.bankName
        }
    }
    @IBOutlet weak var seperatorView: UIView! {
        didSet {
            seperatorView.backgroundColor = UIColor.pinkishGrey.withAlphaComponent(CGFloat(Constant.shared.duration))
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: .zero, left: CGFloat(Constant.shared.padding), bottom: .zero, right: CGFloat(Constant.shared.padding))
            tableView.separatorColor = .paleGreyTwo
            tableView.tableFooterView = UIView(frame: CGRect(x: .zero, y: .zero, width: tableView.frame.size.width, height: 1))
            
            tableView.registerCell(type: BankDetailCell.self)
            tableView.registerCell(type: InfoCell.self)
            
        }
    }
    @IBOutlet weak var primaryButton: IyzicoButton!
    
    @IBOutlet weak var secondaryButton: IyzicoButton!
    
    var eftDetailType: EftDetailVCTypeEnum = .info
    var viewModel = IyzicoEFTDetailVM()
    
    
    convenience init(bankImage: String, eftDetailType: EftDetailVCTypeEnum) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.IyzicoEFTDetailVC, bundle: bundle)
        self.eftDetailType = eftDetailType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPrimaryButton()
        setUpSecondaryButton()
        addActiontoView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornertoContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundOpacity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeBlur()
    }
}
//MARK:- Funcs
extension IyzicoEFTDetailVC {
    fileprivate func setCornertoContentView() {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: Constant.shared.viewCornerRadius)
    }
    
    fileprivate func setBackgroundOpacity() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constant.shared.duration) {
            UIView.animate(withDuration: Constant.shared.duration) {
                self.addBlur(view: self.view)
            }
        }
    }
    
    fileprivate func setUpPrimaryButton() {
        switch eftDetailType {
            case .info:
                primaryButton.setUp(buttonType: .secondary(state: .normal), title: StringConstant.shared.iyzicoEFTDetailVCShareText,cornerRadius: Constant.shared.buttonCornerRadius24)
                primaryButton.didTappedButton = { [unowned self] in
                    self.share(iban: viewModel.protectedBankAccount?.iban ?? "",
                               referansNumber: viewModel.navigatedReferenceCode ?? "",
                               owner: viewModel.protectedBankAccount?.legalCompanyTitle ?? "")
                }
            case .bank:
                primaryButton.setUp(buttonType: .primaryLvl1(state: .normal), title: StringConstant.shared.iyzicoEFTDetailVCShareText,cornerRadius: Constant.shared.buttonCornerRadius24)
                primaryButton.didTappedButton = { [unowned self] in
                    self.share(iban: viewModel.protectedBankAccount?.iban ?? "",
                               referansNumber: viewModel.navigatedReferenceCode ?? "",
                               owner: viewModel.protectedBankAccount?.legalCompanyTitle ?? "")
                }
            case .transfer:
                primaryButton.setUp(buttonType: .primaryLvl1(state: .normal), title: StringConstant.shared.iyzicoEFTDetailVCCompleteOrderText,cornerRadius: Constant.shared.buttonCornerRadius24)
                primaryButton.didTappedButton = { [unowned self] in
                    self.view.removeBlurred()
                    self.dismiss(animated: true) {
                        if SDKManager.flow == .payWithIyzico {
                            payWithBankTransferNotify()
                        } else {
                            self.view.removeBlurred()
                            guard let bank = self.viewModel.protectedBankAccount else {return}
                            let bankInfo = ["bankInfo": bank] as [AnyHashable : Any]
                            NotificationCenter.default.post(name: .completeOrder, object: nil,userInfo: bankInfo)
                        }
                       
                    }
                }
        }
    }
    
    fileprivate func setUpSecondaryButton() {
        switch eftDetailType {
            case .info:
                secondaryButton.isHidden = true
            case .bank:
                secondaryButton.setUp(buttonType: .secondary(state: .normal), title: StringConstant.shared.iyzicoEFTDetailVCReturnAppText,cornerRadius: Constant.shared.buttonCornerRadius24)
                secondaryButton.didTappedButton = { [unowned self] in
                    self.view.removeBlurred()
                    self.dismiss(animated: true, completion: nil)
                }
            case .transfer:
                secondaryButton.isHidden = true
        }
    }
    
    fileprivate func share(iban: String, referansNumber: String, owner: String) {
        typealias shareType = IyzicoEFTDetailVCEnum
        let items = [shareType.iban.textFieldTitle + ": " + iban,
                     shareType.accountOwner.textFieldTitle + ": " + owner,
                     shareType.desc.textFieldTitle + ": " + referansNumber]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil);
        self.present(activity, animated: true, completion: nil)
    }
    
    fileprivate func addActiontoView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.dissmissView.addGestureRecognizer(tap)
        self.dissmissView.isUserInteractionEnabled = true
    }
}
//MARK:- Action
extension IyzicoEFTDetailVC {
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.view == dissmissView {
            self.view.removeBlurred()
            self.dismiss(animated: true, completion: nil)
        }
       
    }
}

//MARK:- UITableViewDataSource
extension IyzicoEFTDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IyzicoEFTDetailVCEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.BankDetailCell, for: indexPath) as! BankDetailCell
        let row = IyzicoEFTDetailVCEnum(rawValue: indexPath.row)
        
        switch row {
            case .iban:
                cell.setCell(textInputType: .iban, title: row?.textFieldTitle ?? "", keyboardType: .numberPad, placeholder: "iban")
                cell.textField.textField.text = viewModel.protectedBankAccount?.iban
            case .accountOwner:
                cell.setCell(textInputType: .text, title: row?.textFieldTitle ?? "", keyboardType: .default, placeholder: "hesap")
                cell.textField.textField.text = viewModel.protectedBankAccount?.legalCompanyTitle
            case .amount:
                cell.setCell(textInputType: .amount, title: row?.textFieldTitle ?? "", keyboardType: .decimalPad, placeholder: "amount")
                if SDKManager.flow == .payWithIyzico {
                    cell.textField.textField.text = viewModel.priceForPayment
                }
                else {
                    cell.textField.textField.text = viewModel.priceForLoad
                }
            case .desc:
                cell.setCell(textInputType: .phone, title: row?.textFieldTitle ?? "", keyboardType: .numberPad, placeholder: "")
                cell.textField.textField.text = viewModel.navigatedReferenceCode
            case .info:
                let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InfoCell, for: indexPath) as! InfoCell
                cell.setCell(text: StringConstant.shared.iyzicoEFTDetailVCInfoText)
                return cell
            case .none: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eftDetailType == .bank {
            let row = IyzicoEFTDetailVCEnum(rawValue: indexPath.row)
            if row == .amount {
                return .zero
            }
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
}
//MARK:- UITableViewDelegate
extension IyzicoEFTDetailVC: UITableViewDelegate {
    
}

//extension IyzicoEFTDetailVC: UIGestureRecognizerDelegate {
extension IyzicoEFTDetailVC {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view.subviews.first)
    }
}

//MARK:- SERVICE CALL

extension IyzicoEFTDetailVC {
    
    private func payWithBankTransferNotify() {
        viewModel.payWithBankTransferNotify { [weak self] (response: PaymentBankTransferResponseModel?) in
            self?.view.removeBlurred()
            guard let self = self else {return}
            guard let bank = self.viewModel.protectedBankAccount else {return}
            let bankInfo = ["bankInfo": bank] as [AnyHashable : Any]
            NotificationCenter.default.post(name: .completeOrder, object: nil,userInfo: bankInfo)
        } onFailure: {  [weak self] errorDescription in
            self?.showError(errorDescription: errorDescription)
        }
    }
}
