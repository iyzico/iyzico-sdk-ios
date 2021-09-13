//
//  IyzicoMemberView.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 9.02.2021.
//

import UIKit

class IyzicoMemberView: BaseView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var memberButtonAction: (() -> Void)?
    
    private typealias uiConstants = Constant.IyzicoMemberViewConstants
    
    override func commonInit() {
        super.commonInit()
        loadNib()
        setupUI()
    }
    
    //MARK: - Events
    @IBAction func memberButtonTapped(_ sender: Any) {
        memberButtonAction?()
    }
    
    //MARK: - Helper Methods
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoMemberView, bundle: bundle)
        containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupParentView()
        setupEmailLabel()
        setupDescriptionLabel()
    }
    
    private func setupParentView() {
        parentView.backgroundColor = .clearBlue3
        parentView.layer.cornerRadius = uiConstants.cornerRadius
    }
    
    private func setupEmailLabel() {
        emailLabel.textColor = .white
        emailLabel.font = .markProMedium16
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.textColor = .white
        descriptionLabel.font = .markPro16
    }
}
