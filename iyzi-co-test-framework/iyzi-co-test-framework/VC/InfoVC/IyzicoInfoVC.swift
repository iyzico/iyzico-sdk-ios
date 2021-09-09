//
//  IyzicoInfoVC.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 21.12.2020.
//

import UIKit

class IyzicoInfoVC: BaseVC {
    
    @IBOutlet weak var iyzicoLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var transferView: IyzicoInfoView!
    @IBOutlet weak var largeSeperatorView: UIView!
    @IBOutlet weak var balanceView: IyzicoInfoView!
    @IBOutlet weak var transferContentView: UIView!
    @IBOutlet weak var iyzicoButton: IyzicoButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var vcType: IyzicoInfoVCEnum = .transferring
    
    convenience init(vcType: IyzicoInfoVCEnum) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.IyzicoInfoVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

  
}
// MARK: - Action
extension IyzicoInfoVC {
    
    @IBAction func didTappedCloseButton(_ sender: Any) {
        print("22")
    }
}
// MARK: - SETUP
extension IyzicoInfoVC {
    
    fileprivate func setUpUI() {
        setUpContentImageView()
        setUpIyzicoLabel()
        setUpSeperatorView()
        setUpDescLabel()
        setUpIyzicoButton()
        if vcType == .transferring {
            setUpTransferContentView()
        }
    }
    
    fileprivate func setUpContentImageView() {
        contentImageView.image = Asset.news.image
    }
    
    fileprivate func setUpIyzicoLabel() {
        iyzicoLabel.font = .markProBold24
        iyzicoLabel.textColor = .darkGrey
        iyzicoLabel.numberOfLines = .zero
        iyzicoLabel.textAlignment = .center
        
        switch vcType {
            case .received:
                iyzicoLabel.addAttribute(text:StringConstant.shared.iyzicoInfoVCRecievedIyzicoFulltitle, attText: StringConstant.shared.iyzicoInfoVCRecievedIyzicoTitle, color: .blueGrey ,highletedFont: .markProMedium24)
            case .transferred:
                iyzicoLabel.text = StringConstant.shared.iyzicoInfoVCTransferredIyzicoTitle
            case .transferring:
                iyzicoLabel.text = StringConstant.shared.iyzicoInfoVCTransferringIyzicoTitle
            case .allOk:
                iyzicoLabel.text = StringConstant.shared.iyzicoInfoVCAllOkIyzicoTitle
        }
       
    }
    
    fileprivate func setUpSeperatorView() {
        seperatorView.backgroundColor = .pinkishGrey
    }
    
    fileprivate func setUpDescLabel() {
        descLabel.font = .markProMedium16
        descLabel.textColor = .darkBlueGrey
        descLabel.numberOfLines = .zero
        descLabel.textAlignment = .center
        
        switch vcType {
            case .received:
                descLabel.text = (SDKManager.brand ?? "") + "’a \(StringConstant.shared.iyzicoInfoVCRecievedDescText)"
            case .transferred:
                descLabel.text =  SDKManager.email ?? "" + " \(StringConstant.shared.iyzicoInfoVCTransferredDescText)"
            case .transferring:
                descLabel.text = StringConstant.shared.iyzicoInfoVCTransferringDescText
            case .allOk:
                descLabel.text = "₺100,00 \(StringConstant.shared.iyzicoInfoVCAllOkDescText)"
        }
        
    }
    
    fileprivate func setUpIyzicoButton() {
        switch vcType {
            case .received, .transferred:
                iyzicoButton.setUp(buttonType: .primaryLvl1(state: .normal),title: StringConstant.shared.iyzicoInfoVCReturnApp)
            case .transferring:
                iyzicoButton.setUp(buttonType: .primaryLvl1(state: .normal),title: StringConstant.shared.iyzicoInfoVCApprove)
            case .allOk:
                iyzicoButton.setUp(buttonType: .primaryLvl1(state: .normal),title: StringConstant.shared.iyzicoInfoVCMainPage)
        }
    }
    
    fileprivate func setUpTransferContentView() {
        transferContentView.isHidden = false
        transferView.setUp(image: Asset.refund.name, title: StringConstant.shared.iyzicoInfoVCTransferTitle, price: "44,70")
        balanceView.setUp(image: Asset.card.name, title: StringConstant.shared.iyzicoInfoVCBalanceTitle, price: "0,00",showImage: true)
        setUpLargeSeperatorView()
    }
    
    fileprivate func setUpLargeSeperatorView() {
        largeSeperatorView.backgroundColor = .pinkishGrey
    }
}
