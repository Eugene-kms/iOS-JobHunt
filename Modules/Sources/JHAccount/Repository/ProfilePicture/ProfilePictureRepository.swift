import UIKit
import FirebaseStorage
import JHAuthentication

public protocol ProfilePictureRepository {
    func upload(_ image: UIImage) async throws
}

public class ProfilePictureRepositoryLive: ProfilePictureRepository {
    
    private let reference: StorageReference
    private let authService: AuthService
    private let companyProfileRepository: CompanyProfileRepository
    private let profilePictureSize = CGSize(width: 256, height: 256)
    private var uploadTask: StorageUploadTask?
    
    public init(authService: AuthService, companyProfileRepository: CompanyProfileRepository) {
        reference = Storage.storage().reference().child("ProfilePicture")
        self.authService = authService
        self.companyProfileRepository = companyProfileRepository
    }
    
    public func upload(_ image: UIImage) async throws {
        uploadTask?.cancel()
        
        guard let user = authService.company else {
            throw ProfilePictureRepositoryError.noAuthenticated
        }
        
        let companyReference = reference.child("\(user.uid).jpg")
        
        let resizedImage = image.resize(to: profilePictureSize)
        
        guard let data = resizedImage.jpegData(compressionQuality: 0.95) else {
            throw ProfilePictureRepositoryError.compressionFailed
        }
        
        let _ = try await uploadToFirebase(data, reference: companyReference)
        
        let url = try await companyReference.downloadURL()
        
        try companyProfileRepository.saveProfilePictureURL(url)
    }
    
    private func uploadToFirebase(_ data: Data, reference: StorageReference) async throws -> StorageMetadata {
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, Error>) in
            uploadTask = reference.putData(data) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let metadata {
                    continuation.resume(returning: metadata)
                }
            }
        }
    }
}
