//
//  Constant.swift
//  iyzi-co-test-framework
//
//  Created by Tolga İskender on 8.12.2020.
//

import Foundation
import UIKit

class Constant {
    
    static let shared = Constant()
    
    
    let padding = 16
    let borderWidth = 1
    let borderWidthSmall = 0.5
    let borderWidthBig = 2
    let duration = 0.3
    
    // MARK: - IyzicoCheckBox Default Data
    let defaultCheckBoxCornerRadius: CGFloat = 4
    let defaultRadioCornerRadius: CGFloat = 12
    let defaultAlpha = 0.8
    
    // MARK: - IyzicoCardView Default Data
    let defaultCornerRadius: CGFloat = 6
   
    
    // MARK: - IyzicoPopUpView Default Data
    let backgroundAlpha: CGFloat =  0.8
    let viewCornerRadius: CGFloat = 8
    let buttonCornerRadius: CGFloat = 28
    let buttonCornerRadius24: CGFloat = 24
   
    
    
    // MARK: - IyzicoDropDown Default Data
    let seperatorLeftPadding: CGFloat = 16
    let seperatorRightPadding: CGFloat = 16
    let cellHeight: CGFloat = 60
    let maxDataCount = 5
    let dropDownViewCornerRadius: CGFloat = 8
    let dropDownSearchCount = 2
    
    
    // MARK: - IyzicoTextArea Default Data
    let textAreaCornerRadius: CGFloat = 8
    let textAreaMaxCount = 200
    
    
    
    // MARK: - IyzicoTextInput Default Data
    let textInputCornerRadius: CGFloat = 8
    let amountInputCornerRadius: CGFloat = 15
    let textInputstackViewLeftConst: CGFloat = 16
    
    let textInputScaleX: CGFloat = 1
    let textInputScaleY: CGFloat = 1
    let textInputTitleLabelConstDefault: CGFloat = 21
    let textInputTitleLabelConstNew: CGFloat = 14
    let textInputDuration: Double = 0.2
  
    let textInputDateMaskMinCount: Int = 2
    let textInputDateMaskMaxCount: Int = 6
    let textInputDateMaskRangeCount: Int = 8
    
    let textInputLowercasedDelay: Double = 0.5
   
   
    //MARK: - IyzicoAmountView
    public struct IyzicoAmountView {
        static let decimalNumberLimit: Int = 3
        static let naturalNumberLimit: Int = 10
    }
    
    
    // MARK: - IyzicoButton Default Data
    let iyzicoButtonButtonTintAlpha: CGFloat = 0.5
    let iyzicoButtonbuttonImageViewWidthConst: CGFloat = 24
    let iyzicoButtonbuttonImageViewHeightConst: CGFloat = 24
    let iyzicoButtonbuttonImageViewleadingAnchor: CGFloat = 16
    let iyzicoButtonIndicatorleadingAnchor: CGFloat = 16
    public let iyzicoButtonCornerRadius: CGFloat = 24
    let iyzicoButtonCornerRadius28: CGFloat = 28
    let iyzicoButtonCornerRadius20: CGFloat = 20
    

   
    
   
    
    
    // MARK: - IyzicoNavBar Default Data
   
    var appTimerSecond: Int = 300
    let second: Int = 60
    let countDown: Int = 1
    let invalidateTimer: Int = 0
    let tryAgainButtonVisibilityByTime: Int = 10
    let oneMinute: Int = 60
    
    
    
    // MARK: - OTPVC Default Data
    
    let otpVCButtonImageRightInset: CGFloat = 4
    let otpVCButtonTitleLeftInset: CGFloat = 4
    let otpVCSecond: Int = 300
    
    // MARK: - AlertManager Default Data
    let AMDuration: Double = 0.5
    let AMCornerRadius: CGFloat = 8
    
    // MARK: - IyzicoHomeVC Default Data
    let iyzicoHomeVCHeaderViewHeight: CGFloat = 56
    
    // MARK: - EmailSupportVC Default Data
    let emailSupportVCButtonCornerRadius: CGFloat = 20
    let emailSupportVCButtonLeftEdgeInset: CGFloat = 56
    
    //MARK: - IyzicoMemberView
    struct IyzicoMemberViewConstants {
        static let cornerRadius: CGFloat = 16
    }
    
    //MARK: - BankDetailCell
    struct BankDetailCell {
        static let checkBoxShowTime: Int = 5
    }
}

