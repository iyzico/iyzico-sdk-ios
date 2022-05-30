//
//  NewCardCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 26.01.2021.
//

import UIKit
protocol NewCardCellDelegate: AnyObject {
    func expandAddCard(cell: NewCardCell)
    func didGetAllInputs(inputModels: [IyzicoTextInputModel])
    func checkCardInstallment(binNumber: String?)
    func checkCardBonus()
}

class NewCardCell: UITableViewCell {
    
    weak var delegate: NewCardCellDelegate?
    
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var bottomSeperator: UIView!
    @IBOutlet weak var installmentOfferView: UIView! {
        didSet {
            installmentOfferView.backgroundColor = .veryLightGreen
            installmentOfferView.layer.cornerRadius = Constant.shared.defaultCornerRadius
            installmentOfferView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var installmentOfferLabel: UILabel! {
        didSet {
            installmentOfferLabel.textColor = .mediumGreenTwo
            installmentOfferLabel.numberOfLines = .zero
            installmentOfferLabel.font = .markPro14
            installmentOfferLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            backView.layer.borderColor = UIColor.silver.cgColor
            backView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        }
    }
    @IBOutlet weak var amaountBackView: UIView! {
        didSet {
            amaountBackView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            amaountBackView.layer.borderColor = UIColor.silver.cgColor
            amaountBackView.layer.cornerRadius = Constant.shared.defaultCornerRadius
        }
    }
    
    @IBOutlet weak var plusImageView: UIImageView! {
        didSet {
            plusImageView.image = Asset.basicPlus.image
            plusImageView.tintColor = .black
        }
    }
    
    @IBOutlet weak var cardLabel: UILabel! {
        didSet {
            cardLabel.text = StringConstant.shared.newCardCellCardText
            cardLabel.font = .markProBold16
            cardLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var iyzicoCheckBox: IyzicoCheckBox! {
        didSet {
            iyzicoCheckBox.borderColor = UIColor.silverTwo.cgColor
            iyzicoCheckBox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
            iyzicoCheckBox.cornerRadius = Constant.shared.defaultRadioCornerRadius
            iyzicoCheckBox.checkBoxType = .radio
        }
    }
    @IBOutlet weak var cardUserTextInput: IyzicoTextInput! {
        didSet {
            cardUserTextInput.textField.autocorrectionType = .no
            cardUserTextInput.textField.autocapitalizationType = .words
            cardUserTextInput.commonViewSetup(textInputType: .cardOwnerName,
                                              title:  StringConstant.shared.newCardCellCardUserText,
                                              keyboardType: .default,
                                              placeholder: StringConstant.shared.newCardCellCardUserPlaceholder,
                                              showBorder: true)
            cardUserTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                       placeholder: StringConstant.shared.newCardCellCardUserPlaceholder)
            cardUserTextInput.textFieldDidEndEditing = { [unowned self] text in
                self.cardUserTextInput.isInputValid = true
                if text == "" {
                    self.cardUserTextInput.showError(text: "İsim Zorunlu")
                    self.cardUserTextInput.isInputValid = false
                }
                else if !ValidationManager.nilValidation(text: text) {
                    self.cardUserTextInput.showError(text: "Hatalı isim girdiniz")
                    self.cardUserTextInput.isInputValid = false
                }
                else {
                    self.cardUserTextInput.isInputValid = true
                }
                self.delegate?.didGetAllInputs(inputModels: self.getAllInputs())
                isAllinputsValid()
            }
        }
    }
    
    @IBOutlet weak var cardNumberTextInput: IyzicoTextInput!{
        didSet {
            cardNumberTextInput.textField.autocorrectionType = .no
            cardNumberTextInput.commonViewSetup(textInputType: .cardNumber,
                                                title: StringConstant.shared.newCardCellCardNumberText,
                                                keyboardType: .decimalPad,
                                                placeholder: StringConstant.shared.newCardCellCardNumberPlaceholder,
                                                showBorder: true)
            cardNumberTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                         placeholder: StringConstant.shared.newCardCellCardNumberPlaceholder)
            cardNumberTextInput.textFieldDidEndEditing = { [unowned self] text in
                if text == "" {
                    self.cardNumberTextInput.showError(text: "Kart numarası zorunlu")
                    self.cardNumberTextInput.isInputValid = false
                }
                else if !ValidationManager.cardNumberValidation(text: text) {
                    self.cardNumberTextInput.showError(text: "Hatalı numara girdiniz")
                    self.cardNumberTextInput.isInputValid = false
                }
                else {
                    self.cardNumberTextInput.isInputValid = true
                }
                if ValidationManager.validate(text: text, cardBrand: .AMEX) {
                    cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: !cardCodeTextInput.isTextFieldEmpty,
                                                               placeholder: "1234",
                                                               cardCodeErrorStatus: !cardCodeTextInput.isInputValid)
                    cardCodeTextInput.cvvCount = 4
                } else {
                    cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: !cardCodeTextInput.isTextFieldEmpty,
                                                               placeholder: StringConstant.shared.newCardCellCardCodePlaceholder,
                                                               cardCodeErrorStatus: !cardCodeTextInput.isInputValid)
                    cardCodeTextInput.cvvCount = 3
                }
                self.delegate?.didGetAllInputs(inputModels: self.getAllInputs())
                isAllinputsValid()
            }
            cardNumberTextInput.didPastedTextAction = { [unowned self] in
                //                cardNumberTextInput.pasteTextEnabled = false
                let pastedText = UIPasteboard.general.string
                let pastedTextWithoutWhiteSpaces = pastedText?.replacingOccurrences(of: " ", with: "")
                if pastedTextWithoutWhiteSpaces?.count == 16 {
                    cardNumberTextInput.textField.text = pastedText?.separate(every: 4, with: " ")
                    if self.startCardInstallment(text: pastedText) {
                        delegate?.checkCardInstallment(binNumber: "\(pastedText?.prefix(6) ?? "")")
                    }
                } else if pastedTextWithoutWhiteSpaces?.count == 15 && ValidationManager.validate(text: pastedText, cardBrand: .AMEX) {
                    if self.startCardInstallment(text: pastedText) {
                        delegate?.checkCardInstallment(binNumber: "\(pastedText?.prefix(6) ?? "")")
                    }
                }
                else {
                    cardNumberTextInput.textField.text = ""
                }
            }
            
            if SDKManager.flow == .payWithIyzico || SDKManager.flow == .topUp {
                cardNumberTextInput.shouldChangeCharactersIn = { [unowned self] text, replacementString in
                    if self.startCardInstallment(text: text) && !replacementString.isBackspace {
                        delegate?.checkCardInstallment(binNumber: text.removeWhiteSpaces)
                    }
                }
            }
            
        }
    }
    
    @IBOutlet weak var cardDateTextInput: IyzicoTextInput! {
        didSet {
            cardDateTextInput.textField.autocorrectionType = .no
            cardDateTextInput.commonViewSetup(textInputType: .shortDate,
                                              title: StringConstant.shared.newCardCellCardDateText,
                                              keyboardType: .numberPad,
                                              placeholder: StringConstant.shared.newCardCellCardDatePlaceholder,
                                              showBorder: true)
            cardDateTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                       placeholder: StringConstant.shared.newCardCellCardDatePlaceholder)
            cardDateTextInput.textFieldDidEndEditing = { [unowned self] text in
                self.cardDateTextInput.isInputValid = true
                if text == ""{
                    self.cardDateTextInput.showError(text: "Skt. Zorunlu")
                    self.cardDateTextInput.isInputValid = false
                }
                else if !ValidationManager.sktDateValidation(text: text) {
                    self.cardDateTextInput.showError(text: "Skt. Hatalı")
                    self.cardDateTextInput.isInputValid = false
                }
                else {
                    self.cardDateTextInput.isInputValid = true
                }
                self.delegate?.didGetAllInputs(inputModels: self.getAllInputs())
                isAllinputsValid()
            }
        }
    }
    
    @IBOutlet weak var cardCodeTextInput: IyzicoTextInput! {
        didSet {
            cardCodeTextInput.rightViewForCVV.isHidden = false
            cardCodeTextInput.rightImageViewForCVV.image = Asset.informativeCvc.image
            cardCodeTextInput.textField.autocorrectionType = .no
            cardCodeTextInput.commonViewSetup(textInputType: .securityCode,
                                              title: StringConstant.shared.newCardCellCardCodeText,
                                              keyboardType: .numberPad, placeholder: StringConstant.shared.newCardCellCardCodePlaceholder,
                                              showBorder: true,
                                              isRightViewHidden: true,
                                              rightImage: Asset.informativeCvc.name,
                                              stackViewSpace: .zero)
            cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                       placeholder: StringConstant.shared.newCardCellCardCodePlaceholder)
            cardCodeTextInput.textFieldDidEndEditing = { [unowned self] text in
                self.cardCodeTextInput.isInputValid = true
                if text == "" {
                    self.cardCodeTextInput.showError(text: "CVV Zorunlu")
                    self.cardCodeTextInput.isInputValid = false
                }
                else if !ValidationManager.cvvValidation(text: text) {
                    self.cardCodeTextInput.showError(text: "CVV Hatalı")
                    self.cardCodeTextInput.isInputValid = false
                }
                else {
                    self.cardCodeTextInput.isInputValid = true
                }
                self.delegate?.didGetAllInputs(inputModels: self.getAllInputs())
                isAllinputsValid()
            }
        }
    }
    
    @IBOutlet weak var totalBonusView: IyzicoCardBonusView!
    @IBOutlet weak var infoImageView: UIImageView! {
        didSet {
            infoImageView.image = Asset.basicIcnInfo.image
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = StringConstant.shared.newCardCellCardInfoText
            infoLabel.font = .markPro14
            infoLabel.textColor = .coolGrey
        }
    }
    
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
            priceLabel.text = "₺44,00"
            priceLabel.font = .markProMedium14
            priceLabel.textColor = .darkGrey
            priceLabel.textAlignment = .right
        }
    }
    
    @IBOutlet weak var withDrawAmountLabel: UILabel! {
        didSet {
            withDrawAmountLabel.font = .markProMedium12
            withDrawAmountLabel.textColor = .blueGrey
        }
    }
    
    @IBOutlet weak var seperatorView: UIView! {
        didSet {
            seperatorView.backgroundColor = .paleGrey
        }
    }
    
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var withDrawView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var priceContainerStackView: UIStackView!
    @IBOutlet weak var newCardTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var installmentTableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var isntallmentTableview: UITableView! {
        didSet {
            isntallmentTableview.rowHeight = UITableView.automaticDimension
            isntallmentTableview.estimatedRowHeight = UITableView.automaticDimension
            isntallmentTableview.tableFooterView = .init(frame: .zero)
            isntallmentTableview.separatorStyle = .none
            // isntallmentTableview.delegate = self
            //isntallmentTableview.dataSource = self
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
            installmentInfoLabel.text = StringConstant.shared.iyzicoHomeVCInstallmentInfoText
            installmentInfoLabel.font = .markPro14
            installmentInfoLabel.textColor = .blueGrey
            
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
    
    func setCellWithBonus(cardName: String?, cardNumber: String?, cvv: String?, skt: String?) {
        
        //        installmentOfferLabel.text = "Akbank veya Vakıfbank kartınla kartınla yapacağın taksitli alışverişlerde vade farksız + 3 Taksit!"
        
        if cardName?.isEmpty == false {
            cardUserTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                       placeholder: "")
            cardUserTextInput.textField.text = cardName ?? ""
            cardUserTextInput.isInputValid = true
        }
        
        if cardNumber?.isEmpty == false {
            cardNumberTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                         placeholder: "")
            setCardNumber(cardNumber: cardNumber)
            cardNumberTextInput.isInputValid = true
        }
        if cvv?.isEmpty == false {
            cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                       placeholder: "")
            cardCodeTextInput.textField.text = cvv ?? ""
            cardCodeTextInput.isInputValid = true
        }
        if skt?.isEmpty == false {
            cardDateTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                       placeholder: "")
            cardDateTextInput.textField.text = skt ?? ""
            cardDateTextInput.isInputValid = true
        }
    }
    
    private func setCardNumber(cardNumber: String?) {
        let pastedTextWithoutWhiteSpaces = cardNumber?.replacingOccurrences(of: " ", with: "")
        if pastedTextWithoutWhiteSpaces?.count == 16 {
            cardNumberTextInput.textField.text = cardNumber?.separate(every: 4, with: " ")
        }
        else {
            cardNumberTextInput.textField.text = ""
        }
        cardNumberTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                     placeholder: "")
    }
    
    private func setCardCode(cardCode: String?) {
        cardCodeTextInput.commonViewSetup(textInputType: .securityCode,
                                          title: StringConstant.shared.newCardCellCardCodeText,
                                          keyboardType: .numberPad,
                                          placeholder: StringConstant.shared.newCardCellCardCodePlaceholder,
                                          showBorder: true,
                                          isRightViewHidden: true,
                                          rightImage: Asset.informativeCvc.name,
                                          stackViewSpace: .zero)
        cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: true,
                                                   placeholder: "")
        cardCodeTextInput.textField.text = cardCode ?? ""
    }
    
    func setInfoView(model: [PlusInstallmentResponseModel]?) {
        guard let model = model else {
            installmentOfferLabel.isHidden = true
            installmentOfferView.isHidden = true
            topSeperator.isHidden = true
            //            bottomSeperator.isHidden = true
            return
        }
        switch model.count {
            case 0:
                installmentOfferLabel.isHidden = true
                installmentOfferView.isHidden = true
                topSeperator.isHidden = true
                bottomSeperator.isHidden = false
            case 1:
                installmentOfferLabel.addAttribute(text: "\(model[0].cardBankDtoList?[0].cardBankName ?? "") kartınla yapacağın taksitli alışverişlerde vade farksız + \(model[0].plusInstallment ?? "0") Taksit!", attText: "vade farksız + \(model[0].plusInstallment ?? "0") Taksit!", color: .mediumGreenTwo, highletedFont: .markProBold14, isCenter: true)
                installmentOfferView.isHidden = false
                installmentOfferLabel.isHidden = false
                topSeperator.isHidden = false
                bottomSeperator.isHidden = true
            default:
                let plusInstallmentCountText = model[0].plusInstallment == model[1].plusInstallment ? "+ \(model[0].plusInstallment ?? "0")" : "+ \(model[0].plusInstallment ?? "0") ve + \(model[1].plusInstallment ?? "0")"
                installmentOfferLabel.addAttribute(text: "\(model[0].cardBankDtoList?[0].cardBankName ?? "") veya \(model[0].cardBankDtoList?[1].cardBankName ?? "") kartınla yapacağın taksitli alışverişlerde vade farksız  \(plusInstallmentCountText) Taksit!", attText: "vade farksız  \(plusInstallmentCountText) Taksit!", color: .mediumGreenTwo, highletedFont: .markProBold14, isCenter: true)
                installmentOfferLabel.isHidden = false
                installmentOfferView.isHidden = false
                topSeperator.isHidden = false
                bottomSeperator.isHidden = true
        }
        
    }
    
    func setBonusView(isHidden: Bool, enableSecondLabel: Bool = false, totalBonusAmount: Double = 0.0, usableBonusAmount: Double = 0.0) {
        totalBonusView.isHidden = isHidden
        totalBonusView.totalStackView.isHidden = isHidden
        
        if isHidden {
            totalBonusView.useBonusCheckbox.deSelect()
        }
        totalBonusView.totalStackView.isHidden = !enableSecondLabel
        totalBonusView.totalAmount = totalBonusAmount
        totalBonusView.usableAmount = usableBonusAmount
    }
    
    func expandCard(isHidden: Bool) {
        self.detailView.isHidden = isHidden
        self.infoView.isHidden = isHidden
    }
    
    //MARK: - Helper Methods
    func getAllInputs() -> [IyzicoTextInputModel] {
        let textInputs = [IyzicoTextInputModel(input: cardUserTextInput,
                                               requiredMessage: "İsim Zorunlu",
                                               notValidMessage: "Hatalı isim girdiniz"),
                          IyzicoTextInputModel(input: cardNumberTextInput,
                                               requiredMessage: "Kart numarası zorunlu",
                                               notValidMessage: "Hatalı numara girdiniz"),
                          IyzicoTextInputModel(input: cardDateTextInput,
                                               requiredMessage: "Skt. Zorunlu",
                                               notValidMessage: "Skt. Hatalı"),
                          IyzicoTextInputModel(input: cardCodeTextInput,
                                               requiredMessage: "CVV Zorunlu",
                                               notValidMessage: "CVV Hatalı")]
        return textInputs
    }
    
    var isBonusEnabled: Bool = false
    
    func isAllinputsValid() {
        if self.cardCodeTextInput.isInputValid &&
            self.cardUserTextInput.isInputValid &&
            self.cardDateTextInput.isInputValid &&
            self.cardNumberTextInput.isInputValid {
            delegate?.checkCardBonus()
        }
    }
    
    func isCardInfoValid() -> Bool {
        if self.cardCodeTextInput.isInputValid &&
            self.cardUserTextInput.isInputValid &&
            self.cardDateTextInput.isInputValid &&
            self.cardNumberTextInput.isInputValid {
            return true
        } else {
            return false
        }
    }
    
    private func startCardInstallment(text: String?) -> Bool {
        if (text?.removeWhiteSpaces.count ?? .zero) >= 0  {
            return  true
        }
        return false
    }
    
}
//MARK:- Actions
extension NewCardCell {
    
    @IBAction func didTappedNewCardButton(_ sender: Any) {
        expandCard(isHidden: iyzicoCheckBox.isSelected)
        delegate?.expandAddCard(cell: self)
    }
    
    @IBAction func didTappedAmountButton(_ sender: Any) {
        
    }
}
