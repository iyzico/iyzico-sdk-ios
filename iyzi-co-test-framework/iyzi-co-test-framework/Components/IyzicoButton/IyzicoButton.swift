//
//  IyzicoButton.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 7.12.2020.
//

import Foundation
import UIKit

enum IyzicoButtonState: Int {
    
    case normal = 0
    case tapped
    case loading
    case passive
}

enum IyzicoButtonType {
    
    case primaryLvl1(state: IyzicoButtonState)
    case primaryLvl2(state: IyzicoButtonState)
    case primarySticky(state: IyzicoButtonState)
    case secondary(state: IyzicoButtonState)
    // case secondaryLvl2(state: IyzicoButtonState)
    case tertiary(state: IyzicoButtonState)
    case error(state: IyzicoButtonState)
    case warm(state: IyzicoButtonState)
    case success(state: IyzicoButtonState)
    case amount(state: IyzicoButtonState)
}

//@IBDesignable
public class IyzicoButton: UIView {
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var image: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    fileprivate var state: IyzicoButtonState = .normal
    fileprivate var currentButtonMode:IyzicoButtonType = .primaryLvl1(state: .normal)
    
    var didTappedButton: (()->())?
    
    @IBInspectable var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = .zero {
        didSet {
            self.contentView.layer.cornerRadius = cornerRadius
            self.button.layer.cornerRadius = cornerRadius
            self.contentView.layer.masksToBounds = true
        }
    }
    @IBInspectable var backGroundColor: UIColor? {
        didSet {
            self.button.backgroundColor = backGroundColor
        }
    }
    @IBInspectable var indicatorStyle: UIActivityIndicatorView.Style = .gray {
        didSet {
            self.indicator.style = indicatorStyle
        }
    }
    
    init(buttonType: IyzicoButtonType, title: String? = nil, image: String? = nil, cornerRadius: CGFloat = .zero) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        loadViewFromNib()
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        if image != nil && title != nil {
            buttonImageView.setImage(named: image ?? Asset.target.name, typeof: self)
            buttonImageView.isHidden = false
            setLeftImageConst()
        } else if title == nil {
            buttonImageView.setImage(named: image ?? Asset.target.name, typeof: self)
            buttonImageView.isHidden = false
            button.titleLabel?.alpha = .zero
            setCenterImageConst()
        } else {
            setIndicatorConst()
        }
        
        switch buttonType {
            case .primaryLvl1(let state):
                primaryLvl1UI(state:state, title: title)
            case .primaryLvl2(let state):
                primaryLvl2UI(state:state, title: title)
            case .primarySticky(let state):
                primaryStickyUI(state:state, title: title)
            case .secondary(let state):
                secondaryLvl1UI(state: state,title: title)
            case .tertiary(let state):
                tertiaryUI(state: state,title: title)
            case .error(let state):
                errorUI(state: state,title: title)
            case .warm(let state):
                warmUI(state: state,title: title)
            case .success(let state):
                successUI(state: state,title: title)
            case .amount(let state):
                amountUI(state: state,title: title)
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    
    //MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoButton, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setUp(buttonType: IyzicoButtonType,
               title: String? = nil,
               image: String? = nil,
               cornerRadius: CGFloat = Constant.shared.iyzicoButtonCornerRadius) {
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        if image != nil && title != nil {
            buttonImageView.setImage(named: image ?? Asset.target.name, typeof: self)
            buttonImageView.isHidden = false
            setLeftImageConst()
        } else if title == nil {
            buttonImageView.setImage(named: image ?? Asset.target.name, typeof: self)
            buttonImageView.isHidden = false
            button.titleLabel?.alpha = .zero
            setCenterImageConst()
        } else {
            setIndicatorConst()
        }
        
        switch buttonType {
            case .primaryLvl1(let state):
                primaryLvl1UI(state:state, title: title)
            case .primaryLvl2(let state):
                primaryLvl2UI(state:state, title: title)
            case .primarySticky(let state):
                primaryStickyUI(state:state, title: title)
            case .secondary(let state):
                secondaryLvl1UI(state: state,title: title)
            case .tertiary(let state):
                tertiaryUI(state: state,title: title)
            case .error(let state):
                errorUI(state: state,title: title)
            case .warm(let state):
                warmUI(state: state,title: title)
            case .success(let state):
                successUI(state: state,title: title)
            case .amount(let state):
                amountUI(state: state,title: title)
        }
        
    }
}

// MARK: - Button Action
extension IyzicoButton {
    @IBAction func didTappedButton(_ sender: Any) {
        didTappedButton?()
    }
}

extension IyzicoButton {
    
    func activeButton() {
        self.button.isUserInteractionEnabled = true
    }
    
    func disableButton() {
        self.button.isUserInteractionEnabled = false
    }
}

// MARK: - SetUI
extension IyzicoButton {
    
    // MARK: - PRIMARY
    func primaryLvl1UI(state:IyzicoButtonState, title: String? = "") {
        //contentView.layer.cornerRadius = 20
        // contentView.layer.masksToBounds = true
        self.state = state
        currentButtonMode = .primaryLvl1(state: state)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .white
        self.button.isUserInteractionEnabled = true
        switch state {
            case .normal:
                self.button.setBackgroundColor(.clearBlue, for: .normal)
                self.button.setBackgroundColor(.dodgerBlue, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.dodgerBlue, for: .highlighted)
            case .loading:
                self.button.backgroundColor = .niceBlue
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                self.button.isUserInteractionEnabled = false
                self.button.backgroundColor = .paleGray3
                button.setTitleColor(.gray500, for: .normal)
                
        }
    }
    
    func primaryLvl2UI(state:IyzicoButtonState, title: String? = "") {
        //contentView.layer.cornerRadius = 28
        //  contentView.layer.masksToBounds = true
        self.state = state
        currentButtonMode = .primaryLvl2(state: state)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .white
        switch state {
            case .normal:
                
                self.button.setBackgroundColor(.clearBlue, for: .normal)
                self.button.setBackgroundColor(.dodgerBlue2, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.dodgerBlue2, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                self.button.backgroundColor = .niceBlue
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                self.button.backgroundColor = .paleGray3
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .markProBold16
                makePassive()
        }
    }
    
    func primaryStickyUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .primarySticky(state: state)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .white
        switch state {
            case .normal:
                
                self.button.setBackgroundColor(.clearBlue, for: .normal)
                self.button.setBackgroundColor(.dodgerBlue2, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.dodgerBlue2, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                self.button.backgroundColor = .niceBlue
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                self.button.backgroundColor = .paleGray3
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .markProBold16
                makePassive()
        }
    }
    // MARK: - SECONDARY
    func secondaryLvl1UI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .secondary(state: state)
        button.addBorder()
        //button.layer.cornerRadius = 28
        // button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.clearBlue, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .clearBlue
        switch state {
            case .normal:
                self.button.setBackgroundColor(.white, for: .normal)
                self.button.setBackgroundColor(.paleBlue, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.paleBlue, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .niceBlue
                self.button.backgroundColor = .niceBlue
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                button.layer.borderColor  = UIColor.lightGray.cgColor
                self.button.backgroundColor = .paleGray3
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .markProBold16
                makePassive()
        }
    }
    // MARK: - Tertiary
    func tertiaryUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .tertiary(state: state)
        button.addBorder(borderColor: UIColor.gray600.cgColor)
        //button.layer.cornerRadius = 28
        //button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .gray600
        switch state {
            case .normal:
                self.button.setBackgroundColor(.white, for: .normal)
                self.button.setBackgroundColor(.paleGray3, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.paleGray3, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .gray600
                self.button.backgroundColor = .paleGray3
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                button.layer.borderColor  = UIColor.paleGray3.cgColor
                self.button.backgroundColor = .clear
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .markProBold16
                makePassive()
        }
    }
    // MARK: - Error
    func errorUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .error(state: state)
        //button.layer.cornerRadius = 28
        // button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.red900, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .red900
        switch state {
            case .normal:
                self.button.setBackgroundColor(.red400, for: .normal)
                self.button.setBackgroundColor(.red500, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.red500, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .red900
                self.button.backgroundColor = .red400
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                break
        }
    }
    // MARK: - Warm
    func warmUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .warm(state: state)
        //button.layer.cornerRadius = 28
        // button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.yellowBrown, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .yellowBrown
        switch state {
            case .normal:
                self.button.setBackgroundColor(.pale, for: .normal)
                self.button.setBackgroundColor(.darkCream, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.darkCream, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .yellowBrown
                self.button.backgroundColor = .pale
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                break
        }
    }
    // MARK: - Success
    func successUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .success(state: state)
        //button.layer.cornerRadius = 28
        //button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.green900, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .green900
        switch state {
            case .normal:
                self.button.setBackgroundColor(.green500, for: .normal)
                self.button.setBackgroundColor(.green600, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.darkCream, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .green900
                self.button.backgroundColor = .green600
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                break
        }
    }
    //MARK: - Amount
    func amountUI(state:IyzicoButtonState, title: String? = "") {
        self.state = state
        currentButtonMode = .amount(state: state)
        button.addBorder(borderColor: UIColor.blueGrey.cgColor)
        //button.layer.cornerRadius = 28
        //button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blueGrey, for: .normal)
        button.titleLabel?.font = .markProBold16
        buttonImageView.tintColor = .blueGrey
      //  button.layer.cornerRadius = Constant.shared.amountInputCornerRadius
        switch state {
            case .normal:
                self.button.setBackgroundColor(.white, for: .normal)
                self.button.setBackgroundColor(.paleGray3, for: .highlighted)
            case .tapped:
                self.button.setBackgroundColor(.paleGray3, for: .highlighted)
            case .loading:
                indicator.style = .whiteLarge
                indicator.color = .gray600
                self.button.backgroundColor = .paleGray3
                showLoading(isIndicatorHidden: false, style: indicator.style)
            case .passive:
                button.layer.borderColor  = UIColor.paleGray3.cgColor
                self.button.backgroundColor = .clear
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = .markProBold16
                makePassive()
        }
    }
}

// MARK: - Helper Funcs
extension IyzicoButton {
    
    func showLoading(isIndicatorHidden:Bool = true, style:UIActivityIndicatorView.Style) {
        stackView.isHidden = !isIndicatorHidden
        indicator.isHidden = isIndicatorHidden
        if buttonImageView.isHidden != false {
            button.titleLabel?.alpha = .zero
        }
        indicator.style = style
        buttonImageView.isHidden = true
        disableButton()
        switch currentButtonMode {
            case .primaryLvl1(state: self.state), .primaryLvl2(state: self.state), .primarySticky(state: self.state):
                button.backgroundColor = .niceBlue
            case .secondary(state: self.state):
                button.backgroundColor = .white
                indicator.color = .niceBlue
            case .tertiary(state: self.state):
                indicator.color = .gray600
                self.button.backgroundColor = .paleGray3
            case .error(state: self.state):
                button.backgroundColor = .red400
                indicator.color = .red900
            case .warm(state: self.state):
                button.backgroundColor = .pale
                indicator.color = .yellowBrown
            case .success(state: self.state):
                button.backgroundColor = .green600
                indicator.color = .green900
            default:
                break
        }
        
    }
    func makePassive() {
        button.backgroundColor = .paleGray3
        button.setTitleColor(.gray500, for: .normal)
        disableButton()
        switch currentButtonMode {
            case .primaryLvl1(state: self.state), .primaryLvl2(state: self.state), .primarySticky(state: self.state):
                self.button.setBackgroundColor(.paleGray3, for: .normal)
                button.setTitleColor(.gray500, for: .normal)
                buttonImageView.tintColor = .gray500
            case .secondary(state: self.state):
                self.button.setBackgroundColor(.paleGray3, for: .normal)
                button.setTitleColor(.gray500, for: .normal)
                buttonImageView.tintColor = .gray500
                button.layer.borderColor = UIColor.paleGray3.cgColor
            case .tertiary(state: self.state):
                self.button.setBackgroundColor(.paleGray3, for: .normal)
                button.setTitleColor(.gray600, for: .normal)
                if  button.titleLabel?.alpha == .zero {
                    buttonImageView.tintColor = UIColor.gray600.withAlphaComponent(Constant.shared.iyzicoButtonButtonTintAlpha)
                } else {
                    buttonImageView.tintColor = .gray600
                }
                button.layer.borderColor = UIColor.paleGray3.cgColor
            case .error(state: self.state):
                self.button.setBackgroundColor(.red400, for: .normal)
            // indicator.color = .red900
            case .warm(state: self.state):
                self.button.setBackgroundColor(.pale, for: .normal)
            // indicator.color = .yellowBrown
            case .success(state: self.state):
                self.button.setBackgroundColor(.green600, for: .normal)
            // indicator.color = .green900
            default:
                break
        }
    }
        
        func makeActive() {
            activeButton()
            switch currentButtonMode {
                case .primaryLvl1(state: self.state), .primaryLvl2(state: self.state), .primarySticky(state: self.state):
                    
                    buttonImageView.tintColor = .white
                    button.setTitleColor(.white, for: .normal)
                    self.button.setBackgroundColor(.clearBlue, for: .normal)
                    
                case .secondary(state: self.state):
                    
                    button.addBorder()
                    buttonImageView.tintColor = .clearBlue
                    button.setTitleColor(.clearBlue, for: .normal)
                    self.button.setBackgroundColor(.white, for: .normal)
                    
                case .tertiary(state: self.state):
                
                    button.addBorder(borderColor: UIColor.gray600.cgColor)
                    button.setTitleColor(.gray600, for: .normal)
                    button.titleLabel?.font = .markProBold16
                    buttonImageView.tintColor = .gray600
                    self.button.setBackgroundColor(.white, for: .normal)
                    self.button.setBackgroundColor(.paleGray3, for: .highlighted)
                    
                case .error(state: self.state):
                    self.button.setBackgroundColor(.red400, for: .normal)
                case .warm(state: self.state):
                    self.button.setBackgroundColor(.pale, for: .normal)
                case .success(state: self.state):
                    self.button.setBackgroundColor(.green500, for: .normal)
                default:
                    break

            
        }
    }
    
    func setSelectedUI(borderColor: UIColor, titleColor: UIColor) {
        button.layer.borderColor = borderColor.cgColor
        button.setTitleColor(titleColor, for: .normal)
    }
    func deSelectedUI( borderColor: UIColor, titleColor: UIColor) {
        button.layer.borderColor = borderColor.cgColor
        button.setTitleColor(titleColor, for: .normal)
    }
}

//MARK:- Constraint
extension IyzicoButton {
    
    fileprivate func setLeftImageConst() {
        setIndicatorConst()
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: Constant.shared.iyzicoButtonbuttonImageViewleadingAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: Constant.shared.iyzicoButtonbuttonImageViewWidthConst),
            buttonImageView.heightAnchor.constraint(equalToConstant: Constant.shared.iyzicoButtonbuttonImageViewHeightConst)
        ])
    }
    
    fileprivate func setCenterImageConst() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: Constant.shared.iyzicoButtonIndicatorleadingAnchor)
        ])
        
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            buttonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: Constant.shared.iyzicoButtonbuttonImageViewWidthConst),
            buttonImageView.heightAnchor.constraint(equalToConstant: Constant.shared.iyzicoButtonbuttonImageViewHeightConst)
        ])
    }
    
    fileprivate func setIndicatorConst() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: Constant.shared.iyzicoButtonIndicatorleadingAnchor)
        ])
    }
}
//MARK:- Customize
extension IyzicoButton {
    func customizeButtonTitleEdgeInsets(contentHorizontalAlignment: UIControl.ContentHorizontalAlignment, leftSpacing :CGFloat, rightSpacing: CGFloat, topSpacing: CGFloat, bottomSpacing: CGFloat) {
        button.contentHorizontalAlignment = contentHorizontalAlignment
        button.titleEdgeInsets = UIEdgeInsets(top: topSpacing, left: leftSpacing, bottom: bottomSpacing, right: rightSpacing)
    }
}
