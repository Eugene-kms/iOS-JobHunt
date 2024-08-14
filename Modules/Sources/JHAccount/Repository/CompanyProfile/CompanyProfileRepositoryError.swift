import Foundation

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
