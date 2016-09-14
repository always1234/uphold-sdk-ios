import XCTest
import ObjectMapper
import PromiseKit
@testable import UpholdSdk

/// Card integration tests.
class CardTest: UpholdTestCase {

    func testCardMapperShouldReturnACard() {
        let json: String = "{" +
            "\"address\": {" +
                "\"bitcoin\": \"fuzbuz\"" +
            "}," +
            "\"available\": \"87.52\"," +
            "\"balance\": \"87.52\"," +
            "\"currency\": \"EUR\"," +
            "\"id\": \"foobar\"," +
            "\"label\": \"Foo card\"," +
            "\"lastTransactionAt\": \"foobiz\"," +
            "\"settings\": {" +
                "\"position\": 4," +
                "\"starred\": true" +
            "}," +
            "\"addresses\": [{" +
                "\"id\": \"fiz\"," +
                "\"network\": \"biz\"" +
            "}]," +
            "\"normalized\": [{" +
                "\"available\": \"99.04\"," +
                "\"balance\": \"99.04\"," +
                "\"currency\": \"USD\"" +
            "}]" +
        "}"
        let card = Mapper<Card>().map(JSONString: json)

        XCTAssertEqual(card!.id!, "foobar", "Failed: Card id didn't match.")
        XCTAssertFalse(card!.address!.isEmpty, "Failed: Address didn't match.")
        XCTAssertEqual(card!.address!.count, 1, "Failed: Address didn't match.")
        XCTAssertEqual(card!.address!["bitcoin"]!, "fuzbuz", "Failed: Address didn't match.")
        XCTAssertEqual(card!.available!, "87.52", "Failed: Available didn't match.")
        XCTAssertEqual(card!.balance!, "87.52", "Failed: Balance didn't match.")
        XCTAssertEqual(card!.currency!, "EUR", "Failed: Currency didn't match.")
        XCTAssertEqual(card!.label!, "Foo card", "Failed: Label didn't match.")
        XCTAssertEqual(card!.lastTransactionAt!, "foobiz", "Failed: LastTransactionAt didn't match.")
        XCTAssertEqual(card!.normalized!.count, 1, "Failed: Normalized didn't match.")
        XCTAssertEqual(card!.normalized![0].available!, "99.04", "Failed: Available didn't match.")
        XCTAssertEqual(card!.normalized![0].balance!, "99.04", "Failed: Balance didn't match.")
        XCTAssertEqual(card!.normalized![0].currency!, "USD", "Failed: Currency didn't match.")
        XCTAssertEqual(card!.settings!.position!, 4, "Failed: Position didn't match.")
        XCTAssertTrue(card!.settings!.starred!, "Failed: Starred didn't match.")
    }

    func testCreateAddressShouldReturnTheAddress() {
        let testExpectation = expectation(description: "User test: create address.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: "{\"id\": \"foo\",\"network\": \"bar\"}")

        card.createAddress(addressRequest: AddressRequest(network: "bitcoin")).then { (address: Address) -> () in
            XCTAssertEqual(address.id, "foo", "Failed: Wrong adrress id.")
            XCTAssertEqual(address.network, "bar", "Failed: Wrong address network.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create address error.")
        })

        wait()
    }

    func testCreateAddressShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "User test: create address.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()

        card.createAddress(addressRequest: AddressRequest(network: "bitcoin")).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCreateTransactionCardDepositShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction card deposit.")

        let card: Card = Fixtures.loadCard()
        let json: String = "{" +
            "\"id\": \"foobar\"," +
            "\"type\": \"transfer\"," +
            "\"message\": \"foobar\"," +
            "\"network\": \"qux\"," +
            "\"status\": \"pending\"," +
            "\"RefundedById\": \"foobiz\"," +
            "\"createdAt\": \"2014-08-27T00:01:11.616Z\"," +
            "\"denomination\": {" +
                "\"amount\": \"0.1\"," +
                "\"currency\": \"BTC\"," +
                "\"pair\": \"BTCBTC\"," +
                "\"rate\": \"1.00\"" +
            "}," +
            "\"origin\": {" +
                "\"AccountId\": \"fiz\"," +
                "\"CardId\": \"bar\"," +
                "\"accountType\": \"biz\"," +
                "\"amount\": \"0.1\"," +
                "\"base\": \"0.1\"," +
                "\"commission\": \"0.00\"," +
                "\"currency\": \"BTC\"," +
                "\"description\": \"Foo Bar\"," +
                "\"fee\": \"0.00\"," +
                "\"rate\": \"1.00\"," +
                "\"type\": \"card\"," +
                "\"username\": \"foobar\"" +
            "}," +
            "\"destination\": {" +
                "\"AccountId\": \"fuz\"," +
                "\"accountType\": \"buz\"," +
                "\"amount\": \"0.1\"," +
                "\"base\": \"0.1\"," +
                "\"commission\": \"0.00\"," +
                "\"currency\": \"BTC\"," +
                "\"description\": \"foo@bar.com\"," +
                "\"fee\": \"0.00\"," +
                "\"rate\": \"1.00\"," +
                "\"type\": \"email\"" +
            "}," +
            "\"params\": {" +
                "\"currency\": \"BTC\"," +
                "\"margin\": \"0.00\"," +
                "\"pair\": \"BTCBTC\"," +
                "\"rate\": \"1.00\"," +
                "\"refunds\": \"fizbiz\"," +
                "\"ttl\": 30000," +
                "\"type\": \"invite\"" +
            "}," +
            "\"normalized\": [{" +
                "\"amount\": \"123\"," +
                "\"commission\": \"0.00\"," +
                "\"currency\": \"BTC\"," +
                "\"fee\": \"1.00\"," +
                "\"rate\": \"2.00\"" +
            "}]," +
            "\"fees\": [{" +
                "\"type\": \"deposit\"," +
                "\"amount\": \"0.30\"," +
                "\"target\": \"origin\"," +
                "\"currency\": \"USD\"," +
                "\"percentage\": \"2.75\"" +
            "}]" +
        "}"

        card.adapter = MockRestAdapter(body: json)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionCardDepositRequest = TransactionCardDepositRequest(denomination: transactionDenominationRequest, origin: "foobiz", securityCode: "1234")

        card.createTransaction(transactionRequest: transactionCardDepositRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.createdAt, "2014-08-27T00:01:11.616Z", "Failed: Wrong transaction createdAt.")
            XCTAssertEqual(transaction.denomination!.amount, "0.1", "Failed: Wrong transaction denomination amount.")
            XCTAssertEqual(transaction.denomination!.currency, "BTC", "Failed: Wrong transaction denomination currency.")
            XCTAssertEqual(transaction.denomination!.pair, "BTCBTC", "Failed: Wrong transaction denomination pair.")
            XCTAssertEqual(transaction.denomination!.rate, "1.00", "Failed: Wrong transaction denomination rate.")
            XCTAssertEqual(transaction.destination!.accountId, "fuz", "Failed: Wrong transaction destination accountId.")
            XCTAssertEqual(transaction.destination!.accountType, "buz", "Failed: Wrong transaction destination accountType.")
            XCTAssertEqual(transaction.destination!.amount, "0.1", "Failed: Wrong transaction destination amount.")
            XCTAssertEqual(transaction.destination!.base, "0.1", "Failed: Wrong transaction destination base.")
            XCTAssertEqual(transaction.destination!.commission, "0.00", "Failed: Wrong transaction destination commission.")
            XCTAssertEqual(transaction.destination!.currency, "BTC", "Failed: Wrong transaction destination currency.")
            XCTAssertEqual(transaction.destination!.description, "foo@bar.com", "Failed: Wrong transaction destination description.")
            XCTAssertEqual(transaction.destination!.fee, "0.00", "Failed: Wrong transaction destination fee.")
            XCTAssertEqual(transaction.destination!.rate, "1.00", "Failed: Wrong transaction destination rate.")
            XCTAssertEqual(transaction.destination!.type, "email", "Failed: Wrong transaction destination type.")
            XCTAssertEqual(transaction.fees![0].amount, "0.30", "Failed: Wrong transaction fee amount.")
            XCTAssertEqual(transaction.fees![0].currency, "USD", "Failed: Wrong transaction fee currency.")
            XCTAssertEqual(transaction.fees![0].percentage, "2.75", "Failed: Wrong transaction fee percentage.")
            XCTAssertEqual(transaction.fees![0].target, "origin", "Failed: Wrong transaction fee target.")
            XCTAssertEqual(transaction.fees![0].type, "deposit", "Failed: Wrong transaction fee type.")
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")
            XCTAssertEqual(transaction.network, "qux", "Failed: Wrong transaction network.")
            XCTAssertEqual(transaction.message, "foobar", "Failed: Wrong transaction message.")
            XCTAssertEqual(transaction.normalized!.count, 1, "Failed: Wrong transaction normalized count.")
            XCTAssertEqual(transaction.normalized![0].amount, "123", "Failed: Wrong transaction normalized amount.")
            XCTAssertEqual(transaction.normalized![0].commission, "0.00", "Failed: Wrong transaction normalized comission.")
            XCTAssertEqual(transaction.normalized![0].currency, "BTC", "Failed: Wrong transaction normalized currency.")
            XCTAssertEqual(transaction.normalized![0].fee, "1.00", "Failed: Wrong transaction normalized fee.")
            XCTAssertEqual(transaction.normalized![0].rate, "2.00", "Failed: Wrong transaction normalized rate.")
            XCTAssertEqual(transaction.origin!.accountId, "fiz", "Failed: Wrong transaction origin accountId.")
            XCTAssertEqual(transaction.origin!.cardId, "bar", "Failed: Wrong transaction origin cardId.")
            XCTAssertEqual(transaction.origin!.accountType, "biz", "Failed: Wrong transaction origin accountType.")
            XCTAssertEqual(transaction.origin!.amount, "0.1", "Failed: Wrong transaction origin amount.")
            XCTAssertEqual(transaction.origin!.base, "0.1", "Failed: Wrong transaction origin base.")
            XCTAssertEqual(transaction.origin!.commission, "0.00", "Failed: Wrong transaction origin comission.")
            XCTAssertEqual(transaction.origin!.currency, "BTC", "Failed: Wrong transaction origin currency.")
            XCTAssertEqual(transaction.origin!.description, "Foo Bar", "Failed: Wrong transaction origin description.")
            XCTAssertEqual(transaction.origin!.fee, "0.00", "Failed: Wrong transaction origin fee.")
            XCTAssertEqual(transaction.origin!.rate, "1.00", "Failed: Wrong transaction origin rate.")
            XCTAssertEqual(transaction.origin!.type, "card", "Failed: Wrong transaction origin type.")
            XCTAssertEqual(transaction.origin!.username, "foobar", "Failed: Wrong transaction origin username.")
            XCTAssertEqual(transaction.params!.currency, "BTC", "Failed: Wrong transaction parameter currency.")
            XCTAssertEqual(transaction.params!.margin, "0.00", "Failed: Wrong transaction parameter margin.")
            XCTAssertEqual(transaction.params!.pair, "BTCBTC", "Failed: Wrong transaction parameter pair.")
            XCTAssertEqual(transaction.params!.rate, "1.00", "Failed: Wrong transaction parameter rate.")
            XCTAssertEqual(transaction.params!.refunds, "fizbiz", "Failed: Wrong transaction parameter refunds.")
            XCTAssertEqual(transaction.params!.ttl, 30000, "Failed: Wrong transaction parameter ttl.")
            XCTAssertEqual(transaction.params!.type, "invite", "Failed: Wrong transaction parameter type.")
            XCTAssertEqual(transaction.refundedById, "foobiz", "Failed: Wrong transaction refundedById.")
            XCTAssertEqual(transaction.status, "pending", "Failed: Wrong transaction status.")
            XCTAssertEqual(transaction.type, "transfer", "Failed: Wrong transaction type.")
            XCTAssertEqual(transactionCardDepositRequest.origin, "foobiz", "Failed: Wrong transaction card deposit origin.")
            XCTAssertEqual(transactionCardDepositRequest.securityCode, "1234", "Failed: Wrong transaction card deposit security code.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction card deposit error.")
        })

        wait()
    }

    func testCreateTransactionCardDepositShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionCardDepositRequest = TransactionCardDepositRequest(denomination: transactionDenominationRequest, origin: "foobar", securityCode: "1234")

        card.createTransaction(transactionRequest: transactionCardDepositRequest).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCreateTransactionCardDepositWithCommitShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadTransaction(fields: ["transactionId": "foobar"]))!)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionCardDepositRequest = TransactionCardDepositRequest(denomination: transactionDenominationRequest, origin: "foobar", securityCode: "1234")

        card.createTransaction(commit: true, transactionRequest: transactionCardDepositRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCreateTransactionDepositShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction deposit.")

        let card: Card = Fixtures.loadCard()
        let json: String = "{" +
            "\"id\": \"foobar\"," +
        "}"

        card.adapter = MockRestAdapter(body: json)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionDepositRequest = TransactionDepositRequest(denomination: transactionDenominationRequest, origin: "foobiz")

        card.createTransaction(transactionRequest: transactionDepositRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")
            XCTAssertEqual(transactionDepositRequest.origin, "foobiz", "Failed: Wrong transaction origin.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction deposit error.")
        })

        wait()
    }

    func testCreateTransactionDepositShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionDepositRequest = TransactionDepositRequest(denomination: transactionDenominationRequest, origin: "foobar")

        card.createTransaction(transactionRequest: transactionDepositRequest).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCreateTransactionDepositWithCommitShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadTransaction(fields: ["transactionId": "foobar"]))!)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionDepositRequest = TransactionDepositRequest(denomination: transactionDenominationRequest, origin: "foobar")

        card.createTransaction(commit: true, transactionRequest: transactionDepositRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCreateTransactionTransferShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Fixtures.loadCard()
        let json: String = "{" +
            "\"id\": \"foobar\"," +
        "}"
        card.adapter = MockRestAdapter(body: json)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionRequest = TransactionTransferRequest(denomination: transactionDenominationRequest, destination: "foobiz")

        card.createTransaction(transactionRequest: transactionRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")
            XCTAssertEqual(transactionRequest.destination, "foobiz", "Failed: Wrong transaction destination.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testCreateTransactionTransferShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionRequest = TransactionTransferRequest(denomination: transactionDenominationRequest, destination: "foobar")

        card.createTransaction(transactionRequest: transactionRequest).catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testCreateTransactionTransferWithCommitShouldReturnTheTransaction() {
        let testExpectation = expectation(description: "Card test: create transaction transfer.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadTransaction(fields: ["transactionId": "foobar"]))!)
        let transactionDenominationRequest = TransactionDenominationRequest(amount: "foo", currency: "bar")
        let transactionRequest = TransactionTransferRequest(denomination: transactionDenominationRequest, destination: "foobar")

        card.createTransaction(commit: true, transactionRequest: transactionRequest).then { (transaction: Transaction) -> () in
            XCTAssertEqual(transaction.id, "foobar", "Failed: Wrong transaction id.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create transaction transfer error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnTheArrayOfTransactions() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!)

        card.getTransactions().elements.then(execute: { (transactions: [Transaction]) -> () in
            let mockRestAdapter: MockRestAdapter = (card.adapter as? MockRestAdapter)!

            XCTAssertEqual(mockRestAdapter.headers!.count, 1, "Failed: Wrong number of headers.")
            XCTAssertEqual(mockRestAdapter.headers!["Range"], "items=0-49", "Failed: Wrong number of headers.")
            XCTAssertEqual(transactions[0].id, "foobar", "Failed: Wrong transaction object.")
            XCTAssertEqual(transactions[1].id, "foobiz", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transaction error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorCount() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(), Fixtures.loadTransaction()])!, headers: ["content-range": "0-2/60"])

        card.getTransactions().count().then(execute: { (count: Int) -> () in
            XCTAssertEqual(count, 60, "Failed: Wrong paginator count.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorHasNext() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Fixtures.loadCard()
        card.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(), Fixtures.loadTransaction()])!, headers: ["content-range": "0-49/51"])

        card.getTransactions().hasNext().then(execute: { (bool: Bool) -> () in
            XCTAssertTrue(bool, "Failed: Wrong paginator hasNext value.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transactions.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorNextPage() {
        let card: Card = Fixtures.loadCard()
        let transactions: [Transaction] = [Fixtures.loadTransaction(), Fixtures.loadTransaction()]
        card.adapter = MockRestAdapter(body: Mapper().toJSONString(transactions)!)
        let paginator: Paginator<Transaction> = card.getTransactions()

        paginator.getNext().catch(execute: { (error: Error) in
            XCTFail("Paginator get next error.")
        })

        let firstRequestHeaders = (card.adapter as? MockRestAdapter)!.headers

        paginator.getNext().catch(execute: { (error: Error) in
            XCTFail("Paginator get next error.")
        })

        let secondRequestHeaders = (card.adapter as? MockRestAdapter)!.headers

        XCTAssertEqual(firstRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(firstRequestHeaders!["Range"], "items=50-99", "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!["Range"], "items=100-149", "Failed: Wrong number of headers.")
    }

    func testGetTransactionsPaginatorCountShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()

        card.getTransactions().count().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetTransactionsPaginatorElementsShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()

        card.getTransactions().elements.catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetTransactionsPaginatorGetNextShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()

        card.getTransactions().getNext().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetTransactionsPaginatorHasNextShouldReturnUnexpectedResponseError() {
        let testExpectation = expectation(description: "Card test: get transactions.")

        let card: Card = Mapper().map(JSONString: "{}")!
        card.adapter = MockRestAdapter()

        card.getTransactions().hasNext().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Card id should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testUpdateShouldReturnTheCard() {
        let testExpectation = expectation(description: "Card test: update card.")

        let card: Card = Fixtures.loadCard(fields: ["id": "foobar"])
        card.adapter = MockRestAdapter(body: Mapper().toJSONString(card)!)

        card.update(updateFields: ["id": "foobar"]).then { (card: Card) -> () in
            XCTAssertEqual(card.id, "foobar", "Failed: Wrong card id.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Card test: update card error.")
        })

        wait()
    }

}
