import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// ReserveService integration tests.
class ReserveServiceTest: XCTestCase {

    func testGetLedgerShouldReturnTheRequest() {
        let request = ReserveService.getLedger(range: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/reserve/ledger", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
        XCTAssertNotNil(request.headers["Range"], "Failed: Range header doesn't exist.")
        XCTAssertEqual(request.headers["Range"]!, "foo", "Failed: Range value doesn't match.")
    }

    func testGetReserveTransactionByIdShouldReturnTheRequest() {
        let request = ReserveService.getReserveTransactionById(transactionId: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/reserve/transactions/foo", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetReserveTransactionsShouldReturnTheRequest() {
        let request = ReserveService.getReserveTransactions(range: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/reserve/transactions", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
        XCTAssertNotNil(request.headers["Range"], "Failed: Range header doesn't exist.")
        XCTAssertEqual(request.headers["Range"]!, "foo", "Failed: Range value doesn't match.")
    }

    func testGetStatisticsShouldReturnTheRequest() {
        let request = ReserveService.getStatistics()

        XCTAssertEqual(request.url, String(format: "%@/v0/reserve/statistics", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

}
