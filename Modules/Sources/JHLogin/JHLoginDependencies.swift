import Foundation
import JHAuthentication

public protocol JHLoginDependencies {
    var authService: AuthService { get }
}
