import Foundation
import JHAccount
import JHAuthentication
import JHLogin

class DIContainer: JHAccountDependencies, JHLoginDependencies {
    let authService: AuthService
    let companyRepository: CompanyProfileRepository
    let profilePictureRepository: ProfilePictureRepository
    
    init() {
        let authService = AuthServiceLive()
        let companyRepository = CompanyProfileRepositoryLive(authService: authService)
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            companyProfileRepository: companyRepository
        )
        self.authService = authService
        self.companyRepository = companyRepository
        self.profilePictureRepository = profilePictureRepository
    }
}
