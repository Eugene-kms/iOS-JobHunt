import UIKit

enum AccountSettingStrings: String {
    case notification = "Notification"
    case theme = "Theme"
    case helpCenter = "Help Center"
    case rateOurApp = "Rate Our App"
    case termOfService = "Term Of Service"
    case logOut = "Log Out"
}

extension AccountSettingCells.Model {
    static var notification: Self {
        Self(
            icon: UIImage(resource: .bell),
            title: AccountSettingStrings.notification.rawValue
        )
    }
    
    static var theme: Self {
        Self(
            icon: UIImage(resource: .moon),
            title: AccountSettingStrings.theme.rawValue
        )
    }
    
    static var helpCenter: Self {
        Self(
            icon: UIImage(resource: .messageQuestion),
            title: AccountSettingStrings.helpCenter.rawValue
        )
    }
    
    static var rateOurApp: Self {
        Self(
            icon: UIImage(resource: .star),
            title: AccountSettingStrings.rateOurApp.rawValue
        )
    }
    
    static var termOfService: Self {
        Self(
            icon: UIImage(resource: .notes),
            title: AccountSettingStrings.termOfService.rawValue
        )
    }
}

extension LogOutButtonCell.Model {
    static var logOut: Self {
        Self(
            icon: UIImage(resource: .logOut),
            title: AccountSettingStrings.logOut.rawValue
        )
    }
}
