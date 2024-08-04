import UIKit

enum Tab {
    case home
    case jobs
    case messages
    case account
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home", image: .house, tag: 0)
        case .jobs:
            return UITabBarItem(title: "Jobs", image: .briefcase, tag: 0)
        case .messages:
            return UITabBarItem(title: "Messages", image: .chatCircle, tag: 0)
        case .account:
            return UITabBarItem(title: "Account", image: .user, tag: 0)
        }
    }
}
