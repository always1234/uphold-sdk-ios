import Foundation
import Mockingjay
import UpholdSdk
@testable import SwiftClient

/// MockRequest test util.
public class MockRequest: Request {

    /// The mock request HTTP status code.
    let code: Int

    /// The mock request URL.
    let mockURL: String = "http://foobar.com"

    /**
      Constructor.

      - parameter body: The request body.
      - parameter code: The HTTP status code.
      - parameter errorHandler: The errorHandler method.
      - parameter headers: The request headers.
      - parameter method: The HTTP method.
    */
    init(body: String?, code: Int, errorHandler: @escaping (Error) -> Void, headers: [String: String]?, method: String) {
        self.code = code

        super.init(method: method, url: mockURL, errorHandler: errorHandler)

        if let body = body {
            super.data = body
        }

        if let headers = headers {
            super.headers = headers
        }
    }

    /**
      Mock response builder method.

      - parameter request: The mock request.

      - returns: The mock response.
    */
    func builder(request: NSURLRequest) -> Mockingjay.Response {
        let response = HTTPURLResponse(url: request.url!, statusCode: self.code, httpVersion: nil, headerFields: self.headers)!

        guard let body = self.data, let data = body as? String else {
            return .success(response, nil)
        }

        return .success(response, data.data(using: .utf8))
    }

    /**
      Mock SwiftClient Request class end method.

      - parameter done: The completion handler.
      - parameter errorHandler: The error handler.
    */
    public override func end(done: @escaping (SwiftClient.Response) -> Void, onError errorHandler: ((Error) -> Void)? = nil) {
        let request = NSMutableURLRequest(url: URL(string: self.mockURL)!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval(self.timeout))
        request.httpMethod = self.method
        self.headers["content-type"] = "json"

        switch builder(request: request) {
            case let .success(response, data):
                return done(self.transformer(SwiftClient.Response(response: (response as? HTTPURLResponse)!, request: self, rawData: data)))

            default:
                return
        }
    }

}
