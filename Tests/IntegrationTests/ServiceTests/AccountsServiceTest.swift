import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// Account service integration tests.
class AccountServiceTest: XCTestCase {

    func testGetUserAccountByIdShouldReturnTheRequest() {
        let request = AccountsService.getUserAccountById(accountId: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/accounts/foo", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserAccountsShouldReturnTheRequest() {
        let request = AccountsService.getUserAccounts()

        XCTAssertEqual(request.url, String(format: "%@/v0/me/accounts", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

}
