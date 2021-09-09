//
//  IyzicoSectionView.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 28.01.2021.
//

import UIKit

class IyzicoSectionView: BaseView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        loadNib()
        setupTitleLabel()
    }
    
    //MARK: - UI Configuration
    private func setupTitleLabel() {
        titleLabel.font = .markPro16
        titleLabel.textColor = .darkGrey
    }
    
    //MARK: - Helper Methods
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoSectionView, bundle: bundle)
        self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(containerView)
    }
}
