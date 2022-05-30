//
//  IyzicoCardView.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 10.12.2020.
//

import Foundation
import UIKit

enum CardType: Int {
    case creditCard = 0
    case account
}

class IyzicoCardView: BaseView {
    
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var innerStackView: UIStackView! {
        didSet {
            innerStackView.setCustomSpacing(.zero, after: cardNumberView)
            innerStackView.setCustomSpacing(.zero, after: cardDetailView)
            innerStackView.setCustomSpacing(.zero, after: emptyView)
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bonusStackView: UIStackView!
    @IBOutlet weak var bonusTotalView: IyzicoCardBonusView!
    @IBOutlet weak var checkBox: IyzicoCheckBox!
    @IBOutlet weak var topEmptyView: UIView!
    
    var isChecked: Bool {
        return checkBox.isSelected
    }
    var cardType: CardType = .creditCard {
        didSet {
            if cardType == .creditCard {
                setUpCreditCardView()
            } else {
                setUpAccountView()
            }
            //leftImageView.image = UIImage(named: lefImage)
        }
    }
    
    @IBInspectable public var leftImage: UIImage = UIImage()  {
        didSet {
            leftImageView.image = leftImage
        }
    }
    @IBInspectable public var bankName: String = ""  {
        didSet {
            bankNameLabel.text = bankName
        }
    }
    @IBInspectable public var cardName: String = ""  {
        didSet {
            cardNameLabel.text = cardName
        }
    }
    @IBInspectable public var cardNumber: String = ""  {
        didSet {
            cardNumberLabel.text = cardNumber
        }
    }
    @IBInspectable public var account: String = ""  {
        didSet {
            accountLabel.text = account
        }
    }
    @IBInspectable public var amount: String = ""  {
        didSet {
            amountLabel.text = amount
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = Constant.shared.defaultCornerRadius  {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.addBorder(borderColor: UIColor.silver.cgColor)
        }
    }
    
    // MARK: - Init
    init(cardType: CardType, leftImage: UIImage, cornerRadius: CGFloat =  Constant.shared.defaultCornerRadius) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        self.loadViewFromNib()
        defer {
            self.cardType = cardType
            self.leftImage = leftImage
            self.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    //MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoCardView, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpView()
    }
}

//MARK: - Helper Funcs
extension IyzicoCardView {
    
    fileprivate func setUpView() {
        setUpContentView()
        setUpLeftImageView()
        setUpBankNameLabel()
        setUpCardNameLabel()
        setUpCardNumberLabel()
        setUpAccountLabel()
        setUpAmountLabel()
        setUpCheckBox()
        self.bonusStackView.isHidden = true
        self.topEmptyView.isHidden = true
    }
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    fileprivate func setUpLeftImageView() {
        leftImageView.image = leftImage
    }
    
    fileprivate func setUpBankNameLabel() {
        bankNameLabel.font = .markProBold12
        bankNameLabel.textColor = .gray600
    }
    
    fileprivate func setUpCardNameLabel() {
        cardNameLabel.font = .markProMedium16
        cardNameLabel.textColor = .gray900
    }
    
    fileprivate func setUpCardNumberLabel() {
        cardNumberLabel.font = .markProMedium16
        cardNumberLabel.textAlignment = .right
        cardNumberLabel.textColor = .gray900
    }
    
    fileprivate func setUpAccountLabel() {
        accountLabel.font = .markPro14
        accountLabel.textColor = .gray900
    }
    
    fileprivate func setUpAmountLabel() {
        amountLabel.font = .markProMedium18
        amountLabel.textColor = .gray700
    }
    
    fileprivate func setUpCreditCardView() {
        bankNameLabel.isHidden = false
        cardNameLabel.isHidden = false
        cardNumberLabel.isHidden = false
        accountLabel.isHidden = true
        amountLabel.isHidden = true
    }
    
    fileprivate func setUpAccountView() {
        bankNameLabel.isHidden = true
        cardNameLabel.isHidden = true
        cardNumberLabel.isHidden = true
        accountLabel.isHidden = false
        amountLabel.isHidden = false
    }
    
    fileprivate func setUpCheckBox() {
        checkBox.borderColor = UIColor.gray400.cgColor
        checkBox.checkBoxType = .radio
    }
}
