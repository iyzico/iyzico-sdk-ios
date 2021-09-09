//
//  bankCell.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 22.12.2020.
//

import UIKit

class BankCell: BaseTableViewCell {

    @IBOutlet weak var bankNameLabel: UILabel! {
        didSet {
            bankNameLabel.font = .markPro14
            bankNameLabel.textColor = .darkGrey
        }
    }
    @IBOutlet weak var bankImageView: UIImageView! {
        didSet {
//            bankImageView.image = Asset.calendar.image
        }
    }
    @IBOutlet weak var seperatorView: UIView! {
        didSet {
            seperatorView.backgroundColor = .paleGreyTwo
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
    
    func setCell(bankName: String, bankLogoUrl: String?, placeholderBankLogo: UIImage) {
        self.bankNameLabel.text = bankName
//        self.bankImageView.setImage(named: bankImage, typeof: self)
        self.bankImageView.setImageWithCaching(urlString: bankLogoUrl, placeholderImage: placeholderBankLogo)
    }
    
}
