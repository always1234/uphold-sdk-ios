import XCTest
import ObjectMapper
import PromiseKit
@testable import UpholdSdk
@testable import SwiftClient

/// Reserve integration tests.
class ReserveTest: UpholdTestCase {

    func testGetLedgerShouldReturnTheArrayOfDeposits() {
        let testExpectation = expectation(description: "Reserve test: get ledger.")

        let json: String = "[{" +
            "\"type\": \"foo\"," +
            "\"out\": {" +
                "\"amount\": \"foobar\"," +
                "\"currency\": \"fuz\"" +
            "}," +
            "\"in\": {" +
                "\"amount\": \"foobiz\"," +
                "\"currency\": \"fiz\"" +
            "}," +
            "\"createdAt\": \"2015-04-20T14:57:12.398Z\"" +
        "},{" +
            "\"type\": \"bar\"," +
            "\"out\": {" +
                "\"amount\": \"foobiz\"," +
                "\"currency\": \"buz\"" +
            "}," +
            "\"in\": {" +
                "\"amount\": \"foobar\"," +
                "\"currency\": \"biz\"" +
            "}," +
            "\"TransactionId\": \"foobar\"," +
            "\"createdAt\": \"2015-04-21T14:57:12.398Z\"" +
        "}]"
        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: json)
        let paginator: Paginator<Deposit> = reserve.getLedger()

        paginator.elements.then(execute: { (deposits: [Deposit]) -> Void in
            let mockRestAdapter: MockRestAdapter = (reserve.adapter as? MockRestAdapter)!

            XCTAssertEqual(mockRestAdapter.headers!.count, 1, "Failed: Wrong number of headers.")
            XCTAssertEqual(mockRestAdapter.headers!["Range"], "items=0-49", "Failed: Wrong number of headers.")
            XCTAssertEqual(deposits[0].createdAt, "2015-04-20T14:57:12.398Z", "Failed: DepositMovement in currency didn't match.")
            XCTAssertEqual(deposits[0].input!.amount, "foobiz", "Failed: DepositMovement in amount didn't match.")
            XCTAssertEqual(deposits[0].input!.currency, "fiz", "Failed: DepositMovement in currency didn't match.")
            XCTAssertEqual(deposits[0].output!.amount, "foobar", "Failed: DepositMovement out amount didn't match.")
            XCTAssertEqual(deposits[0].output!.currency, "fuz", "Failed: DepositMovement out currency didn't match.")
            XCTAssertEqual(deposits[0].type, "foo", "Failed: Deposit type didn't match.")
            XCTAssertEqual(deposits[1].createdAt, "2015-04-21T14:57:12.398Z", "Failed: CreatedAt didn't match.")
            XCTAssertEqual(deposits[1].input!.amount, "foobar", "Failed: DepositMovement in amount didn't match.")
            XCTAssertEqual(deposits[1].input!.currency, "biz", "Failed: DepositMovement in currency didn't match.")
            XCTAssertEqual(deposits[1].output!.amount, "foobiz", "Failed: DepositMovement out amount didn't match.")
            XCTAssertEqual(deposits[1].output!.currency, "buz", "Failed: DepositMovement out currency didn't match.")
            XCTAssertEqual(deposits[1].transactionId, "foobar", "Failed: TransactionId didn't match.")
            XCTAssertEqual(deposits[1].type, "bar", "Failed: Deposit type didn't match.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get ledger error.")
        })

        wait()
    }

    func testGetLedgerShouldReturnThePaginatorCount() {
        let testExpectation = expectation(description: "Reserve test: get ledger.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: "[{ \"id\": \"foobar\" }, { \"id\": \"foobiz\" }]", headers: ["content-range": "0-2/60"])

        reserve.getLedger().count().then(execute: { (count: Int) -> Void in
            XCTAssertEqual(count, 60, "Failed: Wrong paginator count.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get ledger error.")
        })

        wait()
    }

    func testGetLedgerShouldReturnThePaginatorHasNext() {
        let testExpectation = expectation(description: "Reserve test: get ledger.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: "[{ \"id\": \"foobar\" }, { \"id\": \"foobiz\" }]", headers: ["content-range": "0-49/51"])

        reserve.getLedger().hasNext().then(execute: { (bool: Bool) -> Void in
            XCTAssertTrue(bool, "Failed: Wrong paginator hasNext value.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get ledger error.")
        })

        wait()
    }

    func testGetLedgerShouldReturnThePaginatorNextPage() {
        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: "[{ \"id\": \"foobar\" }, { \"id\": \"foobiz\" }]")
        let paginator: Paginator<Deposit> = reserve.getLedger()

        paginator.getNext().catch(execute: { (_: Error) in
            XCTFail("Reserve test: get ledger error.")
        })

        let firstRequestHeaders = (reserve.adapter as? MockRestAdapter)!.headers

        paginator.getNext().catch(execute: { (_: Error) in
            XCTFail("Reserve test: get ledger error.")
        })

        let secondRequestHeaders = (reserve.adapter as? MockRestAdapter)!.headers

        XCTAssertEqual(firstRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(firstRequestHeaders!["Range"], "items=50-99", "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!["Range"], "items=100-149", "Failed: Wrong number of headers.")
    }

    func testGetStatisticsShouldReturnTheListWithReserveStatistics() {
        let testExpectation = expectation(description: "Reserve test.")

        let json: String = "[{" +
            "\"currency\": \"FOO\"," +
            "\"values\": [{" +
                "\"assets\": \"foobar\"," +
                "\"currency\": \"foo\"," +
                "\"liabilities\": \"bar\"," +
                "\"rate\": \"biz\"" +
            "}]," +
            "\"totals\": {" +
                "\"commissions\": \"foo\"," +
                "\"transactions\": \"bar\"," +
                "\"assets\": \"foobar\"," +
                "\"liabilities\": \"foobiz\"" +
            "}" +
        "}, {" +
            "\"currency\": \"BAR\"," +
            "\"values\": [{" +
                "\"assets\": \"foobiz\"," +
                "\"currency\": \"biz\"," +
                "\"liabilities\": \"buz\"," +
                "\"rate\": \"foo\"" +
            "}]," +
            "\"totals\": {" +
                "\"commissions\": \"fiz\"," +
                "\"transactions\": \"biz\"," +
                "\"assets\": \"fuz\"," +
                "\"liabilities\": \"buz\"" +
            "}" +
        "}]"
        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: json)

        reserve.getStatistics().then { (statistics: [ReserveStatistics]) -> Void in
            XCTAssertEqual(statistics[0].currency, "FOO", "Failed: Currency didn't match.")
            XCTAssertEqual(statistics[0].totals!.assets, "foobar", "Failed: Totals assets didn't match.")
            XCTAssertEqual(statistics[0].totals!.commissions, "foo", "Failed: Totals comissions didn't match.")
            XCTAssertEqual(statistics[0].totals!.transactions, "bar", "Failed: Totals transactions didn't match.")
            XCTAssertEqual(statistics[0].totals!.liabilities, "foobiz", "Failed: Totals liabilities didn't match.")
            XCTAssertEqual(statistics[0].values!.first!.assets, "foobar", "Failed: Values assests didn't match.")
            XCTAssertEqual(statistics[0].values!.first!.currency, "foo", "Failed: Values currency didn't match.")
            XCTAssertEqual(statistics[0].values!.first!.liabilities, "bar", "Failed: Values liabilities didn't match.")
            XCTAssertEqual(statistics[0].values!.first!.rate, "biz", "Failed: Values rate didn't match.")
            XCTAssertEqual(statistics[1].currency, "BAR", "Failed: Currency didn't match.")
            XCTAssertEqual(statistics[1].totals!.assets, "fuz", "Failed: Totals assets didn't match.")
            XCTAssertEqual(statistics[1].totals!.commissions, "fiz", "Failed: Totals comissions didn't match.")
            XCTAssertEqual(statistics[1].totals!.transactions, "biz", "Failed: Totals transactions didn't match.")
            XCTAssertEqual(statistics[1].totals!.liabilities, "buz", "Failed: Totals liabilities didn't match.")
            XCTAssertEqual(statistics[1].values!.first!.assets, "foobiz", "Failed: Values assests didn't match.")
            XCTAssertEqual(statistics[1].values!.first!.currency, "biz", "Failed: Values currency didn't match.")
            XCTAssertEqual(statistics[1].values!.first!.liabilities, "buz", "Failed: Values liabilities didn't match.")
            XCTAssertEqual(statistics[1].values!.first!.rate, "foo", "Failed: Values rate didn't match.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Reserve test error.")
        })

        wait()
    }

    func testGetTransactionsByIdShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Reserve test: get transaction by id.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadTransaction(fields: ["transactionId": "foobar"]))!)

        reserve.getTransactionById(transactionId: "foobar").then { (transaction: Transaction) -> Void in
            XCTAssertEqual(transaction.id, "foobar", "Failed: TransactionId didn't match.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Reserve test: get transaction by id error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnTheArrayOfTransactions() {
        let testExpectation = expectation(description: "Reserve test: get transactions.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!)

        reserve.getTransactions().elements.then(execute: { (transactions: [Transaction]) -> Void in
            let mockRestAdapter: MockRestAdapter = (reserve.adapter as? MockRestAdapter)!

            XCTAssertEqual(mockRestAdapter.headers!.count, 1, "Failed: Wrong number of headers.")
            XCTAssertEqual(mockRestAdapter.headers!["Range"], "items=0-49", "Failed: Wrong number of headers.")
            XCTAssertEqual(transactions.count, 2, "Failed: Wrong number of transaction objects.")
            XCTAssertEqual(transactions[0].id, "foobar", "Failed: Wrong transaction object.")
            XCTAssertEqual(transactions[1].id, "foobiz", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get transaction error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorCount() {
        let testExpectation = expectation(description: "Reserve test: get transactions.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!, headers: ["content-range": "0-2/60"])

        reserve.getTransactions().count().then(execute: { (count: Int) -> Void in
            XCTAssertEqual(count, 60, "Failed: Wrong paginator count.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorHasNext() {
        let testExpectation = expectation(description: "Reserve test: get transactions.")

        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!, headers: ["content-range": "0-49/51"])

        reserve.getTransactions().hasNext().then(execute: { (bool: Bool) -> Void in
            XCTAssertTrue(bool, "Failed: Wrong paginator hasNext value.")

            testExpectation.fulfill()
        }).catch(execute: { (_: Error) in
            XCTFail("Reserve test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorNextPage() {
        let reserve = UpholdClient().getReserve()
        reserve.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!)
        let paginator: Paginator<Transaction> = reserve.getTransactions()

        paginator.getNext().catch(execute: { (_: Error) in
            XCTFail("Reserve test: get next transactions error.")
        })

        let firstRequestHeaders = (reserve.adapter as? MockRestAdapter)!.headers

        paginator.getNext().catch(execute: { (_: Error) in
            XCTFail("Reserve test: get next transactions error.")
        })

        let secondRequestHeaders = (reserve.adapter as? MockRestAdapter)!.headers

        XCTAssertEqual(firstRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(firstRequestHeaders!["Range"], "items=50-99", "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!["Range"], "items=100-149", "Failed: Wrong number of headers.")
    }

}
