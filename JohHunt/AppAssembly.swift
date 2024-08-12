import Foundation
import JHAccount
import JHAuthentication
import Swinject

class AppAssembly {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func asemble() {
        let authService = AuthServiceLive()
        let companyRepository = CompanyProfileRepositoryLive()
        let profilePictureRepository = ProfilePictureRepositoryLive(
            authService: authService,
            companyProfileRepository: companyRepository
        )
        
        container.register(AuthService.self) { container in
            return authService
        }
        
        container.register(CompanyProfileRepository.self) { container in
            return companyRepository
        }
        
        container.register(ProfilePictureRepository.self) { container in
            return profilePictureRepository
        }
    }
}

