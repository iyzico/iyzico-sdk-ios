//
//  BottomAlertVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 17.03.2021.
//

import UIKit

class BottomAlertVC: BaseVC, BSPresentable {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailButton: UIButton!
    //
    var modalContentHeight: CGFloat {
        return 200.0
    }
    private typealias constants = StringConstant.BottomAlertVC
    
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.BottomAlertVC, bundle: bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Events
    @IBAction func phoneButtonTapped(_ sender: UIButton) {
        constants.supportPhoneNumber.callPhoneNumber()
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        constants.supportMail.openMail()
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupLineView()
        setupTitleLabel()
        setupPhoneImageView()
        setupPhoneButton()
        setupEmailImageView()
        setupEmailButton()
    }
    
    private func setupLineView() {
        lineView.clipsToBounds = true
        lineView.layer.cornerRadius = 2
        lineView.backgroundColor = .paleGrey
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .markProBold16
        titleLabel.textColor = .darkGrey
        titleLabel.text = constants.titleLabel
    }
    
    private func setupPhoneImageView() {
        phoneImageView.image = Asset.iconPhone.image
    }
    
    private func setupPhoneButton() {
        phoneButton.setTitle(constants.supportPhoneNumber, for: .normal)
        phoneButton.setTitleColor(.clearBlue, for: .normal)
        phoneButton.titleLabel?.font = .markProMedium14
    }
    
    private func setupEmailImageView() {
        emailImageView.image = Asset.iconMail.image
    }
    
    private func setupEmailButton() {
        emailButton.setTitle(constants.supportMail, for: .normal)
        emailButton.setTitleColor(.clearBlue, for: .normal)
        emailButton.titleLabel?.font = .markProMedium14
    }
    
    //MARK: - Helper Methods
}
