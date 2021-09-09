//
//  NewCardCell.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 26.01.2021.
//

import UIKit
protocol NewCardCellDelegate: class {
    func expandAddCard(cell: NewCardCell)
   // func didTappedAmountButton(priceCheckBox: IyzicoCheckBox)
    func didGetAllInputs(inputModels: [IyzicoTextInputModel])
    func checkCardInstallment(binNumber: String?)
   // func getInstallmentNumber(installment: Int?, totalPrice: Double?)
}
class NewCardCell: UITableViewCell {
    
    weak var delegate: NewCardCellDelegate?
    
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
        }
    }
    
    @IBOutlet weak var cardLabel: UILabel! {
        didSet {
            cardLabel.text = StringConstant.shared.newCardCellCardText
            cardLabel.font = .markProBold16
            cardLabel.textColor = .niceBlue
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
                    cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                               placeholder: "1234")
                    cardCodeTextInput.cvvCount = 4
                } else {
                    cardCodeTextInput.configureTextInputLayout(shouldTitleStackViewVisible: false,
                                                               placeholder: StringConstant.shared.newCardCellCardCodePlaceholder)
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
            
            if SDKManager.flow == .payWithIyzico {
                cardNumberTextInput.shouldChangeCharactersIn = { [unowned self] text in
                    if self.startCardInstallment(text: text) {
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
//            withDrawAmountLabel.text = "Kartınızdan ₺68,70 çekilecektir.".uppercased()
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
//
//    func setTableViewHeight(cellCount: Int = 4) {
//        self.installmentTableViewHeightConst.constant = CGFloat(50 * cellCount)
//    }
    
    func expandCard(isHidden: Bool) {
//        UIView.animate(withDuration: Constant.shared.duration) {
//            self.detailView.isHidden = isHidden
//        }
        self.detailView.isHidden = isHidden
//        self.installmentInfoView.isHidden = isHidden
//        if self.tableContentView.isHidden == false || self.isCardInfoValid() || priceCheckBox.isSelected {
//            self.installmentInfoView.isHidden = true
//        }
//        self.installmentInfoView.isHidden = isHidden
//        if self.tableContentView.isHidden == false || self.isCardInfoValid() {
//            self.installmentInfoView.isHidden = true
//        }
//
    }
    
//    func showInstallment(model: [InstallmentDetail]?) {
//        installmentModel = model?.first
//        let installment = (model?.first?.installmentPrices?.count ?? 0) > 0 ? true : false
//        if (!iyzicoCheckBox.isSelected || isCardInfoValid()) && !priceCheckBox.isSelected &&  installment {
//            setTableViewHeight(cellCount: installmentModel?.installmentPrices?.count ?? 0)
//            showInstallmentTableView()
//        } else {
//            hideInstallmentTableView()
//        }
//       // isntallmentTableview.reloadData()
//    }
//
//    func hideInstallment() {
//        self.installmentInfoView.isHidden = true
//        hideInstallmentTableView()
//    }
    
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
    
    
    func isAllinputsValid() {
        if self.cardCodeTextInput.isInputValid &&
           self.cardUserTextInput.isInputValid &&
           self.cardDateTextInput.isInputValid &&
           self.cardNumberTextInput.isInputValid {
//           self.installmentInfoView.isHidden = priceCheckBox.isSelected
//           self.tableTitleView.isHidden = priceCheckBox.isSelected
//           self.tableContentView.isHidden = priceCheckBox.isSelected
         //  selectFirstIndexOfTableview()
          // delegate?.expandAddCard(cell: self)
          
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
//        iyzicoCheckBox.setSelected()
      //  self.installmentInfoView.isHidden = false
       // hideInstallmentTableView()
        expandCard(isHidden: iyzicoCheckBox.isSelected)
        delegate?.expandAddCard(cell: self)
        
    }
    
    @IBAction func didTappedAmountButton(_ sender: Any) {
   //     delegate?.didTappedAmountButton(priceCheckBox: priceCheckBox)
//        if priceCheckBox.isSelected {
//            hideInstallmentTableView()
//            self.installmentInfoView.isHidden = true
//            //delegate?.hideShowInstallment(cell: self)
//        } else if isCardInfoValid() && !priceCheckBox.isSelected {
//            showInstallmentTableView()
//          //  delegate?.hideShowInstallment(cell: self)
//        } else if !iyzicoCheckBox.isSelected  {
//            //showInstallmentTableView()
//           // delegate?.hideShowInstallment(cell: self)
//        }
    }
//
//    func showInstallmentTableView() {
//        self.tableContentView.isHidden = false
//        self.tableTitleView.isHidden = false
//        selectFirstIndexOfTableview()
//
//    }
    
//    func selectFirstIndexOfTableview() {
//        isntallmentTableview.reloadData()
//        let indexPath = IndexPath(row:.zero, section: .zero)
//        isntallmentTableview.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
//        self.tableView(isntallmentTableview, didSelectRowAt: indexPath)
//    }
//
//    func hideInstallmentTableView() {
//        self.tableContentView.isHidden = true
//        self.tableTitleView.isHidden = true
//        isntallmentTableview.reloadData()
//    }
}

//extension NewCardCell: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return installmentModel?.installmentPrices?.count ?? .zero
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.InstallmentCell, for: indexPath) as! InstallmentCell
//        if installmentModel?.installmentPrices?[indexPath.row].installmentNumber == 1 {
//            cell.setFullCell(model: installmentModel)
//        } else {
//            cell.setInstallmentCell(model: installmentModel?.installmentPrices?[indexPath.row])
//        }
//
//        return cell
//    }
//}
//
//
//extension NewCardCell: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.priceCheckBox.deSelect()
//        let installment = installmentModel?.installmentPrices?[indexPath.row].installmentNumber
//        let totalPrice = installmentModel?.installmentPrices?[indexPath.row].totalPrice
//      //  delegate?.getInstallmentNumber(installment: installment, totalPrice: totalPrice)
//    }
//}


