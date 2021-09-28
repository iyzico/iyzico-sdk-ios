//
//  ResultHeaderCell.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

protocol ResultCellDelegate: AnyObject {
    func configureButtonsVisibility(_ seeBankInformationButtonVisibility: Bool,
                                    _ returnToAppButtonVisibility: Bool)
    func appStoreButtonTapped()
}

class ResultCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var lottieInnerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceContainerStackView: UIStackView!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var footerContainerStackView: UIStackView!
    @IBOutlet weak var appStoreImageView: UIImageView!
    @IBOutlet weak var appStoreButton: UIButton!
    @IBOutlet weak var supportDescriptionLabel: UILabel!
    @IBOutlet weak var seeBankInformationButton: IyzicoButton!
    @IBOutlet weak var returnToAppButton: IyzicoButton!
    
    weak var delegate: ResultCellDelegate?
    
    var constants = ResultCellConstants.shared {
        didSet {
            configureCellUI(constants: constants)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: - Events
    @IBAction func appStoreButtonTapped(_ sender: Any) {
        delegate?.appStoreButtonTapped()
    }
    
    //MARK: - UI Configuration
    private func setupUI() {
        setupTitleLabel()
        setupSubTitleLabel()
        setupDescriptionLabel()
        setupBalanceTitleLabel()
        setupBalanceValueLabel()
        setupAppStoreImageView()
        setupSupportDescriptionLabel()
//        setupSeeBankInformationButton()
//        setupReturnToAppButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .blueGrey
        titleLabel.font = .markProMedium24
    }
    
    private func setupSubTitleLabel() {
        subTitleLabel.font = .markProBold24
        subTitleLabel.textColor = .darkGrey
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = .markPro16
        descriptionLabel.textColor = .blueGrey
    }
    
    private func setupBalanceTitleLabel() {
        balanceTitleLabel.font = .markPro14
        balanceTitleLabel.textColor = .darkGrey
    }
    
    private func setupBalanceValueLabel() {
        balanceValueLabel.font = .markProBold14
        balanceValueLabel.textColor = .darkGrey
    }
    
    private func setupAppStoreImageView() {
        appStoreImageView.image = Asset.resultAppStore.image
    }
    
    private func setupSupportDescriptionLabel() {
        supportDescriptionLabel.text = constants.supportDescriptionLabel
        supportDescriptionLabel.textColor = .gunmetal
        supportDescriptionLabel.font = .markPro14
    }
    
//    private func setupSeeBankInformationButton() {
//        seeBankInformationButton.setUp(buttonType: .secondary(state: .normal),
//                                       title: constants.seeBankInformationButton)
//    }
//
//    private func setupReturnToAppButton() {
//        returnToAppButton.setUp(buttonType: .primaryLvl1(state: .normal), title: constants.returnToAppButton)
//    }
    
    private func configureCellUI(constants: ResultCellConstants) {
        lottieInnerImageView.image = constants.headerImage
        
        titleLabel.text = constants.titleLabel
        subTitleLabel.text = constants.subTitleLabel
        descriptionLabel.text = constants.descriptionLabel
        balanceTitleLabel.text = constants.balanceTitleLabel
        balanceValueLabel.text = constants.balanceValueLabel
                
        lottieView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                             constant: constants.headerImageViewHeightConstraint).isActive = true
        
        let animationView = LottieManager.shared.getLottieView(toView: lottieView,
                                                               lottieType: constants.lottieType,
                                                               contentMode: .scaleToFill,
                                                               loopMode: .loop)
        lottieView.insertSubview(animationView, at: 0)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: lottieView.topAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: lottieView.trailingAnchor, constant: 0).isActive = true

        titleLabel.isHidden = !constants.titleLabelVisibility
        descriptionLabel.isHidden = !constants.descriptionLabelVisibility
        balanceContainerStackView.isHidden = !constants.balanceContainerStackViewVisibility
        footerContainerStackView.isHidden = !constants.footerContainerStackViewVisibility
        appStoreImageView.isHidden = !constants.appStoreImageViewVisibility
        supportDescriptionLabel.isHidden = !constants.supportDescriptionLabelVisibility
        delegate?.configureButtonsVisibility(!constants.seeBankInformationButtonVisibility,
                                             !constants.returnToAppButtonVisibility)
    }
    
    
}
