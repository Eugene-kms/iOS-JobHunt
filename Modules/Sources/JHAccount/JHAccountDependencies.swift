import Foundation
import JHAuthentication

public protocol JHAccountDependencies {
    var authService: AuthService { get }
    var companyRepository: CompanyProfileRepository { get }
    var profilePictureRepository: ProfilePictureRepository { get }
}
