import Foundation
import UIKit

let globaltitleFont       = Font(.installed(.AvenirLTStdHeavy), size: .standard(.h1)).instance
let globalBtnFont         = Font(.installed(.AvenirLTStdBlack), size: .standard(.h2)).instance
let globalSubTitleFont    = Font(.installed(.AvenirLTStdMedium), size: .standard(.h4)).instance
let globalTextFieldFont   = Font(.installed(.AvenirLTStdHeavy), size: .standard(.h3)).instance
let smallDeviceTextFieldFont   = Font(.installed(.AvenirLTStdHeavy), size: .standard(.h5)).instance
let lblTittleFont             = Font(.installed(.AvenirLTStdHeavy), size: .standard(.h6)).instance
let forgetSubtittle       = Font(.installed(.AvenirLTStdMedium), size: .standard(.h4)).instance
let navigationTittleFont       = Font(.installed(.AvenirLTStdBlack), size: .standard(.h10)).instance


struct Font {
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    enum FontName: String {
        case AvenirLTStdOblique             = "Avenir-Oblique"
        case AvenirLTStdBookOblique         = "Avenir-BookOblique"
        case AvenirLTStdHeavy               = "Avenir-Heavy"
        case AvenirLTStdLightOblique        = "Avenir-LightOblique"
        case AvenirLTStdMediumOblique       = "Avenir-MediumOblique"
        case AvenirLTStdMedium              = "Avenir-Medium"
        case AvenirLTStdBlackOblique        = "Avenir-BlackOblique"
        case AvenirLTStdRoman               = "Avenir-Roman"
        case AvenirLTStdBook                = "Avenir-Book"
        case AvenirLTStdLight               = "Avenir-Light"
        case AvenirLTStdBlack               = "Avenir-Black"
    }
    enum StandardSize: Double {
        case h1 = 30.0
        case h2 = 22.0
        case h3 = 17.0
        case h4 = 16.0
        case h5 = 14.0
        case h6 = 12.0
        case h7 = 10.0
        case h8 = 15.0
        case h9 = 20.0
        case h10 = 24.0
        case h11 = 21.0
        case h12 = 35.0
    }
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}

class Utility {
	/// Logs all available fonts from iOS SDK and installed custom font
	class func logAllAvailableFonts() {
		for family in UIFont.familyNames {
			print("\(family)")
			for name in UIFont.fontNames(forFamilyName: family) {
				print("   \(name)")
			}
		}
	}
}
