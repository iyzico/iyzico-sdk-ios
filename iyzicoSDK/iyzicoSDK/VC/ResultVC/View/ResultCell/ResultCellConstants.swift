//
//  ResultVCConstants.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 27.01.2021.
//

import UIKit

class ResultCellConstants {
    static let shared = ResultCellConstants()
    private typealias constants = StringConstant.ResultVC
    
    var headerImage: UIImage?
    var titleLabel = ""
    var subTitleLabel = ""
    var descriptionLabel = ""
    var balanceTitleLabel = ""
    var balanceValueLabel = ""
    var headerImageViewHeightConstraint: CGFloat = 31
    var lottieType: LottieFiles = .success
    var seeBankInformationButton = constants.seeBankInformation
    var returnToAppButton = constants.returnToApp
    var tryAgain = constants.tryAgain
    var titleLabelVisibility = true
    var descriptionLabelVisibility = true
    var balanceContainerStackViewVisibility = true
    var supportDescriptionLabel = constants.supportDescription
    var footerContainerStackViewVisibility: Bool = true
    var appStoreImageViewVisibility: Bool = true
    var supportDescriptionLabelVisibility: Bool = true
    var seeBankInformationButtonVisibility: Bool = true
    var returnToAppButtonVisibility: Bool = true
    
    func getType(vcType: ResultVCTypes) -> Self {
        switch vcType {
        case .cashoutSuccess:
            setUI(headerImage: Asset.resultSuccess.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.deliverySucceced,
                  descriptionLabel: constants.willDeliverToYourAccount,
                  lottieType: .success,
                  balanceContainerStackViewVisibility: false,
                  seeBankInformationButtonVisibility: false)
        case .refundSuccess:
            setUI(headerImage: Asset.resultSuccess.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.refundRequestTaken,
                  descriptionLabel: constants.willDeliverToYourAccount,
                  balanceTitleLabel: constants.willRefundAmount,
                  balanceValueLabel: 113.40.addTLWithAlignment(alignment: .left),
                  headerImageViewHeightConstraint: 31,
                  lottieType: .success,
                  seeBankInformationButtonVisibility: false)
        case .topUpSuccess:
            setUI(headerImage: Asset.resultSuccess.image,
                  titleLabel: 113.40.addTLWithAlignment(alignment: .left),
                  subTitleLabel: constants.loadedToAccount,
                  descriptionLabel: constants.redirectTo,
                  lottieType: .success,
                  balanceContainerStackViewVisibility: false,
                  seeBankInformationButtonVisibility: false)
        case .settlementSuccess:
            #warning("price")
            setUI(headerImage: Asset.resultSuccess.image,
                  subTitleLabel: constants.deliveryRequestTaken,
                  descriptionLabel: constants.willDeliverToYourAccount,
                  balanceTitleLabel: constants.willDeliverAmountToYourAccount,
                  balanceValueLabel: SDKManager.walletPrice?.addTLWithAlignment(alignment: .left) ?? "",
                  headerImageViewHeightConstraint: 31,
                  lottieType: .success,
                  seeBankInformationButtonVisibility: false)
        case .transferDetailSuccess:
            setUI(headerImage: Asset.resultInfo.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.payRequestTaken,
                  descriptionLabel: constants.orderWillApprove,
                  lottieType: .info,
                  balanceContainerStackViewVisibility: false,
                  appStoreImageViewVisibility: false,
                  supportDescriptionLabelVisibility: false)
//        case .successWithProducts:
//            setUI(headerImage: UIImage(named: Asset.resultSuccess.name),
//                  titleLabel: constants.iyzicoTrust,
//                  subTitleLabel: "ödemeniz başarıyla alındı.",
//                  descriptionLabel: constants.redirectTo,
//                  headerImageViewHeightConstraint: 31,
//                  balanceContainerStackViewVisibility: false,
//                  footerContainerStackViewVisibility: false)
        case .threeDSecure:
            setUI(headerImage: Asset.result3d.image,
                  subTitleLabel: constants.threeDTitle,
                  descriptionLabel: constants.waitingRedirectToThreeD,
                  lottieType: .info,
                  titleLabelVisibility: false,
                  balanceContainerStackViewVisibility: false,
                  footerContainerStackViewVisibility: false,
                  seeBankInformationButtonVisibility: false,
                  returnToAppButtonVisibility: false)
        case .success, .successWithProducts:
            setUI(headerImage: Asset.resultSuccess.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.payTaken,
                  descriptionLabel: constants.redirectingToApp,
                  lottieType: .success,
                  balanceContainerStackViewVisibility: false,
                  appStoreImageViewVisibility: false,
                  supportDescriptionLabelVisibility: false,
                  seeBankInformationButtonVisibility: false)
        case .error:
            setUI(headerImage: Asset.resultFail.image,
                  subTitleLabel: constants.payNotCompleted,
                  lottieType: .fail,
                  titleLabelVisibility: false,
                  descriptionLabelVisibility: false,
                  balanceContainerStackViewVisibility: false,
                  appStoreImageViewVisibility: false,
                  supportDescriptionLabelVisibility: false,
                  seeBankInformationButtonVisibility: true,
                  returnToAppButtonVisibility: true)
        case .topUpWaiting:
            setUI(headerImage: Asset.resultWaiting.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.topUpWaitingTitle,
                  descriptionLabel: constants.willDeliverToYourAccount,
                  lottieType: .info,
                  descriptionLabelVisibility: false,
                  balanceContainerStackViewVisibility: false,
                  seeBankInformationButtonVisibility: false)
        case .cashoutWaiting:
            setUI(headerImage: Asset.resultWaiting.image,
                  titleLabel: constants.iyzicoTrust,
                  subTitleLabel: constants.cashoutWaitingTitle,
                  descriptionLabel: constants.willDeliverToYourAccount,
                  lottieType: .info,
                  balanceContainerStackViewVisibility: false,
                  seeBankInformationButtonVisibility: false)
        }
        
        return self
    }
    
    private func setUI(headerImage: UIImage?,
                       titleLabel: String = "",
                       subTitleLabel: String = "",
                       descriptionLabel: String = "",
                       balanceTitleLabel: String = "",
                       balanceValueLabel: String = "",
                       headerImageViewHeightConstraint: CGFloat = 31,
                       lottieType: LottieFiles = .success,
                       titleLabelVisibility: Bool = true,
                       descriptionLabelVisibility: Bool = true,
                       balanceContainerStackViewVisibility: Bool = true,
                       footerContainerStackViewVisibility: Bool = true,
                       appStoreImageViewVisibility: Bool = true,
                       supportDescriptionLabelVisibility: Bool = true,
                       seeBankInformationButtonVisibility: Bool = true,
                       returnToAppButtonVisibility: Bool = true) {
        self.headerImage = headerImage
        self.titleLabel = titleLabel
        self.subTitleLabel = subTitleLabel
        self.descriptionLabel = descriptionLabel
        self.balanceTitleLabel = balanceTitleLabel
        self.balanceValueLabel = balanceValueLabel
        self.headerImageViewHeightConstraint = headerImageViewHeightConstraint
        self.lottieType = lottieType
        self.titleLabelVisibility = titleLabelVisibility
        self.descriptionLabelVisibility = descriptionLabelVisibility
        self.balanceContainerStackViewVisibility = balanceContainerStackViewVisibility
        self.footerContainerStackViewVisibility = footerContainerStackViewVisibility
        self.appStoreImageViewVisibility = appStoreImageViewVisibility
        self.supportDescriptionLabelVisibility = supportDescriptionLabelVisibility
        self.seeBankInformationButtonVisibility = seeBankInformationButtonVisibility
        self.returnToAppButtonVisibility = returnToAppButtonVisibility
    }
}
