//
//  MyAccountCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 25.01.2021.
//

import UIKit

protocol MyAccountCellDelegate: class {
    func didTappedRefreshButton(cell: BaseTableViewCell)
}

class MyAccountCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = StringConstant.shared.myAccountCellTitleText
            titleLabel.font = .markPro14
            titleLabel.textColor = .darkGrey
            titleLabel.alpha = 1.0
        }
    }
    
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.layer.borderWidth = CGFloat(Constant.shared.borderWidthSmall)
            detailView.layer.borderColor = UIColor.silver.cgColor
            detailView.layer.cornerRadius = CGFloat(Constant.shared.defaultCornerRadius)
        }
    }
    
    @IBOutlet weak var accountImageView: UIImageView! {
        didSet {
            accountImageView.image = Asset.icnWallet.image
        }
    }
    @IBOutlet weak var contentStackView: UIStackView! {
        didSet {
            contentStackView.setCustomSpacing(7, after: contentStackView.subviews[1])
        }
    }
  
    @IBOutlet weak var accountLabel: UILabel! {
        didSet {
            accountLabel.text = StringConstant.shared.myAccountCellAccountText
            accountLabel.font = .markPro14
            accountLabel.textColor = .darkGrey
        }
    }
    @IBOutlet weak var balanceLabel: UILabel! {
        didSet {
//            balanceLabel.text = "₺120,00"
            balanceLabel.font = .markProMedium18
            balanceLabel.textColor = .gunmetal
        }
    }
    
    @IBOutlet weak var checkBox: IyzicoCheckBox! {
        didSet {
            checkBox.isUserInteractionEnabled = false //Interaction event will be leave to didSelectAtRow
            checkBox.borderColor = UIColor.gray400.cgColor
            checkBox.cornerRadius = Constant.shared.defaultRadioCornerRadius
            checkBox.checkBoxType = .radio
        }
    }
    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
            detailLabel.font = .markPro12
            detailLabel.textColor = .gunmetal
            detailLabel.addAttribute(text: StringConstant.shared.myAccountCellDetailText, attText: StringConstant.shared.myAccountCellDetailAttText, color: .gunmetal, highletedFont: .markProBold12)
        }
    }
    @IBOutlet weak var refreshButton: UIButton! {
        didSet {
            refreshButton.setImage(Asset.refresh2.image, for: .normal)
        }
       
    }
    @IBOutlet weak var balanceLoadedView: UIView!
    @IBOutlet weak var balanceLoadedImageView: UIImageView!
    @IBOutlet weak var balanceLoadedLabel: UILabel!
    
    weak var delegate: MyAccountCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTappedRefreshButton(_ sender: Any) {
        delegate?.didTappedRefreshButton(cell: self)
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupBalanceLoadedView()
        setupBalanceLoadedImageView()
        setupBalanceLoadedLabel()
    }
    
    private func setupBalanceLoadedView() {
        balanceLoadedView.backgroundColor = .veryLightGreen
        balanceLoadedView.clipsToBounds = true
        balanceLoadedView.layer.cornerRadius = 6
        balanceLoadedView.isHidden = true
        balanceLoadedView.alpha = 0.0
    }
    
    private func setupBalanceLoadedImageView() {
        balanceLoadedImageView.image = Asset.resultSuccessWithBackground.image
    }
    
    private func setupBalanceLoadedLabel() {
        balanceLoadedLabel.font = .markProMedium14
        balanceLoadedLabel.textColor = .mediumGreenTwo
    }
    
    //MARK: - Helper Methods
    func animateRefreshButton(completionHandler: @escaping () -> Void) {
        refreshButton.isUserInteractionEnabled = false
//        refreshButton.imageView?.addRotateAnimation()
        refreshButton.imageView?.addRotateAnimationNew(withDuration: 2) { [weak self] in
            self?.refreshButton.imageView?.removeRotateAnimation()
            completionHandler()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completionHandler()
//        }
    }
    
    func animateBalanceLabel(balanceLabelText: String, balanceDifference: String) {
//        balanceLabel.fadeAnimation(shouldAppear: false) { [weak self] in
//
//        }
        
        balanceLabel.text = balanceLabelText
        animateTitle(balanceDifference: balanceDifference)
    }
    
    func animateTitle(balanceDifference: String) {
        if ((balanceDifference.dropFirst() as NSString).integerValue) > 0 {
            let calculatedBalanceDifference = balanceDifference + " " + StringConstant.shared.myAccountCellBalanceLoadedText
            configureVisibilityWithoutAnimation(status: true,
                                                balanceDifference: calculatedBalanceDifference)
            balanceLoadedView.fadeAnimation(shouldAppear: true, delay: 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.configureVisibilityWithoutAnimation(status: false)
                    self?.refreshButton.isUserInteractionEnabled = true
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.refreshButton.isUserInteractionEnabled = true
            }
        }
        
        
    }
    
    private func configureVisibilityWithoutAnimation(status: Bool, balanceDifference: String? = nil) {
        UIView.performWithoutAnimation { [weak self] in
            guard let self = self else { return }
            self.balanceLoadedLabel.text = balanceDifference
            self.titleLabel.isHidden = status
            self.balanceLoadedView.isHidden = !status
        }
    }
}
