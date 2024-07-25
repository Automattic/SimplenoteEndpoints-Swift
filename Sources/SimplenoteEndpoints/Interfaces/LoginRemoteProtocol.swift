import Foundation


// MARK: - LoginRemoteProtocol
//
protocol LoginRemoteProtocol {
    func requestLoginEmail(email: String) async throws
    func requestLoginConfirmation(email: String, authCode: String) async throws -> LoginConfirmationResponse
}


extension LoginRemote: LoginRemoteProtocol { }
