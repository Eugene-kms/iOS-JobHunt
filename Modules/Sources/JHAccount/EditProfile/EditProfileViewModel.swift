import UIKit
import Swinject

public final class EditProfileViewModel {
    
    var selectedImage: UIImage?
    var companyName: String = ""
    var profilePictureURL: URL? = nil
    
    let container: Container
    
    var companyRepository: CompanyProfileRepository { container.resolve(CompanyProfileRepository.self)! }
    var profilePictureRepository: ProfilePictureRepository { container.resolve(ProfilePictureRepository.self)! }
    
    init(container: Container) {
        self.container = container
        
        if let profile = companyRepository.profile {
            companyName = profile.companyName
            profilePictureURL = profile.profilePictureURL
        }
    }
    
    func save() async throws {
        let profile = CompanyProfile(
            companyName: companyName,
            profilePictureURL: profilePictureURL
        )
        try companyRepository.saveCompanyProfile(profile)
        
        if let selectedImage {
            try await profilePictureRepository.upload(selectedImage)
        }
    }
}


