import Foundation
import FirebaseDatabase
import JHAuthentication

public struct CompanyProfile: Codable {
    public let companyName: String
    public let profilePictureURL: URL?
    public let location: String
    
    public init(companyName: String, location: String = "California, CA", profilePictureURL: URL?) {
        self.companyName = companyName
        self.profilePictureURL = profilePictureURL
        self.location = location
    }
}

public enum CompanyProfileRepositoryError: Error {
    case notAuthenticated
}

extension CompanyProfileRepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated!"
        }
    }
}

public protocol CompanyProfileRepository {
    
    var profile: CompanyProfile? { get }
    
    func saveCompanyProfile(_ companyProfile: CompanyProfile) throws
    func fetchCompanyProfile() async throws -> CompanyProfile
    func saveProfilePictureURL(_ url: URL) throws
}

public class CompanyProfileRepositoryLive: CompanyProfileRepository {
    
    private let reference: DatabaseReference
    private let authService: AuthService
    
    public var profile: CompanyProfile?
    
    public init(authService: AuthService = AuthServiceLive()) {
        reference = Database.database().reference()
        self.authService = authService
    }
    
    public func saveCompanyProfile(_ companyProfile: CompanyProfile) throws {
        guard let company = authService.company else {
            throw CompanyProfileRepositoryError.notAuthenticated
        }
        
        reference.child("Companies").child(company.uid).setValue(
            [
                "CompanyName": companyProfile.companyName
            ]
        )
    }
    
    public func fetchCompanyProfile() async throws -> CompanyProfile {
        guard let company = authService.company else {
            throw CompanyProfileRepositoryError.notAuthenticated
        }
        
        let snapshot = try await reference.child("Companies").child(company.uid).getData()
        let profile = try snapshot.data(as: CompanyProfile.self)
        
        self.profile = profile
        
        return profile
    }
    
    public func saveProfilePictureURL(_ url: URL) throws {
        guard let company = authService.company else {
            throw CompanyProfileRepositoryError.notAuthenticated
        }
        
        reference.child("Companies").child(company.uid).updateChildValues(["ProfilePictureURL": url.absoluteString])
    }
}
