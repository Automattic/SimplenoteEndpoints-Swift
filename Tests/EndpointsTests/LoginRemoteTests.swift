import XCTest
@testable import SimplenoteEndpoints


// MARK: - LoginRemote Tests
//
class LoginRemoteTests: XCTestCase {
    private lazy var urlSession = MockURLSession()
    private lazy var loginRemote = LoginRemote(urlSession: urlSession)

    func testLoginRequestFailsWhenStatusCodeIs4xxOr5xx() async {
        let statusCode = Int.random(in: 400..<600)        
        mockSessionResponse(statusCode: statusCode)

        do {
            try await loginRemote.requestLoginEmail(email: "email@gmail.com")
        } catch {
            XCTAssertEqual(error as? RemoteError, RemoteError.init(statusCode: statusCode))
        }
    }

    func testLoginRequestSetsEmailToCorrectCase() async throws {
        mockSessionResponse(statusCode: 200)
        try await loginRemote.requestLoginEmail(email: "EMAIL@gmail.com")

        let expecation = "email@gmail.com"
        let body: Dictionary<String, String> = try XCTUnwrap(urlSession.lastRequest?.decodeHtmlBody())
        let decodedEmail = try XCTUnwrap(body["username"])

        XCTAssertEqual(expecation, decodedEmail)
    }
    
    func testLoginConfirmationEncodesKeyAndCodeFieldsAndGetsValidTokenInReturn() async throws {
        /// Setup: Response
        let expectedResponse = LoginConfirmationResponse(username: "username", syncToken: "syncToken")
        let encodedResponseBody = try JSONEncoder().encode(expectedResponse)
        
        /// Setup: Session
        mockSessionResponse(statusCode: 200, payload: encodedResponseBody)
        
        /// Run
        let decodedResponse = try await loginRemote.requestLoginConfirmation(email: "1234@567.com", authCode: "5678")

        /// Verify
        let body: Dictionary<String, String> = try XCTUnwrap(urlSession.lastRequest?.decodeHtmlBody())

        XCTAssertEqual(body["username"], "1234@567.com")
        XCTAssertEqual(body["auth_code"], "5678")
        
        XCTAssertEqual(expectedResponse, decodedResponse)
    }
}

private extension LoginRemoteTests {

    func mockSessionResponse(statusCode: Int, payload: Data = Data()) {
        let urlResponse = HTTPURLResponse(url: URL(fileURLWithPath: "/"),
                                          statusCode: statusCode,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        urlSession.data = (payload,
                           urlResponse,
                           nil)
        
    }
}
