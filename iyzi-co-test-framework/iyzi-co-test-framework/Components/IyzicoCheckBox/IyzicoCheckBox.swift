//
//  IyzicoCheckBox.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 10.12.2020.
//

import Foundation
import UIKit

enum CheckBoxType: Int {
    
    case radio = 0
    case check
}

protocol IyzicoCheckBoxDelegate: class {
    func didTappedCheckBox(_ selected: Bool)
}

class IyzicoCheckBox: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBInspectable var cornerRadius: CGFloat = .zero {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
            contentView.layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.contentView.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: CGColor = UIColor.red900.cgColor {
        didSet {
            self.contentView.layer.borderColor = borderColor
        }
    }
    @IBInspectable var checkImage: UIImage = Asset.icnCheck.image {
        didSet {
            checkBoxButton.setImage(checkImage, for: .selected)
        }
    }
    @IBInspectable var unCheckImage: UIImage = UIImage()  {
        didSet {
            checkBoxButton.setImage(unCheckImage, for: .normal)
        }
    }
    
    var checkBoxType: CheckBoxType = .check
    var isSelected: Bool = false
    weak var delegate: IyzicoCheckBoxDelegate?
    
    // MARK: - Init
    init(checkBoxType: CheckBoxType, checkImage: UIImage? = nil, unCheckImage: UIImage? = nil, borderWidth: CGFloat? = 1, borderColor: UIColor? = nil, cornerRadius: CGFloat? = .zero) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        self.checkImage = checkImage ?? Asset.icnCheck.image
        self.cornerRadius = cornerRadius ?? .zero
        self.checkBoxType = checkBoxType
        loadViewFromNib()
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
        let nib = UINib(nibName: NibName.shared.IyzicoCheckBox, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
        setUpCheckBoxButton()
    }
}

    // MARK: - Button Actions
extension IyzicoCheckBox {
    
    @IBAction func didTappedCheckButton(_ sender: Any) {
        setSelected()
        delegate?.didTappedCheckBox(isSelected)
    }
}

    // MARK: - Helper Funcs
extension IyzicoCheckBox {
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        contentView.addBorder(borderColor: borderColor)
    }
    
    fileprivate func setUpCheckBoxButton() {
        frontImageView.isHidden = true
        frontImageView.image = Asset.icnCheck.image
//        checkBoxButton.setImage(UIImage(), for: .normal)
//        checkBoxButton.setImage(checkImage, for: .selected)
       
        if cornerRadius == .zero {
            if checkBoxType == .check {
                self.contentView.layer.cornerRadius = Constant.shared.defaultCheckBoxCornerRadius
                self.layer.cornerRadius = Constant.shared.defaultCheckBoxCornerRadius
            } else {
                self.contentView.layer.cornerRadius = Constant.shared.defaultRadioCornerRadius
                self.layer.cornerRadius = Constant.shared.defaultRadioCornerRadius
            }
        } else {
            self.contentView.layer.cornerRadius = self.cornerRadius
            self.layer.cornerRadius =  self.cornerRadius
        }
    }
    
    func setSelected(tintColor: UIColor = .green800) {
        if  checkBoxButton.isSelected == true {
            deSelect()
        }
        else {
            select(tintColor: tintColor)
        }
    }
    
    func select(tintColor: UIColor = .green800) {
        frontImageView.isHidden = false
        checkBoxButton.isSelected = true
        self.isSelected = true
        checkBoxButton.backgroundColor = tintColor
        contentView.layer.borderColor = tintColor.cgColor
    }
    
    func deSelect() {
        frontImageView.isHidden = true
        checkBoxButton.isSelected = false
        self.isSelected = false
        checkBoxButton.backgroundColor = .clear
        contentView.layer.borderColor = borderColor
    }
}
