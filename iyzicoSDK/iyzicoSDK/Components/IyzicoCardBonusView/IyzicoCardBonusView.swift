//
//  IyzicoCardBonusView.swift
//  iyzicoSDK
//
//  Created by Huseyin Akcay on 23.03.2022.
//

import UIKit

protocol IyzicoCardBonusViewDelegate: AnyObject {
    func setBonusUsage(enabled: Bool)
}

class IyzicoCardBonusView: BaseView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var useBonusCheckbox: IyzicoCheckBox! {
        didSet {
            useBonusCheckbox.delegate = self
            useBonusCheckbox.borderColor = UIColor.silverTwo.cgColor
            useBonusCheckbox.borderWidth = CGFloat(Constant.shared.borderWidthBig)
            useBonusCheckbox.cornerRadius = Constant.shared.defaultCheckBoxCornerRadius
            useBonusCheckbox.checkBoxType = .check
        }
    }
    @IBOutlet weak var totalBonusLabel: UILabel! {
        didSet {
            totalBonusLabel.text = "Toplam Puan: "
        }
    }
    @IBOutlet weak var totalBonusAmount: UILabel!
    @IBOutlet weak var usableBonusAmount: UILabel!
    @IBOutlet weak var usableBonusLabel: UILabel! {
        didSet {
            usableBonusLabel.text = "Kart Puanımı Kullan"
        }
    }
    @IBOutlet weak var totalStackView: UIStackView!
    
//    var useBalanceEnabled: Bool = true {
//        didSet {
//            setupForBalance(doesBonusCover: self.doesBonusCover)
//        }
//    }
    
    @IBInspectable public var totalAmount: Double = 0.0 {
        didSet {
            totalBonusAmount.text = totalAmount.asString.addTL
        }
    }
    @IBInspectable public var usableAmount: Double = 0.0 {
        didSet {
            usableBonusAmount.text = usableAmount.asString.addTL
        }
    }
    
    weak var delegate: IyzicoCardBonusViewDelegate?
    
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
        let nib = UINib(nibName: NibName.shared.IyzicoCardBonusView, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpView()
    }
    
    @IBAction func tappedCheckbox(_ sender: Any) {
        useBonusCheckbox.isSelected.toggle()
    }
    
    fileprivate func setUpView() {
        setUpContentView()
        
        totalBonusLabel.font = .markPro12
        totalBonusLabel.textColor = .coolGrey
        totalBonusAmount.font = .markProMedium12
        totalBonusAmount.textColor = .coolGrey
        
        usableBonusAmount.font = .markProMedium16
        usableBonusAmount.textColor = .darkGrey
        usableBonusLabel.font = .markPro16
        usableBonusAmount.textColor = .darkGrey
    }
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //  contentView.layer.cornerRadius = cornerRadius
        //  contentView.layer.masksToBounds = true
        //contentView.addBorder(borderColor: borderColor)
    }
    
//    fileprivate func setupForBalance(doesBonusCover: Bool) {
//        totalStackView.isHidden = doesBonusCover
//    }
    
}

extension IyzicoCardBonusView: IyzicoCheckBoxDelegate {
    func didTappedCheckBox(_ selected: Bool) {
        self.delegate?.setBonusUsage(enabled: selected)
    }
    
    
}
