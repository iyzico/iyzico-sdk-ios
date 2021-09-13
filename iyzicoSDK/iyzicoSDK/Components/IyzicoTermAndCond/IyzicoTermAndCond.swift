//
//  IyzicoTermAndCond.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 10.12.2020.
//

import Foundation
import UIKit

class IyzicoTermAndCond: UIView {
    
    @IBOutlet weak var stackViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkBox: IyzicoCheckBox!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var switchh: UISwitch!
    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var infoImageView: UIImageView!
    
    var didTappedTextView: ((String)->())?
    
    var isInfoImageViewEnable: Bool = false {
        didSet {
            infoImageView.isHidden = !isInfoImageViewEnable
        }
    }
    
    var isChecked: Bool {
       return checkBox.isSelected
    }
    var isSwitchEnable: Bool {
        return switchh.isOn
    }
    
    var highlightedTexts = [String]()
    var linkNames = [String]()
   
    @IBInspectable var title: String = ""  {
        didSet {
            termTextView.text = title
        }
    }
    @IBInspectable var highlightedText: String = ""  {
        didSet {
            //attributedText attributedText
        }
    }
    
    @IBInspectable var checkBoxisEnable: Bool = true  {
        didSet {
            checkBoxView.isHidden = !checkBoxisEnable
        }
    }
    @IBInspectable var switchisEnable: Bool = false  {
        didSet {
            switchView.isHidden = !switchisEnable
        }
    }
    
    // MARK: - Init
    init(title: String, highlightedText: String, switchisEnable: Bool = false, checkBoxisEnable: Bool = true) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        self.title = title
        self.highlightedText = highlightedText
        
        loadViewFromNib()
        
        checkBoxView.isHidden = !checkBoxisEnable
        switchView.isHidden = !switchisEnable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    // MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoTermAndCond, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
        setUpIyzicoCheckBox()
    }
   
}

// MARK: - Helper Funcs
extension IyzicoTermAndCond {
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    fileprivate func setUpIyzicoCheckBox() {
        checkBox.borderColor = UIColor.gray400.cgColor
        checkBox.checkBoxType = .check
    }
    
    func setUpTermView(title: String,
                       highlightedTexts: [String],
                       plainFont: UIFont,
                       linkNames: [String],
                       highletedFont: UIFont,
                       alignment: NSTextAlignment) {
        termTextView.delegate = self
        self.highlightedTexts = highlightedTexts
        self.linkNames = linkNames
        termTextView.addMultipleAttribute(text: title,
                                          attTexts: highlightedTexts,
                                          linksNames: linkNames,
                                          color: .clearBlue,
                                          plainFont: plainFont,
                                          highletedFont: highletedFont,
                                          alignment: alignment)
    }
}

//MARK:- Tap Funcs
extension IyzicoTermAndCond: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        linkNames.forEach { link in
            if (URL.absoluteString == link) {
                didTappedTextView?(link)
            }
        }
        return false
    }
}

