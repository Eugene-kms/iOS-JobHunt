import UIKit

public extension UIColor {
    
    static var accent: UIColor {
        UIColor(resource: .accent)
    }
    
    static var title: UIColor {
        UIColor(resource: .contentPrimary)
    }
    
    static var subtitle: UIColor {
        UIColor(resource: .secondary)
    }
    
    static var textField: UIColor {
        UIColor(resource: .primary)
    }
    
    static var backgroundTextField: UIColor {
        UIColor(resource: .backgroundTextField)
    }
    
    static var backgroundTextFieldOTP: UIColor {
        UIColor(resource: .backgroundTextFieldOTP)
    }
}
