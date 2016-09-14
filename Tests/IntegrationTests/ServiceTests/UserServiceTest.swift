import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// UserService integration tests.
class UserServiceTest: XCTestCase {

    func testCreateContactShouldReturnTheRequest() {
        let request = UserService.createContact(contactRequest: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/contacts", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foo", "Failed: Wrong body.")
    }

    func testGetUserShouldReturnTheRequest() {
        let request = UserService.getUser()

        XCTAssertEqual(request.url, String(format: "%@/v0/me", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserBalancesShouldReturnTheRequest() {
        let request = UserService.getUserBalances()

        XCTAssertEqual(request.url, String(format: "%@/v0/me", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserContactsShouldReturnTheRequest() {
        let request = UserService.getUserContacts()

        XCTAssertEqual(request.url, String(format: "%@/v0/me/contacts", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserPhonesShouldReturnTheRequest() {
        let request = UserService.getUserPhones()

        XCTAssertEqual(request.url, String(format: "%@/v0/me/phones", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserTransactionsShouldReturnTheRequest() {
        let request = UserService.getUserTransactions(range: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/transactions", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
        XCTAssertNotNil(request.headers["Range"], "Failed: Range header doesn't exist.")
        XCTAssertEqual(request.headers["Range"]!, "foo", "Failed: Range value doesn't match.")
    }

    func testUpdateUserShouldReturnTheRequest() {
        let request = UserService.updateUser(updatefields: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "PATCH", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foo", "Failed: Wrong body.")
    }

}
