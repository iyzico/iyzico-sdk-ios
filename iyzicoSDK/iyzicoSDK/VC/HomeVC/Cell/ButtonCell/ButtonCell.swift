//
//  ButtonCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 26.01.2021.
//

import UIKit

class ButtonCell: BaseTableViewCell {

    @IBOutlet weak var iyzicoButton: IyzicoButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(title: String) {
        iyzicoButton.primaryLvl1UI(state: .normal,title: title)
    }
}
