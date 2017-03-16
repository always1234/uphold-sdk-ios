import XCTest
import UpholdSdk
@testable import SwiftClient

/// UpholdClientErrorHandling integration tests.
class UpholdClientErrorHandlingTest: UpholdTestCase {

    var defaultError: ((Error) -> Void)!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        defaultError = {(error: Error) -> Void in
            XCTFail("Request should succeed.  Failed with error \(error).")

            self.expectation.fulfill()
        }
        expectation = expectation(description: "Status code")
    }

    func testHandleErrorShouldReturnApiLimitExceedError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? ApiLimitExceedError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 429, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Api limit exceed error"], "HTTP error 429 - You have exceeded Uphold's API rate limit of 300 requests. Current time window ends in 10 seconds.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 429, errorHandler: { (_: Error) -> Void in }, headers: ["x-ratelimit-limit": "300", "retry-after": "10"], method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnAuthenticationError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? AuthenticationError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 401, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Authentication error"], "HTTP error 401 - Unauthorized.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 401, errorHandler: { (_: Error) -> Void in }, headers: nil, method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnAuthenticationTimeoutError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? BadRequestError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 419, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Bad request error"], "HTTP error 419 - Requested range not satisfiable.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 419, errorHandler: { (_: Error) -> Void in }, headers: nil, method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnBadRequestError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? BadRequestError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 400, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Bad request error"], "HTTP error 400 - Bad request.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 400, errorHandler: { (_: Error) -> Void in }, headers: nil, method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnConfigurationMissingError() {
        let error = ConfigurationMissingError(message: "foo")

        XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
        XCTAssertEqual(error.info, ["Configuration missing error": "foo"], "Failed: Wrong error message.")

        self.expectation.fulfill()

        wait()
    }

    func testHandleErrorShouldReturnLogicError() {
        let error = LogicError(code: 200, message: "foo")

        XCTAssertEqual(error.code, 200, "Failed: Wrong response HTTP status code.")
        XCTAssertEqual(error.info, ["Logic error": "foo"], "Failed: Wrong error message.")

        self.expectation.fulfill()

        wait()
    }

    func testHandleErrorShouldReturnMalformedUrlError() {
        let error = MalformedUrlError(message: "foo")

        XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
        XCTAssertEqual(error.info, ["Malformed URL error": "foo"], "Failed: Wrong error message.")

        self.expectation.fulfill()

        wait()
    }

    func testHandleErrorShouldReturnNotFoundError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? NotFoundError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 404, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Not found error"], "HTTP error 404 - Object or route not found: http://foobar.com.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 404, errorHandler: { (_: Error) -> Void in }, headers: nil, method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnPreConditionFailError() {
        let done = { (response: Response) -> Void in
            let error = UpholdClientErrorHandling.handleError(response: response)

            XCTAssertNotNil(error as? BadRequestError, "Failed: Wrong class type.")
            XCTAssertEqual(error.code, 412, "Failed: Wrong HTTP error code.")
            XCTAssertEqual(error.info["Bad request error"], "HTTP error 412 - Precondition failed.", "Failed: Wrong message.")

            self.expectation.fulfill()
        }

        MockRequest(body: "body", code: 412, errorHandler: { (_: Error) -> Void in }, headers: nil, method: "foo").end(done: done, onError: self.defaultError)

        wait()
    }

    func testHandleErrorShouldReturnStateMatchError() {
        let error = StateMatchError(message: "foo")

        XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
        XCTAssertEqual(error.info, ["State match response error": "foo"], "Failed: Wrong error message.")

        self.expectation.fulfill()

        wait()
    }

    func testHandleErrorShouldReturnUnexpectedResponseError() {
        let error = UnexpectedResponseError(message: "foo")

        XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
        XCTAssertEqual(error.info, ["Unexpected response error": "foo"], "Failed: Wrong error message.")

        self.expectation.fulfill()

        wait()
    }

}
