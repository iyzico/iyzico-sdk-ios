//
//  IyzicoDeliveryAdressView.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 28.01.2021.
//

import UIKit

class IyzicoDeliveryAdressView: BaseView {
    @IBOutlet var containerView: UIView!
    
    override func commonInit() {
        super.commonInit()
        loadNib()
        setupUI()
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        
    }
    
    //MARK: - Helper Methods
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoDeliveryAdressView, bundle: bundle)
        self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(containerView)
    }
}
