//
//  UseBalanceCell.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 23.03.2022.
//

import UIKit

class UseBalanceCell: UITableViewCell {

    @IBOutlet weak var myBalanceView: IyzicoTermAndCond! {
        didSet {
            myBalanceView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            myBalanceView.layer.borderColor = UIColor.silver.cgColor
            myBalanceView.layer.cornerRadius = CGFloat(Constant.shared.defaultCornerRadius)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(balance: MemberBalance?) {
        #warning("bakiyemi kullan icin localization yapilacak")
        guard let balanceAsCurrency = balance?.amount?.currencyFormatting() else { return }
        myBalanceView.isHidden = false
        myBalanceView.setUpTermView(title: "\(balanceAsCurrency) Bakiyemi Kullan",
                                    highlightedTexts: [balanceAsCurrency],
                                    plainFont: .markPro14,
                                    linkNames: [""],
                                    highletedFont: .markProMedium14,
                                    alignment: .left)
        myBalanceView.termTextView.textColor = .darkGrey
        myBalanceView.checkBoxisEnable = true
        myBalanceView.switchisEnable = false
        myBalanceView.isInfoImageViewEnable = false
        myBalanceView.checkBox.borderWidth = 2
        myBalanceView.checkBox.topAnchor.constraint(equalTo: myBalanceView.checkBoxView.layoutMarginsGuide.topAnchor, constant: .zero).isActive = true
        myBalanceView.termTextView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    }
    
}

