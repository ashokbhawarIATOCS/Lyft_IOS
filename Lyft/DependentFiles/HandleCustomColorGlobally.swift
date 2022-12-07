import Foundation
import UIKit

//skip button bg color - E8EAEE
// Usage Examples
//let shadowColor = Color.shadow.value

let btnBlueBackground           = Color.buttonYellowBackground.value
let btnGrayBackground           = Color.buttonGrayBackground.value
let borderColorandThemeColor    = Color.border.value
let borderErrorThemeColor       = Color.errorBorderColor.value
let headerTextColor             = Color.headerText.value
let headerTextYellowColor         = Color.buttonYellowBackground.value
let subTitleTextColor           = Color.headerText.value
let textFieldTextColor          = Color.textFieldText.value
let lightTextColor              = Color.lightTextColor.value  //  light btn text color
let lineViewColor               = Color.lineViewColor.value // Used for lineView
let placeholdercolor            = Color.placeHolder.value
let errorBorderColor            = Color.errorBorderColor.value // validation error msg color
let headerColor                 = Color.headerColor.value // Header text forget password color
let subTittleText               = Color.subTitleTextColor.value
let textPlaceHolder             = Color.textfieldPlaceHolder.value // place holder
let slideDisabelColor = Color.custom(hexString: "#ffffff", alpha: 0.30).value
let blackColor = Color.custom(hexString: "#000000", alpha: 1.0).value
let grayColorCode: UIColor = UIColor.gray
//let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
//let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value
//let bordercolor = Color.border.value
enum Color {
    
    case theme
    case border
    case buttonYellowBackground
    case buttonGrayBackground
    case shadow
    case darkBackground
    case lightBackground
    case intermidiateBackground
    case headerText
    case subTitleTextColor
    case lightTextColor
    case lineViewColor
    case intermidiateText
    case textFieldText
    case negation
    case placeHolder
    case errorBorderColor
    case headerColor
    case textfieldPlaceHolder
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            //Previous Theme color B79443
            instanceColor = UIColor(hexString: "#B79443")
        case .buttonYellowBackground:
             instanceColor = UIColor(hexString: "#B79443")
        case .buttonGrayBackground :
             instanceColor = UIColor(hexString: "#E8EAEE")
        case .theme:
            //Previous Theme color 3ACCE1
            //instanceColor = UIColor(hexString: "#3ACCE1")
            instanceColor = UIColor(hexString: "#5773FF")
        case .shadow:
            instanceColor = UIColor(hexString: "#ccccc")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#999966")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#cccc66")
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#cccc99")
        case .headerText:
            instanceColor = UIColor(hexString: "#5773FF")
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#999999")
        case .subTitleTextColor:
            instanceColor = UIColor(hexString: "#7C88A1")
        case .lightTextColor:
            instanceColor = UIColor(hexString: "#898F9C")
        case .textFieldText:
            instanceColor = UIColor(hexString: "#78849E")
        case .lineViewColor:
            instanceColor = UIColor(hexString: "#E8EAEE")
        case .negation:
            instanceColor = UIColor(hexString: "#ff3300")
        case .placeHolder:
            instanceColor = UIColor(hexString: "#C7C7CC")
        case .errorBorderColor:
            instanceColor = UIColor(hexString: "#E45471")
        case .headerColor:
            instanceColor = UIColor(hexString: "#454F63")
        case .textfieldPlaceHolder:
            instanceColor = UIColor(hexString: "#B3BAC9")
        
            
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
