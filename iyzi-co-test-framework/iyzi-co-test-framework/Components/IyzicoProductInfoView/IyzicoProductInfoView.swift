//
//  IyzicoProductInfoView.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 28.01.2021.
//

import UIKit

class IyzicoProductInfoView: BaseView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        loadNib()
        setupUI()
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupProductNameLabel()
        setupProductPriceLabel()
        setupContainerStackView()
    }
    
    private func setupProductNameLabel() {
        productNameLabel.font = .markPro14
        productNameLabel.textColor = .darkGrey
    }
    
    private func setupProductPriceLabel() {
        productPriceLabel.font = .markProBold14
        productPriceLabel.textColor = .darkGrey
    }
    
    private func setupContainerStackView() {
        containerStackView.addBorder(borderWidth: 0.5, borderColor: UIColor.silver.cgColor)
    }
    
    //MARK: - Helper Methods
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoProductInfoView, bundle: bundle)
        self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(containerView)
    }
}
