//
//  PhoneVC.swift
//  iyzi-co-testApp
//
//  Created by Tolga İskender on 18.12.2020.
//

import UIKit

class PhoneVC: BaseVC {
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var termView: IyzicoTermAndCond!
    @IBOutlet weak var textField: IyzicoTextInput!
    @IBOutlet weak var continueButton: IyzicoButton!
    
    private var vcType: PhoneVCEnum = .phone
    
    convenience init(vcType: PhoneVCEnum) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.phoneVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContentImageView()
        setUpInputTextField()
        setUpTermView()
        setUpContinueButton()
        didTappedContinueButton()
    }

}
// MARK: - Action
extension PhoneVC {
    fileprivate func didTappedContinueButton() {
        continueButton.didTappedButton = { [unowned self] in
            let otpVC = OTPVC()
            self.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
}
// MARK: - SETUP
extension PhoneVC {
    
    fileprivate func setUpContentImageView() {
        contentImageView.image = vcType.image
    }
    
    fileprivate func setUpInputTextField() {
        
        if vcType.type == .phone {
            textField.phoneViewSetup(textInputType: .phone, title: vcType.textFieldTitle)
        } else {
            textField.textViewSetup(textInputType: .text, title: vcType.textFieldTitle)
        }
      
    }
    fileprivate func setUpTermView() {
        if vcType == .phone {
            termView.isHidden = true
        } else {
//            termView.setUpTermView(title: StringConstant.shared.phoneVCTermString, highlightedText: StringConstant.shared.phoneVCTermHighletedString, textFont: .markPro14, highletedFont: .markPro14)
        }
      
    }
    
    fileprivate func setUpContinueButton() {
        continueButton.setUp(buttonType: .primaryLvl1(state: .normal), title: vcType.buttonTitle)
    }
}
