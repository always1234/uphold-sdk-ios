import Foundation
import ObjectMapper
import PromiseKit
import UpholdSdk
@testable import SwiftClient

/// Uphold mock REST adapter.
public class MockRestAdapter: UpholdRestAdapter {

    /// The body to inject in the response.
    var body: String?

    /// The headers to inject in the response.
    var headers: [String: String]?

    /**
      Constructor.

      - parameter body: The body to mock the response.
      - parameter headers: The headers to mock the response.
    */
    public convenience init(body: String, headers: [String: String]) {
        self.init()

        self.body = body
        self.headers = headers
    }

    /**
      Constructor.

      - parameter body: The body to mock the response.
    */
    public convenience init(body: String) {
        self.init()

        self.body = body
    }

    /**
      Mock request builder method

      - parameter request: The HTTP request.

      - returns: The mock HTTP request.
    */
    public override func buildRequest(request: Request) -> MockRequest {
        if let _ = self.headers {
            _ = request.headers.map { (key, value) in self.headers!.updateValue(value, forKey: key)}
        } else {
            self.headers = request.headers
        }

        if let bearerToken = MockSessionManager.sharedInstance.getBearerToken() {
            if let mockAuthorizationHeader = Header.buildAuthorizationHeader(token: bearerToken)["authorization"] {
                _ = self.headers?.updateValue(mockAuthorizationHeader, forKey: "authorization")
            }
        }

        return MockRequest(body: self.body, code: 200, errorHandler: {(error: Error) -> Void in}, headers: self.headers!, method: request.method)
    }

    /**
      Mock response builder method.

      - parameter request: The HTTP request.

      - returns: The mock response.
     */
    public override func buildResponse<T: Mappable>(request: Request) -> Promise<T> {
        return super.buildResponse(request: request)
    }

    /**
      Mock response builder method.

      - parameter request: The HTTP request.

      - returns: The mock response.
     */
    public override func buildResponse<T: Mappable>(request: Request) -> Promise<[T]> {
        return super.buildResponse(request: request)
    }

}
