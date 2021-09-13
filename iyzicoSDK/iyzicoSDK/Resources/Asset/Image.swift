// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let alertManagerLoading = ImageAsset(name: "alertManager-loading")
  internal static let iconMail = ImageAsset(name: "iconMail")
  internal static let iconPhone = ImageAsset(name: "iconPhone")
  internal static let divider = ImageAsset(name: "Divider")
  internal static let copiedCheckIcon = ImageAsset(name: "copiedCheckIcon")
  internal static let basicIcnSupport = ImageAsset(name: "basicIcnSupport")
  internal static let icnUnlocked = ImageAsset(name: "icn-unlocked")
  internal static let target = ImageAsset(name: "target")
  internal static let icnWallet = ImageAsset(name: "icn-wallet")
  internal static let icnCheck = ImageAsset(name: "icn-check")
  internal static let cards = ImageAsset(name: "cards")
  internal static let icnDownarrow = ImageAsset(name: "icn-downarrow")
  internal static let icnSearch = ImageAsset(name: "icn-search")
  internal static let icnUparrow = ImageAsset(name: "icn-uparrow")
  internal static let iconsBasicAccount = ImageAsset(name: "iconsBasicAccount")
  internal static let iconsBasicCards = ImageAsset(name: "iconsBasicCards")
  internal static let iconsBasicDownArrow = ImageAsset(name: "iconsBasicDownArrow")
  internal static let iconsBasicEFT = ImageAsset(name: "iconsBasicEFT")
  internal static let iconsBasicUpArrow = ImageAsset(name: "iconsBasicUpArrow")
  internal static let basicIcnInfo = ImageAsset(name: "basicIcnInfo")
  internal static let basicIcnInfored = ImageAsset(name: "basicIcnInfored")
  internal static let basicPlus = ImageAsset(name: "basicPlus")
  internal static let informativeCvc = ImageAsset(name: "informativeCvc")
  internal static let refresh2 = ImageAsset(name: "refresh2")
  internal static let card = ImageAsset(name: "Card")
  internal static let refund = ImageAsset(name: "Refund")
  internal static let iconBasicOneClick = ImageAsset(name: "iconBasicOneClick")
  internal static let iconBasicSupport = ImageAsset(name: "iconBasicSupport")
  internal static let iconcShopping = ImageAsset(name: "iconcShopping")
  internal static let navigationGrayLeft = ImageAsset(name: "navigation-grayLeft")
  internal static let navigationHourglass = ImageAsset(name: "navigation-hourglass")
  internal static let navigationLeft = ImageAsset(name: "navigation-left")
  internal static let navigationLogo = ImageAsset(name: "navigation-logo")
  internal static let basicClose = ImageAsset(name: "basicClose")
  internal static let basicIcnLogout = ImageAsset(name: "basicIcnLogout")
  internal static let bell = ImageAsset(name: "bell")
  internal static let news = ImageAsset(name: "news")
  internal static let nonLottieFail = ImageAsset(name: "nonLottieFail")
  internal static let calendar = ImageAsset(name: "calendar")
  internal static let error = ImageAsset(name: "error")
  internal static let eye = ImageAsset(name: "eye")
  internal static let paste = ImageAsset(name: "paste")
  internal static let edit = ImageAsset(name: "basicIcnEdit")
  internal static let iconInfo = ImageAsset(name: "icon-info")
  internal static let basicClock = ImageAsset(name: "basicClock")
  internal static let basicClockBlack = ImageAsset(name: "basicClockBlack")
  internal static let basicHourglassHighResIcon = ImageAsset(name: "basicHourglassHighResIcon")
  internal static let refreshBlue = ImageAsset(name: "refreshBlue")
  internal static let sendedIcon = ImageAsset(name: "sendedIcon")
  internal static let tr = ImageAsset(name: "TR")
  internal static let addEmail = ImageAsset(name: "addEmail")
  internal static let addNumber = ImageAsset(name: "addNumber")
  internal static let changeEmail = ImageAsset(name: "changeEmail")
  internal static let changeNumber = ImageAsset(name: "changeNumber")
  internal static let iyzico = ImageAsset(name: "iyzico")
  internal static let verifyNumber = ImageAsset(name: "verifyNumber")
  internal static let yourEmail = ImageAsset(name: "yourEmail")
  internal static let yourNumber = ImageAsset(name: "yourNumber")
  internal static let result3d = ImageAsset(name: "result3d")
  internal static let resultAppStore = ImageAsset(name: "resultAppStore")
  internal static let resultFail = ImageAsset(name: "resultFail")
  internal static let resultInfo = ImageAsset(name: "resultInfo")
  internal static let resultSuccess = ImageAsset(name: "resultSuccess")
  internal static let resultSuccessWithBackground = ImageAsset(name: "resultSuccessWithBackground")
  internal static let resultWaiting = ImageAsset(name: "resultWaiting")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
