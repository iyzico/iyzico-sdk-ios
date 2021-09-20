//
//  IyzicoTextInput.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 8.12.2020.
//

import UIKit

class IyzicoTextInput: BaseView {
    @IBOutlet weak var titleContainerStackView: UIStackView!
    @IBOutlet weak var stackViewLeftConst: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightViewForCVV: UIView!
    @IBOutlet weak var rightImageViewForCVV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak public var textField: CustomTextField!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var rightButtonTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var rightViewWidthConst: NSLayoutConstraint!
    
    
    @IBInspectable public var borderColor: UIColor = .white {
        didSet {
            contentView.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = .zero {
        didSet {
            contentView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var flagBackGroundColor: UIColor = .white {
        didSet {
            leftView.backgroundColor = flagBackGroundColor
        }
    }
    
    @IBInspectable public var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable public var flagImage: String? {
        didSet {
            leftImageView.setImage(named: flagImage!, typeof: self)
            
        }
    }
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet {
            contentStackView.clipsToBounds = true
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = .zero {
        didSet {
            self.layer.cornerRadius = cornerRadius
            leftView.roundCorners2(with: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cornerRadius)
            self.layer.masksToBounds = true
        }
    }
    
    var currentString = "" {
        didSet {
            if textField.text?.count ?? 0 > 4 {
                fontsForAmount()
            }
        }
        
    }
    
    var isSecure = false {
        didSet {
            textField.isSecureTextEntry = isSecure
        }
    }
    
    private var clickedTextField  = UITextField()
    private var placeHolder =  ""
    private var tempPlaceHolder = ""
    var textInputType:IyzicoTextInputType = .text
    var showBorder: Bool = true
    var isTextFieldEmpty: Bool = true
    var isKeyboardButtonOn: Bool = false
    var isErrorUIEnable: Bool = false
    let rootVC = UIApplication.getPresentedViewController()
    var isInputValid = false
    //MARK: - Callbacks
    var textFieldDidEndEditing : ((_ text : String) -> ())?
    var textFieldDidBeginEditing : ((_ text : String) -> ())?
    var shouldChangeCharactersIn : ((_ text : String) -> ())?
    var textFieldDidChange: ((_ text: String?) -> Void)?
    var rightButtonTapped : (() -> ())?
    var deleteBackward : (() -> ())?
    var didPastedTextAction: (() -> Void)?
    var pasteTextEnabled = true
    var cvvCount: Int = 3
    
    init(textInputType: IyzicoTextInputType,
                title: String? = nil,
                leftImage: String? = nil,
                rightImage: String? = nil,
                placeholder: String? = nil,
                cornerRadius: CGFloat = Constant.shared.textInputCornerRadius) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        loadViewFromNib()
        self.textInputType = textInputType
        titleLabel.text = title
        self.placeHolder = placeholder ?? ""
        if leftImage != nil {
            leftImageView.setImage(named: leftImage!, typeof: self)
        }
        if rightImage != nil {
            rightImageView.setImage(named: rightImage!, typeof: self)
        }
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        switch textInputType {
            case .text:
                textViewSetup()
            case .phone:
                phoneViewSetup(title: "")
            case .date:
                dateViewSetup()
            case .number:
                numberViewSetup()
            case .amount:
                amountViewSetup()
            default: break
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
        let nib = UINib(nibName: NibName.shared.IyzicoTextInput, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        self.addBorder(borderColor: UIColor.gray400.cgColor)
       
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        leftView.backgroundColor = .gray200
        if textInputType == .date {
            leftImageView.image = Asset.calendar.image
        } else {
            leftImageView.image = Asset.target.image
        }
        rightImageView.image = Asset.eye.image
        errorImageView.image = Asset.error.image
        titleLabel.font = .markProMedium16
        textField.delegate = self
        textField.myCustomTextFieldDelegate = self
        rightViewForCVV.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(addIyzicoButtonAboveKeyboard),
                                               name: .keyboardButton, object: nil)
        initializeEvents()
    }
  
}

//MARK:- ACTION
extension IyzicoTextInput {
    @IBAction func didTappedRightButton(_ sender: Any) {
        rightButtonTapped?()
    }
    
    @objc
    private func textFieldDidChanged() {
        textFieldDidChange?(textField.text)
    }
    
    private func initializeEvents() {
        textField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
    }
}

//MARK:- Setup Methods
extension IyzicoTextInput {
    
    func textViewSetup(textInputType: IyzicoTextInputType? = nil, title: String = "") {
        textField.keyboardType = .emailAddress
        leftView.isHidden = true
        rightView.isHidden = true
        stackViewLeftConst.constant = Constant.shared.textInputstackViewLeftConst
        textField.placeholder = StringConstant.shared.emailPlaceHolder
        customizeTextField(title: title)
    }
    
    func emailViewSetup(textInputType: IyzicoTextInputType? = nil, title: String = "") {
        textField.keyboardType = .emailAddress
        leftView.isHidden = true
        rightView.isHidden = true
        stackViewLeftConst.constant = Constant.shared.textInputstackViewLeftConst
        textField.placeholder = StringConstant.shared.emailPlaceHolder
        customizeTextField(title: title)
    }
    
    func phoneViewSetup(textInputType: IyzicoTextInputType? = nil, title: String = "") {
        textField.keyboardType = .phonePad
        leftView.isHidden = false
        rightView.isHidden = true
        flagImage = Asset.tr.name
        textField.placeholder = StringConstant.shared.defaultPhoneCode
        self.textInputType = textInputType ?? .phone
        customizeTextField(title: title)
    }
    
    func numberViewSetup(textInputType: IyzicoTextInputType? = nil, rightViewisHidden: Bool = true) {
        textField.keyboardType = .numberPad
        leftView.isHidden = true
        rightView.isHidden = rightViewisHidden
        titleLabel.isHidden = true
        
        self.textInputType = textInputType ?? .number
        cornerRadius = Constant.shared.textInputCornerRadius
        borderColor = .silver
      
        textField.font = .markProMedium20
        textField.textColor = .darkGrey
        textField.textAlignment = .center
        textField.textContentType = .oneTimeCode
    }
    
    func amountViewSetup(textInputType: IyzicoTextInputType? = nil) {
        textField.keyboardType = .decimalPad
        leftView.isHidden = true
        rightView.isHidden = true
        titleLabel.isHidden = true
        showBorder = false
        self.textInputType = textInputType ?? .amount
        cornerRadius = Constant.shared.textInputCornerRadius
        borderColor = .silver
        
        textField.font = .markProBold32
        textField.textColor = .darkGrey
        textField.textAlignment = .center
        textField.borderStyle = .none
        self.layer.borderColor = UIColor.clear.cgColor
        textField.placeholder = StringConstant.shared.iyzicoTransferVCDefaultAmount
    }
    
    func amountPriceViewSetup(textInputType: IyzicoTextInputType? = nil) {
        textField.keyboardType = .decimalPad
        leftView.isHidden = true
        rightView.isHidden = true
        titleLabel.isHidden = true
        showBorder = false
        self.textInputType = textInputType ?? .amountPrice
        cornerRadius = Constant.shared.textInputCornerRadius
        borderColor = .silver
        textField.textColor = .darkGrey
        textField.textAlignment = .center
        textField.borderStyle = .none
        self.layer.borderColor = UIColor.clear.cgColor
        fontsForAmountPlaceHolder()
    }
    
    func eftViewSetup(textInputType: IyzicoTextInputType? = nil,
                             title: String,
                             keyboardType: UIKeyboardType,
                             placeholder: String,
                             showBorder: Bool = false) {
        textField.keyboardType = keyboardType
        leftView.isHidden = true
        rightView.isHidden = true
        titleLabel.text = title
        titleLabel.font = .markPro14
        textFieldStackView.spacing = 8
        self.textInputType = textInputType ?? .iban
        rightButton.setImage(Asset.paste.image, for: .normal)
        
        textField.font = .markProMedium14
        textField.textColor = .darkGrey
        textField.borderStyle = .none
        self.layer.borderColor = UIColor.clear.cgColor
        textField.placeholder = placeholder
        cornerRadius = Constant.shared.textInputCornerRadius
        self.showBorder = showBorder
    }
    
    func commonViewSetup(textInputType: IyzicoTextInputType? = nil,
                                title: String,
                                keyboardType: UIKeyboardType,
                                placeholder: String,
                                showBorder: Bool = false,
                                isLeftViewHidden: Bool = true,
                                isRightViewHidden: Bool = true,
                                rightImage: String? = nil,
                                leftImage: String? = nil,
                                stackViewSpace: CGFloat = 24) {
        textField.keyboardType = keyboardType
        leftView.isHidden = isLeftViewHidden
        rightView.isHidden = isRightViewHidden
        stackViewLeftConst.constant = Constant.shared.textInputstackViewLeftConst
    
        self.textInputType = textInputType ?? .text
        if rightImage != nil {
            rightImageView.isHidden = false
            contentStackView.spacing = stackViewSpace
            rightImageView.setImage(named: rightImage!, typeof: self)
        }
        if leftImage != nil {
            leftImageView.setImage(named: leftImage!, typeof: self)
        }
        
        textField.placeholder = placeholder
        cornerRadius = Constant.shared.textInputCornerRadius
        self.showBorder = showBorder
        customizeTextField(title: title)
    }
    
    fileprivate func customizeTextField(title: String) {
        cornerRadius = Constant.shared.textInputCornerRadius
        borderColor = .silverTwo
        self.title = title
        titleLabel.font = .markPro12
        titleLabel.textColor = .gunmetal
        textField.textColor = .darkGrey
        textField.font = .markProMedium16
    }
    
    func dateViewSetup() {
        placeHolder = StringConstant.shared.textInputDatePlaceholder
        textField.keyboardType = .numberPad
        leftView.isHidden = false
        rightView.isHidden = true
    }
}

//MARK: - TextField Delegate Methods
extension IyzicoTextInput: UITextFieldDelegate, CustomTextFieldDelegate {    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidBeginEditing?(textField.text ?? "")
        clickedTextField = textField
        if  showBorder {
            self.layer.borderColor = UIColor.niceBlue.cgColor
            self.addExternalBorder()
        }
        if textInputType == .amount {
            textField.text = StringConstant.shared.iyzicoTransferVCDefaultTL
        } else if textInputType == .iban {
            textField.text = "TR"
        }
        if isErrorUIEnable {
            removeErrorUI()
        }
        configureTextInputLayout(shouldTitleStackViewVisible: true, placeholder: tempPlaceHolder)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if showBorder {
            self.removeExternalBorders()
            self.layer.borderColor = UIColor.gray400.cgColor
        }
        
        textFieldDidEndEditing?(textField.text!)
     
        switch textInputType {
            case .amountPrice:
                self.fontsForAmountPlaceHolder()
            default:
                break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isTextFieldEmpty = false
        
        let text = textField.text ?? ""
        let textRange = Range(range, in: text)!
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        //Instantly checking emoji.
        if checkForEmojis(updatedText: updatedText) {
            return false
        }
        else {
            //Checking other updated texts.
            switch textInputType {
            case .date:
                shouldChangeCharactersIn?(updatedText)
                return dateMask(textField: textField, range: range, string: string)
            case .phone:
                shouldChangeCharactersIn?(updatedText)
                return textField.lockPhoneCode(textField: textField, string: string, updatedText: updatedText)
            case .number:
                shouldChangeCharactersIn?(updatedText.firstLetter)
                return textField.textCount(lessThan: 1, string: string)
            case .amount:
                shouldChangeCharactersIn?(updatedText)
                return textField.lockTL(string: string, updatedText: updatedText,textField: textField)
            case .iban:
                shouldChangeCharactersIn?(updatedText)
                return textField.ibanMask(textField: textField, string: string, updatedText: updatedText)
            case .shortDate:
                shouldChangeCharactersIn?(updatedText)
//                return dateMaskShort(textField: textField, range: range, string: string)
//                return true
                return sktDateMask(text: updatedText, replacementString: string)
            case .securityCode:
                shouldChangeCharactersIn?(updatedText)
                return textField.textCount(lessThan: cvvCount, string: string)
            case .cardNumber:
                shouldChangeCharactersIn?(updatedText)
               // return textField.cardNumberMask(textField: textField, string: string, updatedText: updatedText)
                let text = "\(updatedText.prefix(2))"
                if ValidationManager.guest(text: text, cardBrand: .AMEX) {
                    textField.generalFormat(with: "XXXX XXXXXX XXXXX", text: updatedText)
                    return false
                } else {
                    textField.generalFormat(with: "XXXX XXXX XXXX XXXX", text: updatedText)
                    return false
                }
                
            case .amountPrice:
                shouldChangeCharactersIn?(updatedText)
                return amountPriceMask(string: string)
            case .text:
                textField.convertLowercasedWithDelay(delay: Constant.shared.textInputLowercasedDelay)
                shouldChangeCharactersIn?(updatedText)
                return ValidationManager.checkForValidCharacters(text: updatedText, regexType: .email)
            case .cardOwnerName:
                shouldChangeCharactersIn?(updatedText)
                return !ValidationManager.validate(text: updatedText.last?.description, regexType: .cardOwnerName)
            }
        }
    }
    
    func customDeleteBackward() {
        if isTextFieldEmpty {
            deleteBackward?()
        }
        isTextFieldEmpty = true
    }
    
    func didPastedText() {
        didPastedTextAction?()
    }
}

//MARK:- Helper Methods
extension IyzicoTextInput {
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "TR## #### #### ####"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
   func makeDisable() {
        titleLabel.textColor = .gray500
        rightImageView.tintColor = .gray500
        contentView.backgroundColor = .paleGray3
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        textField.isUserInteractionEnabled = false
    }
    
    func makeDisableforEmail() {
        contentView.backgroundColor = .paleGreyTwo
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        textField.isUserInteractionEnabled = false
    }
    
    func showError(text:String) {
        isErrorUIEnable = true
        titleLabel.textColor = .red900
        leftImageView.tintColor = .red900
        self.backgroundColor = .red400
        titleLabel.text = text
        titleLabel.font = .markProMedium12
        self.layer.borderColor = UIColor.red900.cgColor
        leftView.backgroundColor = .red500
        errorImageView.isHidden = false
        titleContainerStackView.isHidden = false
    }
    
    func removeErrorUI() {
        self.backgroundColor = .white
        errorImageView.isHidden = true
        leftView.backgroundColor = .gray200
        titleLabel.text = self.title
        titleLabel.textColor = .gunmetal
    }
  
    fileprivate func dateMask(textField: UITextField, range: NSRange, string: String) -> Bool {
        let min = self.textField.text?.count == Constant.shared.textInputDateMaskMinCount
        let max = self.textField.text?.count == Constant.shared.textInputDateMaskMaxCount
        if min || max {
            if !(string == "") {
                self.textField.text = self.textField.text! + StringConstant.shared.textInputDateSeperator
            }
        }
        return !(textField.text!.count == Constant.shared.textInputDateMaskRangeCount && (string.count ) > range.length)
    }
    
    
//    fileprivate func dateMaskShort(textField: UITextField, range: NSRange, string: String) -> Bool {
//        if self.textField.text?.count == Constant.shared.textInputDateMaskMinCount {
//            if !(string == "") {
//                self.textField.text = self.textField.text! + StringConstant.shared.textInputDateSeperator
//            }
//        }
//        return !(textField.text!.count == Constant.shared.textInputDateMaskMaxCount && (string.count ) > range.length)
//    }
    
    private func cardOwnerNameMask(text: String) -> Bool {
        let nameRules: [String] = Array(0..<10).map{ $0.description }
        if nameRules.contains(text) {
            return false
        }
        return true
    }
    
    private func sktDateMask(text: String, replacementString: String) -> Bool {
        let cursorPosition = textField.getCursorPosition()
        if cursorPosition == 2 && !replacementString.isBackspace {
            if (Constant.shared.textInputDateMaskMaxCount == text.count && cursorPosition == 2) == false {
                self.textField.text = (self.textField.text ?? "") +  "/"
            }
        }
        
        return Constant.shared.textInputDateMaskMaxCount != text.count
    }
    
    func amountPriceMask(string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(string: currentString)
        default:
            if string.count == 0 && currentString.count != 0 {
                currentString = String(currentString.dropLast())
                formatCurrency(string: currentString)
            }
        }
        return false
    }
    
    func formatCurrency(string: String) {
        print("format \(string)")
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "en_TR") as Locale
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        self.textField.text = formatter.string(from: NSNumber(value: numberFromField))
        if textField.text?.count ?? 0 > 4 {
            fontsForAmount()
        }
    }
    
    func fontsForAmount() {
        let attrStri = NSMutableAttributedString.init(string: self.textField.text ?? "")
        
        let rangeRight = NSRange(location: 0, length: (self.textField.text?.count ?? 3) - 3)
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont.markProBold32],
                               range: rangeRight)
        
        let rangeLeft = NSRange(location: (self.textField.text?.count ?? 3) - 3, length: 3)
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont.markProBold28],
                               range: rangeLeft)
      
        self.textField.attributedText = attrStri
    }
    
    func fontsForAmountPlaceHolder() {
        textField.font = .markProBold32
        textField.placeholder = StringConstant.shared.iyzicoTransferVCDefaultAmount
        let attrStri = NSMutableAttributedString.init(string: self.textField.placeholder ?? "")
        
        let rangeRight = NSRange(location: 0, length: (self.textField.placeholder?.count ?? 3) - 3)
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont.markProBold32],
                               range: rangeRight)
        
        let rangeLeft = NSRange(location: (self.textField.placeholder?.count ?? 3) - 3, length: 3)
        attrStri.addAttributes([NSAttributedString.Key.font: UIFont.markProBold28],
                               range: rangeLeft)
        
        self.textField.attributedPlaceholder = attrStri
    }
    
    func configureTextInputLayout(shouldTitleStackViewVisible: Bool, placeholder: String) {
        tempPlaceHolder = placeholder
        if shouldTitleStackViewVisible {
            titleContainerStackView.isHidden = false
            textField.placeholder = placeholder
        }
        else {
            titleContainerStackView.isHidden = true
            textField.placeholder = titleLabel.text
        }
    }
    
    private func checkForEmojis(updatedText: String) -> Bool {
        return updatedText.containsEmoji
    }
    
    func showErrorByType(requiredMessage: String, notValidMessage: String) {
        if !isInputValid {
            if textField.text == "" {
                showError(text: requiredMessage)
            }
            else {
                showError(text: notValidMessage)
            }
        }
    }
}

//MARK:- Keyboard Above Button
extension IyzicoTextInput {
    @objc func addIyzicoButtonAboveKeyboard(notification: NSNotification) {
        let info = notification.userInfo
        let buttonType = info?["buttonType"] as! IyzicoButtonType
        let title = info?["title"] as? String
        let image = info?["image"] as? String
        let cornerRadius = info?["cornerRadius"] as? CGFloat ?? .zero
        self.isKeyboardButtonOn = true
        
        let button = IyzicoButton(buttonType: buttonType, title: title, image: image, cornerRadius: cornerRadius)
        button.didTappedButton = {
            NotificationCenter.default.post(name: .didTappedButtonAboveKeyboard, object: nil)
        }

        button.frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 48)
        self.textField.inputAccessoryView = button
    }
}

