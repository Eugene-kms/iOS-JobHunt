import UIKit
import JHAuthentication
import Swinject

struct Header {
    let imageURL: URL?
    let company: String
    let location: String
}

public final class AccountViewModel {
    
    var header: Header
    
    var didUpdateHeader: (() -> ())?
    
    let container: Container
    
    var companyRepository: CompanyProfileRepository { container.resolve(CompanyProfileRepository.self)! }
    var authService: AuthService { container.resolve(AuthService.self)! }
    
    public init(container: Container) {
        self.container = container
        
        self.header = Header(
            imageURL: nil,
            company: "Company",
            location: "Location not specified"
        )
    }
    
    func fetchCompanyProfile() async {
        
        do {
            let profile = try await self.companyRepository.fetchCompanyProfile()
            
            await MainActor.run { [weak self] in
                self?.updateHeader(with: profile)
            }
        } catch {
            print(error)
        }
    }
    
    private func updateHeader(with companyProfile: CompanyProfile) {
        self.header = Header(
            imageURL: companyProfile.profilePictureURL,
            company: companyProfile.companyName,
            location: "California, CA"
        )
        
        didUpdateHeader?()
    }
    
    func logOut() throws {
        try authService.logOut()
        NotificationCenter.default.post(.didLogOut)
    }
}
