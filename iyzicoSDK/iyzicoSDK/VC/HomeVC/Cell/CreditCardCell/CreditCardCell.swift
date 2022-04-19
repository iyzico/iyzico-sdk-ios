//
//  CreditCardCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 26.01.2021.
//

import UIKit

class CreditCardCell: UITableViewCell {

    @IBOutlet weak var topSeperatorView: UIView!
    @IBOutlet weak var bottomSeperatorView: UIView!
    @IBOutlet weak var installmentOfferView: UIView!
    @IBOutlet weak var installmentOfferLabel: UILabel!
    @IBOutlet weak var cardInfoTopSeperatorView: UIView!
    @IBOutlet weak var cardInfoBottomSeperatorView: UIView!
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var cardInfoLabel: UILabel! {
        didSet {
            cardInfoLabel.textColor = .gray600
        }
    }
    
    
    @IBOutlet weak var iyzicoCardView: IyzicoCardView! {
        didSet {
            iyzicoCardView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            iyzicoCardView.layer.borderColor = UIColor.silver.cgColor
            iyzicoCardView.layer.cornerRadius =  CGFloat(Constant.shared.defaultCornerRadius)
        }
    }
    
    #warning("KART ISMI BURADA AYARLANIYOR")
    var cardModel: CardResponseModel? {
        didSet {
            guard let validatedCardModel = cardModel else { return }
            #warning("change in prod")
            if cardModel?.isDisabled == true {
                iyzicoCardView.leftImageView.image = Asset.passiveCard.image
            } else {
                iyzicoCardView.leftImageView.setImageWithCaching(urlString: validatedCardModel.cardAssociationLogoURL ?? "", placeholderImage: Asset.cards.image)
            }
            iyzicoCardView.bankNameLabel.text = validatedCardModel.cardBankName
            if validatedCardModel.iyzicoCard == true {
                if validatedCardModel.iyzicoVirtualCard == true {
                    iyzicoCardView.cardNameLabel.text = "Sanal Kart"
                } else {
                    iyzicoCardView.cardNameLabel.text = "Kart"
                }
            } else if validatedCardModel.iyzicoVirtualCard == true {
                iyzicoCardView.cardNameLabel.text = "Sanal Kart"
            } else {
                iyzicoCardView.cardNameLabel.text = validatedCardModel.cardType?.value
            }
            iyzicoCardView.cardNumberLabel.text = "\u{2022}\u{2022}\u{2022} " + (validatedCardModel.lastFourDigits?.description ?? "")
            iyzicoCardView.cardNameLabel.isHidden = false
            iyzicoCardView.cardNumberLabel.isHidden = false
//            print(cardModel?.cardBankName)
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
    
    func setCell(indexPath: IndexPath, isDisabled: Bool) {
        if indexPath.row == .zero {
            topSeperatorView.isHidden = false
            bottomSeperatorView.isHidden = false
            installmentOfferView.isHidden = false
            cardInfoTopSeperatorView.isHidden = false
            cardInfoBottomSeperatorView.isHidden = false
            cardInfoView.isHidden = false
        } else {
            topSeperatorView.isHidden = true
            bottomSeperatorView.isHidden = true
            installmentOfferView.isHidden = true
            cardInfoTopSeperatorView.isHidden = true
            cardInfoBottomSeperatorView.isHidden = true
            cardInfoView.isHidden = true
        }
        if isDisabled {
            iyzicoCardView.bankNameLabel.textColor = .coolGrey
            iyzicoCardView.cardNameLabel.textColor = .coolGrey
            iyzicoCardView.cardNumberLabel.textColor = .coolGrey
            cardInfoTopSeperatorView.isHidden = false
            cardInfoBottomSeperatorView.isHidden = false
            cardInfoView.isHidden = false
        } else {
            iyzicoCardView.bankNameLabel.textColor = .coolGrey
            iyzicoCardView.cardNameLabel.textColor = .darkGrey
            iyzicoCardView.cardNumberLabel.textColor = .darkGrey
            cardInfoTopSeperatorView.isHidden = true
            cardInfoBottomSeperatorView.isHidden = true
            cardInfoView.isHidden = true
        }
//        guard let validatedCardModel = cardModel else { return }
//        iyzicoCardView.leftImageView.setImageWithCaching(urlString: validatedCardModel.cardAssociationLogoURL ?? "", placeholderImage: Asset.cards.image)
    }
}

//MARK:- Action
extension CreditCardCell {
    
    @IBAction func didTappedCreditButton(_ sender: Any) { // disable suan
        
    }
}

//MARK:- Setup UI
extension CreditCardCell {
    
    func setInfoView(isHidden: Bool) {
        installmentOfferView.isHidden = isHidden
        installmentOfferLabel.isHidden = isHidden
    }
//    , totalBonusAmount: Int, usableBonusAmount: Int
    
    func setBonusView(isHidden: Bool, enableSecondLabel: Bool = false, totalBonusAmount: Double = 0.0, usableBonusAmount: Double = 0.0) {
        iyzicoCardView.bonusStackView.isHidden = isHidden
        iyzicoCardView.bonusTotalView.totalStackView.isHidden = isHidden
        iyzicoCardView.topEmptyView.isHidden = isHidden
        
        if isHidden {
            iyzicoCardView.bonusTotalView.useBonusCheckbox.deSelect()
        }
        iyzicoCardView.bonusTotalView.totalStackView.isHidden = !enableSecondLabel
        iyzicoCardView.bonusTotalView.totalAmount = totalBonusAmount
        iyzicoCardView.bonusTotalView.usableAmount = usableBonusAmount
    }
    
    fileprivate func setUpiyzicoCardView() {
//        iyzicoCardView.leftImage = Asset.cards.image
//        iyzicoCardView.bankName = "ZIRAAT BANKASI"
//        iyzicoCardView.cardName = "Kredi Kartı"
//        iyzicoCardView.cardNameLabel.isHidden = false
//        iyzicoCardView.cardNumber = "*** 9020"
//        iyzicoCardView.cardNumberLabel.isHidden = false
        installmentOfferView.backgroundColor = .veryLightGreen
        installmentOfferView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        installmentOfferView.layer.masksToBounds = true
        installmentOfferLabel.text = "Akbank veya Vakıfbank kartınla kartınla yapacağın taksitli alışverişlerde vade farksız + 3 Taksit!"
        installmentOfferLabel.textColor = .mediumGreenTwo
        installmentOfferLabel.numberOfLines = .zero
        installmentOfferLabel.font = .markPro14
        installmentOfferLabel.textAlignment = .center
        
        cardInfoView.backgroundColor = .clear
        cardInfoLabel.text = "Bakiyen yetersiz olduğu için iyzico Kart’ın ile ödeme yapılamıyor."
        cardInfoLabel.font = .markPro14
        cardInfoLabel.textAlignment = .left
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
