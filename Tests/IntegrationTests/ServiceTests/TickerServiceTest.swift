import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// TickerService integration tests.
class TickerServiceTest: XCTestCase {

    func testGetAllTickersShouldReturnTheRequest() {
        let request = TickerService.getAllTickers()

        XCTAssertEqual(request.url, String(format: "%@/v0/ticker", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetAllTickersByCurrencyShouldReturnTheRequest() {
        let request = TickerService.getAllTickersByCurrency(currency: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/ticker/foo", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

}
