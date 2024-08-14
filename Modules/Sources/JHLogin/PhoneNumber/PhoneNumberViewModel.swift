import Foundation
import JHAuthentication
import Swinject

public final class PhoneNumberViewModel {
    
    let container: Container
    var authService: AuthService { container.resolve(AuthService.self)! }
        
    public init(container: Container) {
        self.container = container
    }
    
    public func requestOTP(with phoneNumber: String) async throws {
        try await authService.requestOTP(forPhoneNumber: phoneNumber)
    }
}
