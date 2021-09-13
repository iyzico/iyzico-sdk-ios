//
//  BankDetailCell.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 22.12.2020.
//

import UIKit

class BankDetailCell: BaseTableViewCell {

    @IBOutlet weak var textField: IyzicoTextInput!
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setImage(Asset.paste.image, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(textInputType: IyzicoTextInputType, title: String, keyboardType: UIKeyboardType, placeholder: String = "") {
        
        textField.eftViewSetup(textInputType: textInputType, title: title, keyboardType: keyboardType, placeholder: placeholder)
    }
   
    //MARK: - Helper Methods
    private func startShowCheckBoxTimer() {
        copyButton.setImage(Asset.copiedCheckIcon.image, for: .normal)
        var seconds = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            seconds += 1
            if seconds == Constant.BankDetailCell.checkBoxShowTime {
                self?.copyButton.setImage(Asset.paste.image, for: .normal)
                timer.invalidate()
            }
        }
    }
}
//MARK:- Action
extension BankDetailCell {
    @IBAction func didTappedCopyButton(_ sender: Any) {
        UIPasteboard.general.string = textField.textField.text
        startShowCheckBoxTimer()
    }
}
