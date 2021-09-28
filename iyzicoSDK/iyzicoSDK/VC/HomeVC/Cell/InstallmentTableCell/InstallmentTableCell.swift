//
//  InstallmentTableCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 17.08.2021.
//

import UIKit

protocol InstallmentTableCellDelegate: class {
    func didTappedAmountButton(priceCheckBox: IyzicoCheckBox)
    func getInstallmentNumber(installment: Int?, totalPrice: Double?)
}

class InstallmentTableCell: UITableViewCell {
    
    weak var delegate: InstallmentTableCellDelegate?
    
    @IBOutlet weak var installmentTableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var isntallmentTableview: UITableView! {
        didSet {
            isntallmentTableview.rowHeight = UITableView.automaticDimension
            isntallmentTableview.estimatedRowHeight = UITableView.automaticDimension
            isntallmentTableview.tableFooterView = .init(frame: .zero)
            isntallmentTableview.separatorStyle = .none
            isntallmentTableview.delegate = self
            isntallmentTableview.dataSource = self
            isntallmentTableview.registerCell(type: InstallmentCell.self)
            
        }
    }
    @IBOutlet weak var tableContentView: UIView! {
        didSet {
            tableContentView.clipsToBounds = true
            tableContentView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            tableContentView.layer.borderColor = UIColor.silver.cgColor
            tableContentView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        }
    }
    
    @IBOutlet weak var tableTitleView: UIView!
    
    @IBOutlet weak var tableTitleLabel: UILabel! {
        didSet {
            tableTitleLabel.text = "Taksit Seçenekleri"
            tableTitleLabel.font = .markPro16
            tableTitleLabel.textColor = .gunmetal
        }
    }
    @IBOutlet weak var installmentInfoView: UIView! {
        didSet {
            installmentInfoView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            installmentInfoView.layer.borderColor = UIColor.silver.cgColor
            installmentInfoView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        }
    }
    
    @IBOutlet weak var installmentInfoLabel: UILabel! {
        didSet {
            installmentInfoLabel.text =  StringConstant.shared.iyzicoHomeVCInstallmentInfoText//"Taksit seçenekleri kart numaranızı girdikten sonra görünecektir."
            installmentInfoLabel.font = .markPro14
            installmentInfoLabel.textColor = .blueGrey
            
        }
    }
    
    @IBOutlet weak var amaountBackView: UIView! {
        didSet {
            amaountBackView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            amaountBackView.layer.borderColor = UIColor.silver.cgColor
            amaountBackView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        }
    }
    @IBOutlet weak var withDrawAmountLabel: UILabel! {
        didSet {
            //            withDrawAmountLabel.text = "Kartınızdan ₺68,70 çekilecektir.".uppercased()
            withDrawAmountLabel.font = .markProMedium12
            withDrawAmountLabel.textColor = .blueGrey
        }
    }
    @IBOutlet weak var withDrawView: UIView!
    @IBOutlet weak var priceContainerStackView: UIStackView!
    
    @IBOutlet weak var priceCheckBox: IyzicoCheckBox! {
        didSet {
            priceCheckBox.borderColor = UIColor.silverTwo.cgColor
            priceCheckBox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
            priceCheckBox.cornerRadius = Constant.shared.defaultCheckBoxCornerRadius
            priceCheckBox.checkBoxType = .check
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.text = StringConstant.shared.newCardCellCardAmountLabelText
            amountLabel.font = .markProMedium14
            amountLabel.textColor = .darkGrey
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "-"
            priceLabel.font = .markProMedium14
            priceLabel.textColor = .darkGrey
            priceLabel.textAlignment = .right
        }
    }

    var installmentModel: InstallmentDetail?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if SDKManager.flow == .topUp {
            priceContainerStackView.isHidden = true
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTappedAmountButton(_ sender: Any) {
        delegate?.didTappedAmountButton(priceCheckBox: priceCheckBox)
    }
}

//MARK:- Funcs
extension InstallmentTableCell {
    
    func showInstallmentTableView() {
        self.tableContentView.isHidden = false
        self.tableTitleView.isHidden = false
        self.installmentInfoView.isHidden = true
        selectFirstIndexOfTableview()
    }
    
    func showInfoView() {
        self.installmentInfoView.isHidden =  priceCheckBox.isSelected ? true : false
        self.tableContentView.isHidden = true
        self.tableTitleView.isHidden = true
        isntallmentTableview.reloadData()
    }
    
    func selectFirstIndexOfTableview() {
        isntallmentTableview.reloadData()
        let indexPath = IndexPath(row:.zero, section: .zero)
        isntallmentTableview.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        self.tableView(isntallmentTableview, didSelectRowAt: indexPath)
    }
    
    func hideInstallmentTableView() {
        self.tableContentView.isHidden = true
        self.tableTitleView.isHidden = true
        self.installmentInfoView.isHidden = true
        isntallmentTableview.reloadData()
    }
    
    func showInstallment(model: [InstallmentDetail]?) {
        installmentModel = model?.first
        let installment = (model?.first?.installmentPrices?.count ?? 0) > 0 ? true : false
        if  !priceCheckBox.isSelected && installment {
            setTableViewHeight(cellCount: installmentModel?.installmentPrices?.count ?? 0)
            showInstallmentTableView()
        } else {
            hideInstallmentTableView()
        }
    }
    
    func setTableViewHeight(cellCount: Int = 4) {
        self.installmentTableViewHeightConst.constant = CGFloat(50 * cellCount)
    }
}

extension InstallmentTableCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installmentModel?.installmentPrices?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InstallmentCell, for: indexPath) as! InstallmentCell
        if installmentModel?.installmentPrices?[indexPath.row].installmentNumber == 1 {
            cell.setFullCell(model: installmentModel)
        } else {
            cell.setInstallmentCell(model: installmentModel?.installmentPrices?[indexPath.row])
        }
        
        return cell
    }
}


extension InstallmentTableCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.priceCheckBox.deSelect()
        let installment = installmentModel?.installmentPrices?[indexPath.row].installmentNumber
        let totalPrice = installmentModel?.installmentPrices?[indexPath.row].totalPrice
        delegate?.getInstallmentNumber(installment: installment, totalPrice: totalPrice)
    }
}
