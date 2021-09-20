//
//  IyzicoInfoView.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 21.12.2020.
//

import Foundation
import UIKit

class IyzicoInfoView: BaseView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageContentView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var iyzicoImageContentView: UIView!
    @IBOutlet weak var iyzicoImageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    // MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoInfoView, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
        
    }
}
// MARK: - SETUP
extension IyzicoInfoView {
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setUpTitleLabel()
        setUpPriceLabel()
    }

    fileprivate func setUpTitleLabel() {
        titleLabel.font = .markProMedium16
        titleLabel.textColor = .darkGrey
    }
    
    fileprivate func setUpPriceLabel() {
        priceLabel.font = .markProBold16
        priceLabel.textColor = .clearBlue
    }
    
    fileprivate func setUpIyzicoImageView() {
        iyzicoImageContentView.isHidden = false
        iyzicoImageView.image = Asset.iyzico.image
    }
    
    func setUp(image: String, title: String, price: String, priceTextColor: UIColor = .clearBlue, showImage: Bool = false) {
        iconImageView.image = UIImage(named: image)
        titleLabel.text = title
        priceLabel.text = price.addTL
        priceLabel.textColor = priceTextColor
        if showImage {
            setUpIyzicoImageView()
        }
    }
}
