//
//  TitleCell.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 9.12.2020.
//

import UIKit

class TitleCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell() {
        titleLabel.font = .markProMedium14
    }
    
    func setCell(title:String?) {
        titleLabel.text = title ?? ""
    }
}
