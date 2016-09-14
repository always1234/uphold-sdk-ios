import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// UserCardService integration tests.
class UserCardServiceTest: XCTestCase {

    func testCancelTransactionShouldReturnTheRequest() {
        let request = UserCardService.cancelTransaction(cardId: "bar", transactionId: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions/foo/cancel", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
    }

    func testCreateAddressShouldReturnTheRequest() {
        let request = UserCardService.createCardAddress(cardId: "bar", addressRequest: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/addresses", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foo", "Failed: Wrong body.")
    }

    func testConfirmTransactionShouldReturnTheRequest() {
        let request = UserCardService.confirmTransaction(cardId: "bar", otp: nil, transactionId: "foo", transactionCommitRequest: "foobar")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions/foo/commit", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertNil(request.headers["X-Bitreserve-OTP"], "Failed: Wrong header.")
        XCTAssertEqual(request.data! as? String, "foobar", "Failed: Wrong body.")
    }

    func testConfirmTransactionWithOTPShouldReturnTheRequest() {
        let request = UserCardService.confirmTransaction(cardId: "bar", otp: "otp", transactionId: "foo", transactionCommitRequest: "foobar")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions/foo/commit", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.headers["X-Bitreserve-OTP"], "otp", "Failed: Wrong header.")
        XCTAssertEqual(request.data! as? String, "foobar", "Failed: Wrong body.")
    }

    func testCreateTransactionShouldReturnTheRequest() {
        let request = UserCardService.createTransaction(cardId: "bar", commit: false, transactionRequest: "foobar")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.query.count, 1, "Failed: Wrong number of query parameters.")
        XCTAssertEqual(request.query[0], "commit=false", "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foobar", "Failed: Wrong body.")
    }

    func testCreateTransactionWithCommitShouldReturnTheRequest() {
        let request = UserCardService.createTransaction(cardId: "bar", commit: true, transactionRequest: "foobar")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.query.count, 1, "Failed: Wrong number of query parameters.")
        XCTAssertEqual(request.query[0], "commit=true", "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foobar", "Failed: Wrong body.")
    }

    func testCreateUserCardShouldReturnTheRequest() {
        let request = UserCardService.createUserCard(cardRequest: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foo", "Failed: Wrong body.")
    }

    func testGetUserCardByIdShouldReturnTheRequest() {
        let request = UserCardService.getUserCardById(cardId: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/foo", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserCardsShouldReturnTheRequest() {
        let request = UserCardService.getUserCards()

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
    }

    func testGetUserCardTransactionsShouldReturnTheRequest() {
        let request = UserCardService.getUserCardTransactions(cardId: "bar", range: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar/transactions", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "GET", "Failed: Wrong method.")
        XCTAssertNotNil(request.headers["Range"], "Failed: Range header doesn't exist.")
        XCTAssertEqual(request.headers["Range"]!, "foo", "Failed: Range value doesn't match.")
    }

    func testUpdateCardShouldReturnTheRequest() {
        let request = UserCardService.updateCard(cardId: "bar", updateFields: "foo")

        XCTAssertEqual(request.url, String(format: "%@/v0/me/cards/bar", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.method, "PATCH", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "foo", "Failed: Wrong body.")
    }
}
