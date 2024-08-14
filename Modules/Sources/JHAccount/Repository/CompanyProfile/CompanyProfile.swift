import Foundation

public struct CompanyProfile: Codable {
    public let companyName: String
    public let profilePictureURL: URL?
    
    public init(
        companyName: String,
        profilePictureURL: URL?
    ) {
        self.companyName = companyName
        self.profilePictureURL = profilePictureURL
    }
}
