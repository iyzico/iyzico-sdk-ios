//
//  CreditCardCell.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 26.01.2021.
//

import UIKit

class CreditCardCell: UITableViewCell {

    @IBOutlet weak var topSeperatorView: UIView!
    @IBOutlet weak var iyzicoCardView: IyzicoCardView! {
        didSet {
            iyzicoCardView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            iyzicoCardView.layer.borderColor = UIColor.silver.cgColor
            iyzicoCardView.layer.cornerRadius =  CGFloat(Constant.shared.defaultCornerRadius)
        }
    }
    
    var cardModel: CardResponseModel? {
        didSet {
            guard let validatedCardModel = cardModel else { return }
            #warning("change in prod")
            iyzicoCardView.leftImageView.setImageWithCaching(urlString: validatedCardModel.cardAssociationLogoURL ?? "", placeholderImage: Asset.cards.image)
            iyzicoCardView.bankNameLabel.text = validatedCardModel.cardBankName
            iyzicoCardView.cardNameLabel.text = validatedCardModel.cardType?.value
            iyzicoCardView.cardNumberLabel.text = "*** " + (validatedCardModel.lastFourDigits?.description ?? "")
            iyzicoCardView.cardNameLabel.isHidden = false
            iyzicoCardView.cardNumberLabel.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpiyzicoCardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected {
//            iyzicoCardView.checkBox.select()
//        } else {
//            iyzicoCardView.checkBox.deSelect()
//        }
       
    }
    
    func setCell(indexPath: IndexPath) {
        if indexPath.row == .zero {
            topSeperatorView.isHidden = false
        } else {
            topSeperatorView.isHidden = true
        }
    }
}

//MARK:- Action
extension CreditCardCell {
    
    @IBAction func didTappedCreditButton(_ sender: Any) { // disable suan
        
    }
}

//MARK:- Setup UI
extension CreditCardCell {
    
    fileprivate func setUpiyzicoCardView() {
//        iyzicoCardView.leftImage = Asset.cards.image
//        iyzicoCardView.bankName = "ZIRAAT BANKASI"
//        iyzicoCardView.cardName = "Kredi Kartı"
//        iyzicoCardView.cardNameLabel.isHidden = false
//        iyzicoCardView.cardNumber = "*** 9020"
//        iyzicoCardView.cardNumberLabel.isHidden = false
        setUpCheckBox()
    }
    
    fileprivate func setUpCheckBox() {
        iyzicoCardView.checkBox.borderColor = UIColor.silverTwo.cgColor
        iyzicoCardView.checkBox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
        iyzicoCardView.checkBox.cornerRadius = CGFloat(Constant.shared.defaultRadioCornerRadius)
        iyzicoCardView.checkBox.checkBoxType = .radio
        iyzicoCardView.checkBox.isUserInteractionEnabled = false
    }
}
