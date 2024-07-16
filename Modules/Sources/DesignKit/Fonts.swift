import UIKit

public enum Fonts: String {
    case urbanistBold = "Urbanist-Bold"
    case urbanistMedium = "Urbanist-Medium"
}

public extension UIFont {
    
    static var title: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 28)!
    }
    
    static var subtitle: UIFont {
        UIFont(name: Fonts.urbanistMedium.rawValue, size: 16)!
    }
    
    static var textField: UIFont {
        UIFont(name: Fonts.urbanistMedium.rawValue, size: 16)!
    }
    
    static var button: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 16)!
    }
    
    static var otp: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 24)!
    }
}
