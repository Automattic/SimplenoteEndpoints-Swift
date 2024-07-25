import Foundation


// MARK: - URLRequest Unit Test Helpers
//
extension URLRequest {
    func decodeHtmlBody<T: Decodable>() throws -> T? {
        guard let _ = httpBody else {
            return nil
        }

        return try httpBody.map {
            try JSONDecoder().decode(T.self, from: $0)
        }
    }
}
