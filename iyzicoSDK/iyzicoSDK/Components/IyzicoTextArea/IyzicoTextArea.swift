//
//  IyzicoTextArea.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 9.12.2020.
//

import Foundation
import UIKit

class IyzicoTextArea: BaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBInspectable var cornerRadius: CGFloat = .zero {
        didSet {
            self.contentView.layer.cornerRadius = cornerRadius
            
        }
    }
    @IBInspectable public var titleText: String? = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    @IBInspectable public var text: String? {
        didSet {
            self.textView.text = text
        }
    }
    @IBInspectable public var placeholder: String? = StringConstant.shared.textAreaPlaceholder {
        didSet {
            setUpPlaceHolder()
        }
    }
    @IBInspectable public var maxCount: Int = Constant.shared.textAreaMaxCount {
        didSet {
            // self.textView.text = text
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
        let nib = UINib(nibName: NibName.shared.IyzicoTextArea, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
        setUpTitleLabel()
        setUpTextView()
        setUpCountLabel()
        setUpPlaceHolder()
    }
}

//MARK: - Helper Funcs
extension IyzicoTextArea {
    
    func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = Constant.shared.textAreaCornerRadius
        contentView.layer.masksToBounds = true
        contentView.addBorder()
    }
    
    func setUpTitleLabel() {
        titleLabel.font = .markPro12
        titleLabel.text = titleText
    }
    
    func setUpTextView() {
        textView.font = .markProMedium16
        textView.delegate = self
    }
    
    func setUpCountLabel() {
        countLabel.font = .markPro10
        countLabel.textColor = .gray400
        countLabel.text = "0\(maxCount)"
    }
    
    func setUpPlaceHolder() {
        textView.text = placeholder
        textView.textColor = .gray400
    }
    
    func setCountToCountLabel(count:Int) -> Bool {
        let currentCount = count
        countLabel.text = "\(currentCount)/\(maxCount)"
        if currentCount > maxCount {
            countLabel.addAttribute(attText: "\(currentCount)")
        }
        return true
    }
}

//MARK: - IyzicoTextArea Delegate
extension IyzicoTextArea: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray400 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setUpPlaceHolder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return setCountToCountLabel(count: numberOfChars)
    }
}
