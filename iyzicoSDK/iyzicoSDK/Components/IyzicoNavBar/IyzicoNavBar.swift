//
//  IyzicoNavBar.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 19.12.2020.
//

import Foundation
import UIKit

class IyzicoNavBar: BaseView {
    @IBOutlet weak var headerContainerStackView: UIStackView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorView2: UIView!
    @IBOutlet weak var seperatorView3: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var balanceContainerView: UIView!
    @IBOutlet weak var iyzicoBalanceImageView: UIImageView!
    @IBOutlet weak var iyzicoLogoImageView: UIImageView!
    @IBOutlet weak var iyzicoBalanceTitleLabel: UILabel!
    @IBOutlet weak var iyzicoBalanceAmountLabel: UILabel!
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var backButton: IyzicoButton!
    @IBOutlet weak var leftTitledTitleLabel: UILabel!
    @IBOutlet weak var leftTitledStackView: UIStackView!
    @IBOutlet weak var leftTitledCancelButton: UIButton!
    @IBOutlet weak var supportBackButton: IyzicoButton!
    
    var closeButtonType: NavBarDismissTypes = .cancel
    static var timer: Timer?
    var backgroundTime: Date?
    var currentSecond: Int?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        showCancelPopUp()
    }
    
    // MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoNavBar, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
    }
    
}
// MARK: - Helper Funcs
extension IyzicoNavBar {
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addObservers()
        setUpNameLabel()
        setUpTimeLabel()
        setUpSeperator()
        setUpCountDownLabel()
        setupCancelButton()
        setupTitleImageView()
        setupTimeImageView()
        setupPriceLabel()
        setupPriceTitleLabel()
        setupIyzicoBalanceImageView()
        setupIyzicoLogoImageView()
        setupIyzicoBalanceTitleLabel()
        setupIyzicoBalanceAmountLabel()
        setupHolderView()
        setupSupportBackButton()
        setupBackButton()
        setupLeftTitledTitleLabel()
        setupLeftTitledCancelButton()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(startTimer),
                                               name: .restartTimerAtPayWithIyzicoFlow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeObservers),
                                               name: .removePwiTimerObservers,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackgroundNotification),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .restartTimerAtPayWithIyzicoFlow, object: nil)
    }
    
    fileprivate func setUpNameLabel() {
        nameLabel.font = .markProBold16
    }
    
    fileprivate func setUpTimeLabel() {
        timeLabel.font = .markPro14
        timeLabel.textColor = .blueGrey
        timeLabel.text = StringConstant.shared.timeLabelName
    }
    
    fileprivate func setUpCountDownLabel() {
        countDownLabel.font = .markPro14
        countDownLabel.textColor = .blueGrey
        if SDKManager.flow == .payWithIyzico {
            NotificationCenter.default.post(name: .restartTimerAtPayWithIyzicoFlow, object: nil)
        }
    }
    
    fileprivate func setUpSeperator() {
        seperatorView.backgroundColor = .lineWhite
        seperatorView2.backgroundColor = .lineWhite
        seperatorView3.backgroundColor = .lineWhite
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle(StringConstant.shared.cancelButtonTitle,
                              for: .normal)
        cancelButton.titleLabel?.font = .markProBold16
        cancelButton.setTitleColor(.blueGrey, for: .normal)
    }
    
    private func setupTitleImageView() {
        titleImageView.image = Asset.navigationLogo.image
    }
    
    private func setupTimeImageView() {
        timeImageView.image = Asset.navigationHourglass.image
    }
    
    private func setupPriceLabel() {
        priceLabel.font = .markProBold16
        #warning("price")
        priceLabel.text = SDKManager.price?.addTLWithAlignment(alignment: .left)
    }
    
    private func setupPriceTitleLabel() {
        priceTitleLabel.font = .markPro14
        priceTitleLabel.textColor = .blueGrey
        priceTitleLabel.text = StringConstant.shared.priceTitleLabelName
    }
    
    private func setupIyzicoBalanceImageView() {
        iyzicoBalanceImageView.image = Asset.cards.image
    }
    
    private func setupIyzicoLogoImageView() {
        iyzicoLogoImageView.image =  Asset.navigationLogo.image
    }
    
    private func setupIyzicoBalanceTitleLabel() {
        iyzicoBalanceTitleLabel.text = StringConstant.shared.navBarBalanceTitle
        iyzicoBalanceTitleLabel.font = .markProBold16
        iyzicoBalanceTitleLabel.textColor = .darkGrey
    }
    
    private func setupIyzicoBalanceAmountLabel() {
        iyzicoBalanceAmountLabel.text = 0.00.addTLWithAlignment(alignment: .left)
        iyzicoBalanceAmountLabel.font = .markProBold16
        iyzicoBalanceAmountLabel.textColor = .darkGrey
    }
    
    private func setupHolderView() {
        holderView.backgroundColor = .paleGrey
        holderView.layer.cornerRadius = 2
    }
    
    private func setupBackButton() {
        backButton.button.setBackgroundImage(Asset.navigationGrayLeft.image, for: .normal)
    }
    
    private func setupSupportBackButton() {
        supportBackButton.button.setBackgroundImage(Asset.navigationGrayLeft.image, for: .normal)
    }

    private func setupLeftTitledTitleLabel() {
        leftTitledTitleLabel.textColor = .darkGrey
        leftTitledTitleLabel.font = .markProBold34
    }
    
    private func setupLeftTitledCancelButton() {
        leftTitledCancelButton.setTitle(StringConstant.shared.closeButtonTitle,
                                        for: .normal)
        leftTitledCancelButton.setTitleColor(.clearBlue3,
                                             for: .normal)
        leftTitledCancelButton.titleLabel?.font = .markProBold16
    }
        
    private func showCancelPopUp() {
        if closeButtonType == .cancel {
            NotificationCenter.default.post(name: .showAppCancelPopUp, object: nil)
        }
        else {
            SDKManager.closeSDK()
        }
    }
    private func invalidateTime() {
        NotificationCenter.default.post(name: .didFinishTimerAtPayWithIyzicoFlow, object: nil)
        self.countDownLabel.textColor = .blueGrey
    }
    
    @objc
    private func startTimer() {
        IyzicoNavBar.timer = countDownLabel.startTimerWithReturn(time: Constant.shared.appTimerSecond) { [weak self] second in
            self?.currentSecond = second
            if second == Constant.shared.invalidateTimer {
                IyzicoNavBar.timer?.invalidate()
                self?.invalidateTime()
            }
        }
    }
    
    @objc fileprivate func didEnterBackgroundNotification() {
        self.backgroundTime = Date()
    }
    
    @objc fileprivate func willEnterForegroundNotification() {
        let differenceInSeconds = Date() -  (backgroundTime ?? Date())
        let time = (self.currentSecond ??  Constant.shared.appTimerSecond) -  Int(differenceInSeconds)
        IyzicoNavBar.timer?.invalidate()
        if time < .zero {
            self.invalidateTime()
        } else {
            Constant.shared.appTimerSecond = time
            startTimer()
        }
        self.backgroundTime = nil
    }

}
