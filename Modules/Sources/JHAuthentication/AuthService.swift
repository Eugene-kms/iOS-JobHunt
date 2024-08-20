import FirebaseAuth

public enum AuthError: Error {
    case noVerificationId
}

enum CompanyDefaultKey: String {
    case authenticationID
}

public struct Company {
    public let uid: String
}

public protocol AuthService {
    
    var company: Company? { get }
    var isAuthenticated: Bool { get }
    
    func requestOTP(forPhoneNumber phoneNumber: String) async throws
    func authenticate(withOTP otp: String) async throws -> Company
    func logOut() throws
}

public class AuthServiceLive: AuthService {
    
    public var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    public var company: Company? {
        guard let company = Auth.auth().currentUser else { return nil }
        return Company(uid: company.uid)
    }
    
    public init() {}
    
    public func requestOTP(forPhoneNumber phoneNumber: String) async throws {
        
        let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        
        UserDefaults.standard.set(verificationID, forKey: CompanyDefaultKey.authenticationID.rawValue)
    }
    
    public func authenticate(withOTP otp: String) async throws -> Company {
        
        guard let verificationId = UserDefaults.standard.string(forKey: CompanyDefaultKey.authenticationID.rawValue) else { throw AuthError.noVerificationId }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: otp)
        
        let result = try await Auth.auth().signIn(with: credential)
        
        return Company(uid: result.user.uid)
    }
    
    public func logOut() throws {
        try Auth.auth().signOut()
    }
}
