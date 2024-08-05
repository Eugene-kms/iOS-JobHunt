import UIKit

public final class EditProfileViewModel {
    
    var selectedImage: UIImage?
    var companyName: String = ""
    var profilePictureURL: URL? = nil
    
    init(selectedImage: UIImage? = nil, companyName: String, profilePictureURL: URL? = nil) {
        self.selectedImage = selectedImage
        self.companyName = companyName
        self.profilePictureURL = profilePictureURL
    }
    
    func save() async throws {
        let profile = UserProfile(
            companyName: companyName,
            profilePictureURL: profilePictureURL
        )
        
    }
    
    func logOut() throws {
        NotificationCenter.default.
    }
}


