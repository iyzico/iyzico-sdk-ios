//
//  IyzicoMenuHeaderView.swift
//  iyzicoSDK
//
//  Created by Kasım Sağır on 22.12.2020.
//

import UIKit

class IyzicoMenuHeaderView: UIView {
    
    public var didTappedHeader: (()->())?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var IyzicoHeaderImageView: UIImageView!
    @IBOutlet weak var IyzicoHeaderLabel: UILabel! {
        didSet {
            IyzicoHeaderLabel.font = .markProMedium16
            IyzicoHeaderLabel.textColor = .darkGrey
        }
    }
    @IBOutlet weak var IyzicoHeaderArrowView: UIImageView!
    
    private var leftImage: String = ""
    private var title: String = ""
    var isExtended: Bool = false
  
    func setExtended(_ isExtended: Bool) {
        self.isExtended = isExtended
        IyzicoHeaderArrowView.image = isExtended ? Asset.icnUparrow.image : Asset.icnDownarrow.image
    }
    
    // MARK: - Init
    init(image: String, title: String, isExtended: Bool =  false) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        
        defer {
            self.title = title
            self.leftImage = image
            self.isExtended = isExtended
            self.loadViewFromNib()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    //MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoMenuHeaderView, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpView()
    }
    
    private func setUpView(){
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        IyzicoHeaderArrowView.image = isExtended ? Asset.icnUparrow.image : Asset.icnDownarrow.image
        IyzicoHeaderLabel.text = title
      //  guard let image = UIImage(named: leftImage) else {return}
       // IyzicoHeaderImageView.image = image
        IyzicoHeaderImageView.setImage(named: leftImage, typeof: self)
    }
    
    
    @IBAction func didTappedHeaderButton(_ sender: Any) {
        isExtended.toggle()
        IyzicoHeaderArrowView.image = isExtended ? Asset.icnUparrow.image : Asset.icnDownarrow.image
        didTappedHeader?()
    }
}
