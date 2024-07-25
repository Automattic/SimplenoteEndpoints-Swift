import Foundation


// MARK: - EndpointConstants
//
struct EndpointConstants {
    
    private static var shared: EndpointConstants!
    let engineBaseURL: NSString
    let platformName: String
    

    /// Initializes the Endpoint Constants
    ///
    public static func initializeSettings(engineBaseURL: String, platformName: String) {
        assert(shared == nil, "Already initialized!")
        shared = EndpointConstants(engineBaseURL: engineBaseURL as NSString, platformName: platformName)
    }
}


// MARK: - Convenience Properties
//
extension EndpointConstants {

    static var platformName: String {
        shared.platformName
    }
    
    static var loginRequestURL: String {
        shared.engineBaseURL.appendingPathComponent("/account/request-login")
    }
    static var loginCompletionURL: String {
        shared.engineBaseURL.appendingPathComponent("/account/complete-login")
    }
    
    static var simplenoteVerificationURL: String {
        shared.engineBaseURL.appendingPathComponent("/account/verify-email/")
    }

    static var simplenoteRequestSignupURL: String {
        shared.engineBaseURL.appendingPathComponent("/account/request-signup")
    }
    
    static var accountDeletionURL: String {
        shared.engineBaseURL.appendingPathComponent("/account/request-delete/")
    }
}
