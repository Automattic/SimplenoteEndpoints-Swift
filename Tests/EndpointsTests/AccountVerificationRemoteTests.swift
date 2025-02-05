import XCTest
@testable import SimplenoteEndpoints


// MARK: - AccountVerificationRemote Tests
//
class AccountVerificationRemoteTests: XCTestCase {
    private lazy var urlSession = MockURLSession()
    private lazy var remote = AccountRemote(urlSession: urlSession)
    
    func testSuccessWhenStatusCodeIs2xx() {
        for _ in 0..<5 {
            test(withStatusCode: Int.random(in: 200..<300), expectedResult: Result.success(nil))
        }
    }

    func testFailureWhenStatusCodeIs4xxOr5xx() {
        for _ in 0..<5 {
            let statusCode = Int.random(in: 400..<600)
            let expectedError = RemoteError(statusCode: statusCode, response: nil, networkError: nil)
            test(withStatusCode: statusCode, expectedResult: Result.failure(expectedError))
        }
    }

    func testFailureWhenNoResponse() {
        let expectedError = RemoteError(statusCode: .zero, response: nil, networkError: nil)
        test(withStatusCode: nil, expectedResult: Result.failure(expectedError))
    }

    private func test(withStatusCode statusCode: Int?, expectedResult: Result<Data?, RemoteError>) {
        urlSession.data = (nil,
                           response(with: statusCode),
                           nil)

        let expectation = self.expectation(description: "Verify is called")

        remote.verify(email: UUID().uuidString) { (result) in
            XCTAssertEqual(result, expectedResult)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    private func response(with statusCode: Int?) -> HTTPURLResponse? {
        guard let statusCode = statusCode else {
            return nil
        }
        return HTTPURLResponse(url: URL(fileURLWithPath: "/"),
                               statusCode: statusCode,
                               httpVersion: nil,
                               headerFields: nil)
    }
}
