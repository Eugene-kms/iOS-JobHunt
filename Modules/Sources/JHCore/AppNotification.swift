import Foundation

public enum AppNotification: String {
    case didLoginSuccessfully
    case didLogOut
}

public extension NotificationCenter {
    func post(_ appNotification: AppNotification) {
        NotificationCenter.default.post(Notification(name: Notification.Name(appNotification.rawValue)))
    }
}
