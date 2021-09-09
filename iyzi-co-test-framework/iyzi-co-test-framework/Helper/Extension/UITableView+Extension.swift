//
//  UITableView+Extension.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 26.01.2021.
//

import UIKit

extension UITableView {
    func registerCells<T: UITableViewCell>(types: [T.Type], identifier: String? = nil) {
        types.forEach { type in
            let cellId = String(describing: type)
            register(UINib(nibName: cellId, bundle: Bundle(for: T.self)), forCellReuseIdentifier: identifier ?? cellId)
        }
    }
    
    func registerCell<T: UITableViewCell>(type: T.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: Bundle(for: T.self)), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
    func addButtonToFooterView(title: String, completion: @escaping () -> Void) {
        //let contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let button = IyzicoButton(buttonType: .primaryLvl1(state: .normal), title: title, cornerRadius: 25)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 80))
        view.addSubview(button)
        addConst(view: button, containerView: view)
        
        button.didTappedButton = {
            completion()
        }
        
        self.tableFooterView = view
        self.tableFooterView?.isHidden = false
    }
    
    func removeButtonFromFooterView() {
        self.tableFooterView?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        self.tableFooterView?.isHidden = true
    }
    
    func addConst(view: UIView, containerView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            view.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 32),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 0),
            view.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
