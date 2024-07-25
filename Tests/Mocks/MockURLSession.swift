import Foundation
@testable import SimplenoteEndpoints


// MARK: - MockURLSession
//
class MockURLSession: URLSessionProtocol {
    var data: (Data?, URLResponse?, Error?)?
    var lastRequest: URLRequest?

    /// URLSession has deprecated its initializers. We must implement our own!
    ///
    init() {
        // NO-OP
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastRequest = request
        return MockURLSessionDataTask {
            completionHandler(self.data?.0, self.data?.1, self.data?.2)
        }
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        lastRequest = request

        if let error = data?.2 {
            throw error
        }
        
        if let responseData = data?.0, let urlResponse = data?.1 {
            return (responseData, urlResponse)
        }
        
        throw RemoteError(statusCode: .zero)!
    }
}
