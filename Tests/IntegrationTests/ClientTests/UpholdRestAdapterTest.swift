import XCTest
import ObjectMapper
import PromiseKit
import UpholdSdk
@testable import SwiftClient

/// UpholdRestAdapter integration tests.
class UpholdRestAdapterTest: UpholdTestCase {

    func testBuildRequestShouldReturnRequest() {
        let mockRequest = MockRequest(body: nil, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)

        XCTAssertEqual(request.headers["user-agent"], String(format: "uphold-ios-sdk/%@ (%@)", GlobalConfigurations.UPHOLD_SDK_VERSION, GlobalConfigurations.SDK_GITHUB_URL), "Failed: Wrong headers.")
        XCTAssertEqual(request.method, "foo", "Failed: Wrong method.")
        XCTAssertNil(request.data, "Failed: Wrong body.")
    }

    func testBuildEmptyResponseShouldReturnBadRequestError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: nil, code: 400, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Response> = UpholdRestAdapter().buildEmptyResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let badRequestError = error as? BadRequestError else {
                XCTFail("Error should be BadRequestError.")

                return
            }

            XCTAssertEqual(badRequestError.code, 400, "Failed: Wrong response HTTP status code.")
            XCTAssertEqual(badRequestError.info["Bad request error"], "HTTP error 400 - Bad request.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testBuildEmptyResponseShouldReturnFulfilledPromise() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: nil, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Response> = UpholdRestAdapter().buildEmptyResponse(request: request)

        promise.then { (response: Response) -> () in
            XCTAssertEqual(response.basicStatus, Response.BasicResponseType.ok, "Failed: Wrong response basic status code.")
            XCTAssertNil(response.text, "Failed: Wrong response body.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Uphold REST adapter response test error.")
        })

        wait()
    }

    func testBuildEmptyResponseWithBodyShouldReturnFulfilledPromise() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: "", code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Response> = UpholdRestAdapter().buildEmptyResponse(request: request)

        promise.then { (response: Response) -> () in
            XCTAssertEqual(response.basicStatus, Response.BasicResponseType.ok, "Failed: Wrong response basic status code.")
            XCTAssertEqual(response.text, "", "Failed: Wrong response body.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Uphold REST adapter response test error.")
        })

        wait()
    }

    func testBuildEmptyResponseShouldReturnLogicError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: "foobar", code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Response> = UpholdRestAdapter().buildEmptyResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let logicError = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertEqual(logicError.info, ["Logic error": "Response body should be empty."], "Failed: Wrong error message.")
            XCTAssertNil(logicError.code, "Failed: Wrong response HTTP status code.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseShouldReturnBadRequestError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let json = "{" +
            "\"ask\":\"1.2\"," +
            "\"bid\":\"1\"," +
            "\"currency\":\"BTC\"," +
            "\"pair\":\"BTCBTC\"" +
        "}"
        let mockRequest = MockRequest(body: json, code: 400, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Rate> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let badRequestError = error as? BadRequestError else {
                XCTFail("Error should be BadRequestError.")

                return
            }

            XCTAssertEqual(badRequestError.code, 400, "Failed: Wrong response HTTP status code.")
            XCTAssertEqual(badRequestError.info["Bad request error"], "HTTP error 400 - Bad request.", "Failed: Wrong message.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseShouldReturnEmptyBodyLogicError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: nil, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Rate> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let logicError = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertEqual(logicError.info, ["Logic error": "Response body should not be empty."], "Failed: Wrong error message.")
            XCTAssertNil(logicError.code, "Failed: Wrong response HTTP status code.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseShouldReturnFailedMapLogicError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let json = "{[" +
            "\"ask\":\"1.2\"," +
            "\"bid\":\"1\"," +
            "\"currency\":\"BTC\"," +
            "\"pair\":\"BTCBTC\"" +
        "}"
        let mockRequest = MockRequest(body: json, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Rate> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let logicError = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertEqual(logicError.info, ["Logic error": "Failed to map the JSON object."], "Failed: Wrong error message.")
            XCTAssertNil(logicError.code, "Failed: Wrong response HTTP status code.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseShouldReturnFulfilledPromise() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let json = "{" +
            "\"ask\":\"1.2\"," +
            "\"bid\":\"1\"," +
            "\"currency\":\"BTC\"," +
            "\"pair\":\"BTCBTC\"" +
        "}"
        let mockRequest = MockRequest(body: json, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<Rate> = UpholdRestAdapter().buildResponse(request: request)

        promise.then { (rate: Rate) -> () in
            XCTAssertEqual(rate.ask, "1.2", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rate.bid, "1", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rate.currency, "BTC", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rate.pair, "BTCBTC", "Failed: Wrong response object attribute.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Uphold REST adapter response test error.")
        })

        wait()
    }

    func testBuildResponseArrayShouldReturnBadRequestError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let json = "[{\"ask\":\"1\"}, {\"ask\":\"440.99\"}]"
        let mockRequest = MockRequest(body: json, code: 400, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<[Rate]> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let badRequestError = error as? BadRequestError else {
                XCTFail("Error should be BadRequestError.")

                return
            }

            XCTAssertEqual(badRequestError.code, 400, "Failed: Wrong response HTTP status code.")
            XCTAssertEqual(badRequestError.info["Bad request error"], "HTTP error 400 - Bad request.", "Failed: Wrong message.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseArrayShouldReturnEmptyBodyLogicError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let mockRequest = MockRequest(body: nil, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<[Rate]> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let logicError = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertEqual(logicError.info, ["Logic error": "Response body should not be empty."], "Failed: Wrong error message.")
            XCTAssertNil(logicError.code, "Failed: Wrong response HTTP status code.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseArrayShouldReturnFailedMapLogicError() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let jsonRates = "[[{\"ask\":\"1\"}, {\"ask\":\"440.99\"}]"
        let mockRequest = MockRequest(body: jsonRates, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<[Rate]> = UpholdRestAdapter().buildResponse(request: request)

        promise.catch(execute: { (error: Error) in
            guard let logicError = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertEqual(logicError.info, ["Logic error": "Failed to map the JSON object."], "Failed: Wrong error message.")
            XCTAssertNil(logicError.code, "Failed: Wrong response HTTP status code.")

            testExpectation.fulfill()

            return
        })

        wait()
    }

    func testBuildResponseArrayShouldReturnFulfilledPromise() {
        let testExpectation = expectation(description: "Uphold REST adapter response test.")

        let jsonRates = "[{\"ask\":\"1\"}, {\"ask\":\"440.99\"}]"
        let mockRequest = MockRequest(body: jsonRates, code: 200, errorHandler: {(error: Error) -> Void in}, headers: nil, method: "foo")
        let request = UpholdRestAdapter().buildRequest(request: mockRequest)
        let promise: Promise<[Rate]> = UpholdRestAdapter().buildResponse(request: request)

        promise.then { (rates: [Rate]) -> () in
            XCTAssertEqual(rates.count, 2, "Failed: Wrong response object size.")
            XCTAssertEqual(rates[0].ask, "1", "Failed: Wrong response object attribute.")
            XCTAssertEqual(rates[1].ask, "440.99", "Failed: Wrong response object attribute.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Uphold REST adapter response test error.")
        })

        wait()
    }

}
