//
//  InstallmentCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 28.05.2021.
//

import UIKit

class InstallmentCell: UITableViewCell {
    
    
    @IBOutlet weak var installmentCountLabel: UILabel!
    @IBOutlet weak var installmentAmountLabel: UILabel!
    @IBOutlet weak var installmentTotalLabel: UILabel!
    @IBOutlet weak var checkBox: IyzicoCheckBox!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var detailStackView: UIStackView!
//    @IBOutlet weak var titleView: UIView!
//    @IBOutlet weak var titleLabel: UILabel! {
//        didSet {
//            titleLabel.text = "Taksit Seçenekleri"
//            titleLabel.font = .markPro16
//            titleLabel.textColor = .gunmetal
//        }
//    }
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailStackView.setCustomSpacing(16, after: installmentTotalLabel)
        lineView.backgroundColor = .silver
        contentView.backgroundColor = .paleGreyTwo
        setUpCheckBox()
        setupAmountLabel()
        setupCountLabel()
        setupTotalLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkBox.select()
            installmentAmountLabel.font = .markProMedium16
            installmentAmountLabel.textColor = .darkGrey
        } else {
            installmentAmountLabel.font = .markPro16
            installmentAmountLabel.textColor = .blueGrey
            checkBox.deSelect()
        }
    }
    
    func setFullCell(model: InstallmentDetail?) {
        installmentCountLabel.isHidden = true
        installmentAmountLabel.text = StringConstant.shared.iyzicoNoInstallmentLabelText
        installmentTotalLabel.text = model?.installmentPrices?.first?.totalPrice?.asString.addTL
    }
    
    func setInstallmentCell(model: InstallmentPrice?) {
        installmentCountLabel.isHidden = false
        installmentCountLabel.text = "\(model?.installmentNumber ?? 0)"
        installmentAmountLabel.text = "x ₺\(model?.installmentPrice ?? 0)"
        installmentTotalLabel.text = model?.totalPrice?.asString.addTL
    }
    
}

//MARK: - setup
extension InstallmentCell {
    
    fileprivate func setUpCheckBox() {
        checkBox.borderColor = UIColor.silverTwo.cgColor
        checkBox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
        checkBox.cornerRadius = CGFloat(Constant.shared.defaultRadioCornerRadius)
        checkBox.checkBoxType = .radio
        checkBox.isUserInteractionEnabled = false
    }
    
    fileprivate func setupAmountLabel() {
        installmentAmountLabel.font = .markPro16
        installmentAmountLabel.textColor = .blueGrey
    }
    
    fileprivate func setupCountLabel() {
        installmentCountLabel.font = .markProMedium14
        installmentCountLabel.textColor = .darkGrey
    }
    
    fileprivate func setupTotalLabel() {
        installmentTotalLabel.font = .markProMedium14
        installmentTotalLabel.textColor = .darkGrey
        installmentTotalLabel.textAlignment = .right
    }
}
