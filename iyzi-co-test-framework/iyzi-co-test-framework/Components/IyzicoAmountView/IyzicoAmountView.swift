//
//  IyzicoAmountView.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 2.03.2021.
//

import UIKit

protocol IyzicoAmountViewDelegate: class {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func shouldChangeCharactersIn(_ textField: UITextField)
    func textFieldDidChange(_ textField: UITextField)
}

class IyzicoAmountView: BaseView, UITextFieldDelegate, CustomTextFieldDelegate {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var naturalNumberTextField: CustomTextField!
    
    private typealias numberConstants = Constant.IyzicoAmountView
    private typealias stringConstants = StringConstant.IyzicoAmountView
    
    weak var delegate: IyzicoAmountViewDelegate?
    var cursorPositionType: CursorPositionTypes = .begin

    override func commonInit() {
        super.commonInit()
        loadNib()
        setupUI()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoAmountView, bundle: bundle)
        self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    //MARK: - Events
    @objc
    private func textFieldDidChange() {
//        delegate?.textFieldDidChange(self.naturalNumberTextField)
        if getCommaLocation() >= getCursorPosition()  {
            if naturalNumberTextField.text != "₺,00" || naturalNumberTextField.text != "₺"{
                changePriceFormatBeforeComma()
                setupPlaceholderColor(isByRange: true)
            }
        }
        refillDecimalPlaceWithZeros(textField: self.naturalNumberTextField)
        delegate?.textFieldDidChange(self.naturalNumberTextField)
    }
    
    func shouldPasteText() -> Bool {
        return false
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupNaturalNumberTextField()
        initializeObservers()
    }
    
    private func setupNaturalNumberTextField() {
        naturalNumberTextField.myCustomTextFieldDelegate = self
        naturalNumberTextField.textColor = .darkGrey
        naturalNumberTextField.font = .markProBold32
        naturalNumberTextField.textAlignment = .center
        naturalNumberTextField.keyboardType = .decimalPad
        naturalNumberTextField.text = stringConstants.fullTextFieldPlaceHolder
        naturalNumberTextField.delegate = self
        naturalNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        setupPlaceholderColor(isByRange: false)
    }
    
    private func setupNaturalNumberTextFieldFonts(beforeCommaText: String, afterCommaText: String) {
        naturalNumberTextField.setDoubleAttributedString(firstText: beforeCommaText,
                                                         secondText: afterCommaText,
                                                         firstFont: .markProBold32,
                                                         secondFont: .markPro28,
                                                         firstForegroundColor: .darkGrey,
                                                         secoindForegroundColor: .dark)
    }
    
    func setupPlaceholderColor(isByRange: Bool) {
        if isByRange {
            let beforeCommaRange = 1..<getCommaLocation()
            let beforeCommaText = naturalNumberTextField.text?[beforeCommaRange].addDotsToPrice ?? ""
            let afterCommaRange = getCommaLocation()..<(naturalNumberTextField.text?.count ?? 0)
            let afterCommaText = naturalNumberTextField.text?[afterCommaRange] ?? ""
            let attributesModelArray = [AttributedStringModel(text: stringConstants.currencySymbolPlaceHolder,
                                                              font: .markProBold32,
                                                              color: .darkGrey),
                                        AttributedStringModel(text: beforeCommaText,
                                                              font: .markProBold32,
                                                              color: .darkGrey),
                                        AttributedStringModel(text: afterCommaText,
                                                              font: .markPro28,
                                                              color: .dark)]
            naturalNumberTextField.setMultipleAttributedString(attributedStringModels: attributesModelArray)
            setCursorPosition(position: getCommaLocation())
        }
        else {
            let attributesModelArray = [AttributedStringModel(text: stringConstants.currencySymbolPlaceHolder,
                                                              font: .markProBold32,
                                                              color: .darkGrey),
                                        AttributedStringModel(text: stringConstants.naturalNumberFieldPlaceHolder,
                                                              font: .markProBold32,
                                                              color: .blueGrey),
                                        AttributedStringModel(text: stringConstants.decimalNumberTextFieldPlaceholder,
                                                              font: .markPro28,
                                                              color: .blueGrey)]
            naturalNumberTextField.setMultipleAttributedString(attributedStringModels: attributesModelArray)
            
        }
    }
    
    //MARK: - Helper Methods
    private func isFullAmountValid() -> Bool {
        return true
    }

    private func checkUserRemovingInstantCharacters(textField: UITextField,replacementString: String, text: String) -> Bool {
        if replacementString.isBackspace {
            var selectedCharacter = String()
            if getCursorPosition() > 0 {
                selectedCharacter = text[getCursorPosition() - 1]
            }
            else {
                selectedCharacter = text[0]
            }
            if selectedCharacter == "," {
                if naturalNumberTextField.text?.indexInt(of: "₺") != getCommaLocation() - 1 {
                    naturalNumberTextField.text?.removeAtIndex(index: getCursorPosition() - 2)
                    setCursorPosition(position: getCommaLocation())
                    setupPlaceholderColor(isByRange: true)
                }
                return false
            }
            
            if selectedCharacter == "₺" {
                if checkSelectedText(textField: textField) {
                    return true
                }
                return false
            }
            if !checkSelectedText(textField: textField)  {
                return false
            }
            return true
        }
        return true
    }
    
    func getCommaLocation() -> Int {
        return naturalNumberTextField.text?.indexInt(of: ",") ?? 0
    }
    
    private func getCursorPosition() -> Int {
        if let selectedRange = naturalNumberTextField.selectedTextRange {
            let cursorPosition = naturalNumberTextField.offset(from: naturalNumberTextField.beginningOfDocument, to: selectedRange.start)
            return cursorPosition
        }
        return 0
    }
    
    func setCursorPosition(position: Int) {
        if let newPosition = naturalNumberTextField.position(from: naturalNumberTextField.beginningOfDocument, offset: position) {
            naturalNumberTextField.selectedTextRange = naturalNumberTextField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    private func checkDecimalPlacesLimit(replacementString: String) -> Bool {
        guard let count = naturalNumberTextField.text?.count else { return true }
        let array = Array(getCommaLocation()..<(count - 1))
        if replacementString.isBackspace {
            return true
        }
        else {
            let limitCondition = array.count >= 2
            let cursorPositionsArray = [getCursorPosition() - 3, getCursorPosition() - 2, getCursorPosition() - 1]
            let cursorCondition = array.intersects(with: cursorPositionsArray)
            if limitCondition && cursorCondition {
                return false
            }
        }
        return true
    }
    
    private func checkMaxCharacterLimitForBeforeComma(replacementString: String) -> Bool {
        if replacementString.isBackspace {
            return true
        }
        let range = 1..<getCommaLocation()
        guard let validatedText = naturalNumberTextField.text?[range] else { return false }
        if getCursorPosition() > getCommaLocation() {
            return true
        }
        if validatedText.count < numberConstants.naturalNumberLimit {

            return true
        }
        return false
    }
    
    private func checkRemoveAllText(replacementString: String) -> Bool {
        if replacementString.isBackspace {
            if let textRange = naturalNumberTextField.selectedTextRange {
                let selectedText = naturalNumberTextField.text(in: textRange)
                if selectedText == naturalNumberTextField.text {
                    return false
                }
                return true
            }
        }
        return true
    }
    
    private func checkWritingBeforeTlSymbol() -> Bool {
        if getCursorPosition() == 0 {
            return false
        }
        return true
    }
    
    func changePriceFormatBeforeComma(isDeliveryBalance: Bool = false) {
        let beforeCommaRange = 1..<getCommaLocation()
        var beforeCommaText = naturalNumberTextField.text?[beforeCommaRange].addDotsToPrice ?? ""
        if isDeliveryBalance == false {
            if getCursorPosition() == 1 && beforeCommaText.count == 2 {
                beforeCommaText = beforeCommaText.dropFirst().description
            }
            else if getCursorPosition() == 2 && beforeCommaText.count == 2 {
                beforeCommaText = beforeCommaText.dropLast().description
            }
        }
        let afterCommaRange = getCommaLocation()..<(naturalNumberTextField.text?.count ?? 0)
        let afterCommaText = naturalNumberTextField.text?[afterCommaRange] ?? ""
        naturalNumberTextField.text = "₺" + beforeCommaText + afterCommaText
        setupPlaceholderColor(isByRange: true)
    }
    
    func getAfterCommaText() -> String {
        let afterCommaRange = getCommaLocation()..<(naturalNumberTextField.text?.count ?? 0)
        return naturalNumberTextField.text?[afterCommaRange] ?? ""
    }
    
    private func initializeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addIyzicoButtonAboveKeyboard),
                                               name: .keyboardButton, object: nil)
    }
    
    func refillDecimalPlaceWithZeros(textField: UITextField) {
        if getCursorPosition() >= getCommaLocation() {
            if textField.text?.last == "," {
                if let validatedText = textField.text {
                    textField.text = validatedText + "00"
                    setupPlaceholderColor(isByRange: true)
                    setCursorPosition(position: getCommaLocation() + 1)
                }
            }
        }
    }
    
    func changeAfterCommaText(textField: UITextField, replacementString: String) {
        if getCursorPosition() > getCommaLocation() {
            let afterCommaRange = (getCommaLocation() + 1)..<(naturalNumberTextField.text?.count ?? 0)
            let afterCommaText = naturalNumberTextField.text?[afterCommaRange] ?? ""
            
            if !replacementString.isBackspace {
                if afterCommaText == "00" && replacementString != "." && replacementString != "," {
                    textField.text = textField.text?.dropLast(2).description
                }
                setupPlaceholderColor(isByRange: true)
                setCursorPosition(position: (textField.text?.count ?? 0))
            }
        }
    }
    
    //In turkish language .decimalPad keyboard type will be with "," character
    //In english language .decimalPad keyboard type will be with "." character
    //This character variations can be changed on what user language is. Don't forget to change supported characters if app has more than that languages.
    private func checkForUserTryingToTapDecimalCharacters(textField: UITextField, replacementString: String) -> Bool {
        if replacementString == "," || replacementString == "." {
            let endIndex = naturalNumberTextField.text?.count
//            setCursorPosition(position: endIndex ?? getCommaLocation() + 1)
            setCursorPosition(position: getCommaLocation() + 1)
            return false
        }
        return true
    }
    
    func findDifference(str1: String, str2: String) -> String {
        return "\(str1.dropLast(str2.count) )".replacingOccurrences(of: ".", with: "")
    }
    
    private func checkSelectedText(textField: UITextField) -> Bool {
        
        if let textRange = textField.selectedTextRange {

            let selectedText = textField.text(in: textRange)
            if selectedText == "" {
                return true
            }
            if textField.text?.count == selectedText?.count ||
                ((textField.text?.count ?? .zero) - (selectedText?.count ?? .zero)) == 1 &&
                ((selectedText?.contains("₺")) != nil) {
                textField.text = stringConstants.fullTextFieldPlaceHolder
                setupPlaceholderColor(isByRange: false)
                setCursorPosition(position: 1)
                return false
            } else if ((selectedText?.contains(",")) != nil) {
                let string = findDifference(str1: textField.text ?? "", str2: selectedText ?? "")
                textField.text =  string + stringConstants.decimalNumberTextFieldPlaceholder
                setupPlaceholderColor(isByRange: true)
                changePriceFormatBeforeComma()
               // changePriceFormatBeforeCommaisEnable = false
                return false
            } else if selectedText?.count ?? .zero > .zero {
                return true
            }
            return true
        }
        return true
    }
    
    //MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.shouldChangeCharactersIn(textField)
        
        changeAfterCommaText(textField: textField, replacementString: string)
        if checkForUserTryingToTapDecimalCharacters(textField: textField, replacementString: string) == false {
            return false
        }
        
        if checkUserRemovingInstantCharacters(textField: textField, replacementString: string, text: textField.text ?? "") == false {
            return false
        }
        
        if checkDecimalPlacesLimit(replacementString: string) == false {
            return false
        }
        
        if checkMaxCharacterLimitForBeforeComma(replacementString: string) == false {
            return false
        }

        if checkRemoveAllText(replacementString: string) == false {
            return false
        }
        
        if checkWritingBeforeTlSymbol() == false {
            return false
        }
        
        return true
    }
}

//MARK:- Keyboard Above Button
extension IyzicoAmountView {
    @objc func addIyzicoButtonAboveKeyboard(notification: NSNotification) {
        let info = notification.userInfo
        let buttonType = info?["buttonType"] as! IyzicoButtonType
        let title = info?["title"] as? String
        let image = info?["image"] as? String
        let cornerRadius = info?["cornerRadius"] as? CGFloat ?? .zero
//        self.isKeyboardButtonOn = true
        
        let button = IyzicoButton(buttonType: buttonType, title: title, image: image, cornerRadius: cornerRadius)
        button.didTappedButton = {
            NotificationCenter.default.post(name: .didTappedButtonAboveKeyboard, object: nil)
        }

        button.frame = CGRect(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 48)
        self.naturalNumberTextField.inputAccessoryView = button
    }
}
