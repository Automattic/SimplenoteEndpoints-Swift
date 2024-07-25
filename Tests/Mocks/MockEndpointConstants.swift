import Foundation
@testable import SimplenoteEndpoints


// MARK: - MockEndpointConstants
//
struct MockEndpointConstants {
    
    static func setup() {
        if EndpointConstants.isInitialized {
            return
        }

        EndpointConstants.initializeSettings(engineBaseURL: "", platformName: "")
    }
}
