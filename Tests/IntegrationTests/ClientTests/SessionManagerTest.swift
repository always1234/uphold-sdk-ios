import XCTest
import KeychainSwift
@testable import SwiftClient
@testable import UpholdSdk

/// SessionManager integration tests.
class SessionManagerTest: UpholdTestCase {

    let keychain = KeychainSwift()

    func testGetBearerTokenShouldReturnNil() {
        _ = UpholdClient()

        XCTAssertNil(MockSessionManager.sharedInstance.getBearerToken(), "Failed: Wrong token.")
    }

    func testGetBearerTokenShouldReturnToken() {
        _ =  MockUpholdClient(bearerToken: "foo")

        guard let token = MockSessionManager.sharedInstance.getBearerToken() else {
            XCTFail("The bearer token should not be nil.")

            return
        }

        XCTAssertEqual(token, "foo", "Failed: Wrong token.")
    }

    func testInvalidateSessionShouldRemoveToken() {
        let client = MockUpholdClient(bearerToken: "foo")

        MockSessionManager.sharedInstance.invalidateSession()

        let request = client.mockToken.mockAdapter.buildRequest(request: TickerService.getAllTickers())

        XCTAssertNil(request.headers["authorization"], "Failed: Wrong header.")
        XCTAssertNil(MockSessionManager.sharedInstance.getBearerToken(), "Failed: Wrong token.")
    }

    func testUpholdClientShouldNotSetToken() {
        let client = UpholdClient()
        let request = client.token.adapter.buildRequest(request: TickerService.getAllTickers())

        XCTAssertNil(request.headers["authorization"], "Failed: Wrong header.")
    }

    func testUpholdClientWithTokenShouldSetToken() {
        let client = MockUpholdClient(bearerToken: "foo")
        let request = client.mockToken.mockAdapter.buildRequest(request: TickerService.getAllTickers())

        guard let header = request.headers["authorization"] else {
            XCTFail("Authorization header should not be nil.")

            return
        }

        XCTAssertEqual(header, "Bearer foo", "Failed: Wrong header.")
    }

    override func tearDown() {
        MockSessionManager.sharedInstance.invalidateSession()
    }

}
