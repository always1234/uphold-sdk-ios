import XCTest
import SwiftClient
import UpholdSdk

/// Header integration tests.
class HeaderTest: XCTestCase {

    func testBuildAuthorizationHeaderShouldReturnAuthorizationHeader() {
        XCTAssertEqual(Header.buildAuthorizationHeader(token: "foo")["authorization"], "Bearer foo", "Failed: Wrong value.")
    }

    func testBuildRangeHeaderShouldReturnRange() {
        XCTAssertEqual(Header.buildRangeHeader(start: 0, end: 5), "items=0-5", "Failed: Wrong value.")
    }

    func testGetDefaultHeadersShouldReturnHeaders() {
        let headers: [String: String] = Header.getDefaultHeaders()

        XCTAssertEqual(headers["user-agent"], String(format: "uphold-ios-sdk/%@ (%@)", GlobalConfigurations.UPHOLD_SDK_VERSION, GlobalConfigurations.SDK_GITHUB_URL), "Failed: Wrong header.")
    }

    func testGetRateLimitValueShouldReturnRateLimit() {
        XCTAssertEqual(Header.getRateLimitValue(headers: ["x-ratelimit-limit": "300"]), "300", "Failed: Wrong value.")
        XCTAssertNotEqual(Header.getRateLimitValue(headers: ["foobar": "300"]), "300", "Failed: Wrong value.")
    }

    func testGetSecondsUntilRateLimitResetShouldReturnResetTime() {
        XCTAssertEqual(Header.getSecondsUntilRateLimitReset(headers: ["retry-after": "10"]), "10", "Failed: Wrong value.")
        XCTAssertNotEqual(Header.getSecondsUntilRateLimitReset(headers: ["foobar": "10"]), "10", "Failed: Wrong value.")
    }

    func testGetTotalNumberOfResults() {
        XCTAssertEqual(Header.getTotalNumberOfResults(headers: ["content-range": "0-2/60"]), 60, "Failed: Wrong value.")
    }

}
