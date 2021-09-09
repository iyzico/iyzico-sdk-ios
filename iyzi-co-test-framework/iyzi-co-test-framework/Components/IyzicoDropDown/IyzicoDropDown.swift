//
//  IyzicoDropDown.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 9.12.2020.
//

import Foundation
import UIKit

enum DropdownType: Int {
    case select = 0
    case search
    case card
}

class IyzicoDropDown: UIView {
    
   // public static let shared = IyzicoDropDown()
    @IBOutlet weak var dropDownViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var tableContentView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var selectedTitleLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = .zero
            tableView.separatorInset = UIEdgeInsets(top: .zero, left: Constant.shared.seperatorLeftPadding, bottom: .zero, right: Constant.shared.seperatorRightPadding)
            tableView.tableFooterView = UIView(frame: .zero)
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: NibName.shared.TitleCell, bundle: bundle)
            tableView.register(nib, forCellReuseIdentifier: NibName.shared.TitleCell)
        }
    }
    var getViewHeight: ((CGFloat)->())?
    private var viewHeight: CGFloat = .zero
    private let cellHeight: CGFloat = Constant.shared.cellHeight
    private var dataArray: [String] = [] {
        didSet {
            calculateTableViewHeight()
        }
    }
    var title: String = ""
    private var dropdownType: DropdownType = .select
    private var opened: Bool = false
    //var selectedTitleText = "Kart üzerindeki isim"
    
    //MARK: - Init
    init(dropdownType: DropdownType, data: [String]? = [], title:String) {
        super.init(frame: CGRect(origin: .zero, size:.zero))
        self.dropdownType = dropdownType
        loadViewFromNib()
        self.title = title
        setUpDropDownLabel(title: title)
        if data != nil {
            do {
                setUpTableViewData(data: data!)
            }
        }
        switch dropdownType {
            case .search:
                setUpSearchView()
            case .select:
                setUpButtonView()
            case .card:
                setUpCardView()
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
   
    // MARK: - Setup
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NibName.shared.IyzicoDropDown, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        setUpContentView()
        setUpDropDownView()
        setUpTableView()
        setUpSelectedLabels()
        setUpButton()
        rightImageView.image = Asset.icnDownarrow.image
    }
}

// MARK: - Button Acitons
extension IyzicoDropDown {
    
    @IBAction func didTappedDropDownButton(_ sender: Any) {
        opened.toggle()
        if opened {
            setUpOpenedDropdown()
            if dropdownType == .search {
                getViewHeight?(dropDownViewHeight.constant)
            } else {
                getViewHeight?(viewHeight)
            }
        } else {
            selectedDropDownMenu()
            getViewHeight?(dropDownViewHeight.constant)
        }
    }
}

//MARK:- funcs
extension IyzicoDropDown {
    
    fileprivate func setUpContentView() {
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    fileprivate func setUpDropDownLabel(title:String) {
        self.dropdownLabel.text = title
        dropdownLabel.font = .markProMedium16
    }
    
    fileprivate func setUpDropDownView() {
        dropdownView.addBorder(borderColor: UIColor.gray400.cgColor)
        dropdownView.layer.cornerRadius = Constant.shared.dropDownViewCornerRadius
        dropdownView.layer.masksToBounds = true
    }
    
    fileprivate func setUpSearchView() {
        leftImageView.image = Asset.icnSearch.image
        leftView.isHidden = false
        buttonView.isHidden = true
        selectedView.isHidden = true
        searchView.isHidden = false
        textField.font = .markProMedium16
        textField.delegate = self
    }
    
    fileprivate func setUpSelectedView() {
        buttonView.isHidden = true
        selectedView.isHidden = false
        searchView.isHidden = true
        dropdownView.addBorder(borderColor: UIColor.gray400.cgColor)
    }
    
    fileprivate func setUpButtonView() {
        if dropdownType == .search {
            searchView.isHidden = false
            buttonView.isHidden = true
            leftView.isHidden = false
        } else  if dropdownType == .select {
            searchView.isHidden = true
            buttonView.isHidden = false
            leftView.isHidden = true
        } else {
            searchView.isHidden = true
            buttonView.isHidden = false
            leftView.isHidden = false
        }
        selectedView.isHidden = true
    }
    
    fileprivate func setUpCardView() {
        leftImageView.image = Asset.cards.image
        rightImageView.tintColor = .niceBlue
        searchView.isHidden = true
        buttonView.isHidden = false
        leftView.isHidden = false
        selectedView.isHidden = true
    }
    
    fileprivate func setUpButton() {
        if self.dropdownType == .search {
            dropdownButton.isUserInteractionEnabled = false
        }
    }
    
    fileprivate func setUpOpenedDropdown() {
        dropdownView.addBorder()
        if self.dropdownType == .search {
            rightImageView.tintColor = .lightGray
            tableContentView.isHidden = true
        } else if self.dropdownType == .select {
            rightImageView.tintColor = .lightGray
            rightImageView.image = Asset.icnUparrow.image
            tableContentView.isHidden = false
        } else {
            rightImageView.image = Asset.icnUparrow.image
            rightImageView.tintColor = .niceBlue
            tableContentView.isHidden = false
        }
        dropdownView.backgroundColor = .white
        setUpButtonView()
    }
    
    fileprivate func selectedDropDownMenu() {
        if dropdownType == .search {
            dropdownView.addBorder()
        } else {
            rightImageView.image = Asset.icnDownarrow.image
            dropdownView.addBorder(borderColor: UIColor.gray400.cgColor)
        }
        tableContentView.isHidden = true
    }
    
    // MARK: - Setup
    fileprivate func setUpTableView() {
        tableView.addBorder(borderColor: UIColor.gray400.cgColor)
        tableView.layer.cornerRadius = Constant.shared.dropDownViewCornerRadius
    }
  
    fileprivate func setUpSelectedLabels() {
        errorImageView.image = Asset.error.image
        selectedTitleLabel.font = .markPro12
        selectedLabel.font = .markProMedium16
    }
    
    fileprivate func selectedData(title:String) {
        setUpSelectedView()
        tableContentView.isHidden = true
        opened = false
        selectedLabel.text = title
        selectedTitleLabel.text = self.title
        rightImageView.image = Asset.icnDownarrow.image
        errorView.isHidden = true
        if dropdownType == .search {
            dropdownButton.isUserInteractionEnabled = true
            textField.text = nil
        }
        getViewHeight?(dropDownViewHeight.constant)
    }
    
    fileprivate func setUpTextFieldTableView() {
        tableContentView.isHidden = false
        opened = false
        rightImageView.image = Asset.icnUparrow.image
    }
    
    fileprivate func calculateTableViewHeight() {
        if dataArray.count > Constant.shared.maxDataCount {
            viewHeight = (CGFloat(Constant.shared.maxDataCount) * cellHeight) + dropDownViewHeight.constant
        } else {
            print(CGFloat(dataArray.count))
            print(CGFloat(dataArray.count) * cellHeight)
            viewHeight = (CGFloat(dataArray.count) * cellHeight) + dropDownViewHeight.constant
        }
    }
    func setUpTableViewData(data:[String]) {
        dataArray = data
    }
    
    
    func setTableViewData(data:[String]) {
        dataArray = data
        calculateTableViewHeight()
    }
}

// MARK: - Helper Funcs
extension IyzicoDropDown {
    
    func showError() {
        errorView.isHidden = false
        dropdownView.layer.borderColor = UIColor.red900.cgColor
        rightImageView.tintColor = .red900
        dropdownView.backgroundColor = .red400
    }
}

//MARK: - UITableView DataSource
extension IyzicoDropDown: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibName.shared.TitleCell, for: indexPath) as! TitleCell
        cell.setCell(title: dataArray[indexPath.row])
        return cell
    }
}

//MARK: - TableView Delegate
extension IyzicoDropDown: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData(title: dataArray[indexPath.row])
       // showError()
    }
}

//MARK: - TextField Delegate
extension IyzicoDropDown: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropdownView.layer.borderColor = UIColor.niceBlue.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let numberOfChars = newText?.count ?? .zero
        if numberOfChars > Constant.shared.dropDownSearchCount {
            getViewHeight?(viewHeight)
            setUpTextFieldTableView()
        } else if string == "" {
            getViewHeight?(dropDownViewHeight.constant)
        }
        return true
    }
}
