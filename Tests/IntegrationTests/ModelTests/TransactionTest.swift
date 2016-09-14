import XCTest
import ObjectMapper
import PromiseKit
@testable import UpholdSdk

/// Transaction integration tests.
class TransactionTest: UpholdTestCase {

    func testCancelShouldReturnUnexpectedResponseErrorIfAccountIdIsNil() {
        let testExpectation = expectation(description: "Transaction test: cancel transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"type\": \"deposit\"}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Origin accountId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnUnexpectedResponseErrorIfCardIdIsNil() {
        let testExpectation = expectation(description: "Transaction test: cancel transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\" }")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Origin cardId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnUnexpectedResponseErrorIfDestinationCardIdIsNil() {
        let testExpectation = expectation(description: "Transaction test: cancel transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"type\": \"deposit\", \"origin\": { \"AccountId\": \"fiz\"}}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Destination cardId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnUnexpectedResponseErrorIfTransactionIdIsNil() {
        let testExpectation = expectation(description: "Transaction test: cancel transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Transaction id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnUnexpectedResponseErrorIfStatusIsNil() {
        let testExpectation = expectation(description: "Transaction test: cancel transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"origin\": { \"CardId\": \"fiz\"} }")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Transaction status should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnLogicErrorIfStatusIsPending() {
        let testExpectation = expectation(description:"Transaction test: cancel transaction.")

        let transaction = Fixtures.loadTransaction(fields: ["transactionStatus": "pending"])
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Unable to cancel uncommited transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnLogicErrorIfStatusIsNotWaiting() {
        let testExpectation = expectation(description:"Transaction test: cancel transaction.")

        let transaction = Fixtures.loadTransaction(fields: ["transactionStatus": "foobar"])
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.cancel().catch(execute: { (error: Error) in
            guard let error = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "This transaction cannot be cancelled, because the current status is foobar.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCancelShouldReturnTheCanceledTransaction() {
        let testExpectation = expectation(description:"Transaction test: cancel transaction.")

        let transaction: Transaction = Fixtures.loadTransaction(fields: ["transactionId": "foobar", "transactionStatus": "waiting"])
        transaction.adapter = MockRestAdapter(body: Mapper().toJSONString(transaction)!)

        transaction.cancel().then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Transaction test: cancel transaction error.")
        })

        wait()
    }

    func testCommitShouldReturnTheTransaction() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Fixtures.loadTransaction(fields: ["transactionId": "foobar", "transactionStatus": "pending"])
        transaction.adapter = MockRestAdapter(body: Mapper().toJSONString(transaction)!)

        transaction.commit().then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Transaction test: commit transaction error.")
        })

        wait()
    }

    func testCommitWithOTPShouldReturnTheTransaction() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Fixtures.loadTransaction(fields: ["transactionId": "foobar", "transactionStatus": "pending"])
        transaction.adapter = MockRestAdapter(body: Mapper().toJSONString(transaction)!)

        transaction.commit(otp: "otp").then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCommitWithTransactionCommitRequestAndOTPShouldReturnTheTransaction() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Fixtures.loadTransaction(fields: ["transactionId": "foobar", "transactionStatus": "pending"])
        transaction.adapter = MockRestAdapter(body: Mapper().toJSONString(transaction)!)

        transaction.commit(otp: "otp", transactionCommit: TransactionCommitRequest(message: "foobar")).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCommitWithTransactionCommitRequestShouldReturnTheTransaction() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Fixtures.loadTransaction(fields: ["transactionId": "foobar", "transactionStatus": "pending"])
        transaction.adapter = MockRestAdapter(body: Mapper().toJSONString(transaction)!)

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCommitShouldReturnUnexpectedResponseErrorIfAccountIdIsNil() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"type\": \"deposit\"}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Origin accountId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCommitShouldReturnUnexpectedResponseErrorIfCardIdIsNil() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\" }")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Origin cardId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCommitShouldReturnUnexpectedResponseErrorIfDestinationCardIdIsNil() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"type\": \"deposit\", \"origin\": { \"AccountId\": \"fiz\"}}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Destination cardId is missing from this transaction.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCommitShouldReturnUnexpectedResponseErrorIfTransactionIdIsNil() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{}")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Transaction id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCommitShouldReturnUnexpectedResponseErrorIfStatusIsNil() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction: Transaction = Mapper().map(JSONString: "{ \"id\": \"foobar\", \"origin\": { \"CardId\": \"fiz\"} }")!
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Transaction status should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCommitShouldReturnLogicErrorIfStatusIsNotPending() {
        let testExpectation = expectation(description:"Transaction test: commit transaction.")

        let transaction = Fixtures.loadTransaction(fields: ["transactionStatus": "foobar"])
        transaction.adapter = MockRestAdapter(body: "foobar")

        transaction.commit(transactionCommit: TransactionCommitRequest(message: "foobar")).catch(execute: { (error: Error) in
            guard let error = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "This transaction cannot be committed, because the current status is foobar.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testTransactionMapperShouldReturnATransaction() {
        let json: String = "{" +
            "\"id\": \"foobar\"," +
            "\"type\": \"transfer\"," +
            "\"message\": \"foobar message\"," +
            "\"network\": \"qux\"," +
            "\"status\": \"pending\"," +
            "\"RefundedById\": \"foobiz\"," +
            "\"createdAt\": \"fuz\"," +
            "\"denomination\": {" +
                "\"amount\": \"0.1\"," +
                "\"currency\": \"BTC\"," +
                "\"pair\": \"BTCBTC\"," +
                "\"rate\": \"1.00\"" +
            "}," +
            "\"origin\": {" +
                "\"AccountId\": \"fizbuz\"," +
                "\"CardId\": \"fizbiz\"," +
                "\"amount\": \"0.1\"," +
                "\"base\": \"0.1\"," +
                "\"commission\": \"0.00\"," +
                "\"currency\": \"BTC\"," +
                "\"description\": \"Fuz Buz\"," +
                "\"fee\": \"0.00\"," +
                "\"rate\": \"1.00\"," +
                "\"sources\": [{" +
                    "\"id\": \"fizbuz\"," +
                    "\"amount\": \"2.00\"" +
                "}]," +
                "\"type\": \"card\"," +
                "\"username\": \"fuzbuz\"" +
            "}," +
            "\"destination\": {" +
                "\"AccountId\": \"fizbuz\"," +
                "\"CardId\": \"fuzbuz\"," +
                "\"amount\": \"0.1\"," +
                "\"base\": \"0.1\"," +
                "\"commission\": \"0.00\"," +
                "\"currency\": \"BTC\"," +
                "\"description\": \"foo@bar.com\"," +
                "\"fee\": \"0.00\"," +
                "\"rate\": \"1.00\"," +
                "\"type\": \"email\"," +
                "\"username\": \"fizbiz\"" +
            "}," +
            "\"params\": {" +
                "\"currency\": \"BTC\"," +
                "\"margin\": \"0.00\"," +
                "\"pair\": \"BTCBTC\"," +
                "\"progress\": \"foo\"," +
                "\"rate\": \"1.00\"," +
                "\"refunds\": \"fizbiz\"," +
                "\"ttl\": 30000," +
                "\"txid\": \"bar\"," +
                "\"type\": \"invite\"" +
            "}," +
            "\"normalized\": [{" +
                "\"amount\": \"14.00\"," +
                "\"commission\": \"1.20\"," +
                "\"currency\": \"BTC\"," +
                "\"fee\": \"1.00\"," +
                "\"rate\": \"2.345\"" +
            "}]," +
            "\"fees\": [{" +
                "\"type\": \"deposit\"," +
                "\"amount\": \"0.30\"," +
                "\"target\": \"origin\"," +
                "\"currency\": \"USD\"," +
                "\"percentage\": \"2.75\"" +
            "}]" +
        "}"
        let transaction = Mapper<Transaction>().map(JSONString: json)

        XCTAssertEqual(transaction!.id!, "foobar", "Failed: Transaction id didn't match.")
        XCTAssertEqual(transaction!.createdAt!, "fuz", "Failed: Transaction createdAt didn't match.")
        XCTAssertEqual(transaction!.denomination!.amount!, "0.1", "Failed: Transaction denomination amount didn't match.")
        XCTAssertEqual(transaction!.denomination!.currency!, "BTC", "Failed: Transaction denomination currency didn't match.")
        XCTAssertEqual(transaction!.denomination!.pair!, "BTCBTC", "Failed: Transaction denomination pair didn't match.")
        XCTAssertEqual(transaction!.denomination!.rate!, "1.00", "Failed: Transaction denomination rate didn't match.")
        XCTAssertEqual(transaction!.destination!.accountId!, "fizbuz", "Failed: Transaction destination accountId didn't match.")
        XCTAssertEqual(transaction!.destination!.cardId!, "fuzbuz", "Failed: Transaction destination cardId didn't match.")
        XCTAssertEqual(transaction!.destination!.amount!, "0.1", "Failed: Transaction destination amount didn't match.")
        XCTAssertEqual(transaction!.destination!.base!, "0.1", "Failed: Transaction destination base didn't match.")
        XCTAssertEqual(transaction!.destination!.commission!, "0.00", "Failed: Transaction destination commission didn't match.")
        XCTAssertEqual(transaction!.destination!.currency!, "BTC", "Failed: Transaction destination currency didn't match.")
        XCTAssertEqual(transaction!.destination!.description!, "foo@bar.com", "Failed: Transaction destination description didn't match.")
        XCTAssertEqual(transaction!.destination!.fee!, "0.00", "Failed: Transaction destination fee didn't match.")
        XCTAssertEqual(transaction!.destination!.rate!, "1.00", "Failed: Transaction destination rate didn't match.")
        XCTAssertEqual(transaction!.destination!.type!, "email", "Failed: Transaction destination type didn't match.")
        XCTAssertEqual(transaction!.destination!.username!, "fizbiz", "Failed: Transaction destination username didn't match.")
        XCTAssertEqual(transaction!.fees![0].amount, "0.30", "Failed: Transaction fee amount didn't match.")
        XCTAssertEqual(transaction!.fees![0].currency, "USD", "Failed: Transaction fee currency didn't match.")
        XCTAssertEqual(transaction!.fees![0].percentage, "2.75", "Failed: Transaction fee percentage didn't match.")
        XCTAssertEqual(transaction!.fees![0].target, "origin", "Failed: Transaction fee target didn't match.")
        XCTAssertEqual(transaction!.fees![0].type, "deposit", "Failed: Transaction fee type didn't match.")
        XCTAssertEqual(transaction!.message!, "foobar message", "Failed: Transaction message didn't match.")
        XCTAssertEqual(transaction!.network, "qux", "Failed: Transaction network didn't match.")
        XCTAssertEqual(transaction!.normalized!.count, 1, "Failed: Normalized didn't match.")
        XCTAssertEqual(transaction!.normalized![0].amount, "14.00", "Failed: Normalized amount didn't match.")
        XCTAssertEqual(transaction!.normalized![0].commission, "1.20", "Failed: Normalized comission didn't match.")
        XCTAssertEqual(transaction!.normalized![0].currency, "BTC", "Failed: Normalized currency didn't match.")
        XCTAssertEqual(transaction!.normalized![0].fee, "1.00", "Failed: Normalized fee didn't match.")
        XCTAssertEqual(transaction!.normalized![0].rate, "2.345", "Failed: Normalized rate didn't match.")
        XCTAssertEqual(transaction!.origin!.accountId!, "fizbuz", "Failed: Transaction origin accountId didn't match.")
        XCTAssertEqual(transaction!.origin!.cardId!, "fizbiz", "Failed: Transaction origin cardId didn't match.")
        XCTAssertEqual(transaction!.origin!.amount!, "0.1", "Failed: Transaction origin amount didn't match.")
        XCTAssertEqual(transaction!.origin!.base!, "0.1", "Failed: Transaction origin base didn't match.")
        XCTAssertEqual(transaction!.origin!.commission!, "0.00", "Failed: Transaction origin commission didn't match.")
        XCTAssertEqual(transaction!.origin!.currency!, "BTC", "Failed: Transaction origin currency didn't match.")
        XCTAssertEqual(transaction!.origin!.description!, "Fuz Buz", "Failed: Transaction origin description didn't match.")
        XCTAssertEqual(transaction!.origin!.fee!, "0.00", "Failed: Transaction origin fee didn't match.")
        XCTAssertEqual(transaction!.origin!.rate!, "1.00", "Failed: Transaction origin rate didn't match.")
        XCTAssertEqual(transaction!.origin!.sources!.count, 1, "Failed: Transaction origin type didn't match.")
        XCTAssertEqual(transaction!.origin!.sources![0].id!, "fizbuz", "Failed: Transaction origin type didn't match.")
        XCTAssertEqual(transaction!.origin!.sources![0].amount!, "2.00", "Failed: Transaction origin type didn't match.")
        XCTAssertEqual(transaction!.origin!.type!, "card", "Failed: Transaction origin type didn't match.")
        XCTAssertEqual(transaction!.origin!.username!, "fuzbuz", "Failed: Transaction origin username didn't match.")
        XCTAssertEqual(transaction!.params!.currency, "BTC", "Failed: Wrong transaction parameter currency.")
        XCTAssertEqual(transaction!.params!.margin, "0.00", "Failed: Wrong transaction parameter margin.")
        XCTAssertEqual(transaction!.params!.pair, "BTCBTC", "Failed: Wrong transaction parameter pair.")
        XCTAssertEqual(transaction!.params!.rate, "1.00", "Failed: Wrong transaction parameter rate.")
        XCTAssertEqual(transaction!.params!.refunds, "fizbiz", "Failed: Wrong transaction parameter refunds.")
        XCTAssertEqual(transaction!.params!.ttl, 30000, "Failed: Wrong transaction parameter ttl.")
        XCTAssertEqual(transaction!.params!.type, "invite", "Failed: Wrong transaction parameter type.")
        XCTAssertEqual(transaction!.refundedById!, "foobiz", "Failed: Transaction refundedById didn't match.")
        XCTAssertEqual(transaction!.status!, "pending", "Failed: Transaction status didn't match.")
        XCTAssertEqual(transaction!.type!, "transfer", "Failed: Transaction type didn't match.")
    }

}
