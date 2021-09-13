//
//  InfoCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 22.12.2020.
//

import UIKit

class InfoCell: BaseTableViewCell {

    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.font = .markProMedium12
            infoLabel.textColor = .steel
            infoLabel.numberOfLines = .zero
        }
    }
    @IBOutlet weak var infoImageView: UIImageView! {
        didSet {
            infoImageView.image = Asset.basicIcnInfored.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(text: String) {
        infoLabel.text = text
    }
}
