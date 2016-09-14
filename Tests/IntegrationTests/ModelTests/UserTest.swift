import XCTest
import ObjectMapper
import PromiseKit
@testable import UpholdSdk

/// User integration tests.
class UserTest: UpholdTestCase {

    func testCreateCardShouldReturnTheCard() {
        let testExpectation = expectation(description: "User test: create card.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadCard(fields: ["id": "foobar", "currency": "foo", "label": "BTC"]))!)

        user.createCard(cardRequest: CardRequest(currency: "foo", label: "BTC")).then { (card: Card) -> () in
            XCTAssertEqual(card.currency, "foo", "Failed: Wrong card currency.")
            XCTAssertEqual(card.id, "foobar", "Failed: Wrong card id.")
            XCTAssertEqual(card.label, "BTC", "Failed: Wrong card label.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create card error.")
        })

        wait()
    }

    func testCreateCardWithSettingsShouldReturnTheCard() {
        let testExpectation = expectation(description: "User test: create card.")

        let cardSettings: CardSettings = CardSettings(position: 1, starred: true)
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadCard(fields: ["id": "foobar"]))!)

        user.createCard(cardRequest: CardRequest(currency: "foo", label: "BTC", settings: cardSettings)).then { (card: Card) -> () in
            XCTAssertEqual(card.id, "foobar", "Failed: Wrong card id.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: create card error.")
        })

        wait()
    }

    func testGetAccountByIdShouldReturnTheAccount() {
        let testExpectation = expectation(description: "User test: get account by id.")

        let account: Account = Fixtures.loadAccount(fields: ["id": "foobar"])
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(account)!)

        user.getAccountById(accountId: "foobar").then { (account: Account) -> () in
            XCTAssertEqual(account.id, "foobar", "Failed: Wrong account object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get account by id error.")
        })

        wait()
    }

    func testGetAccountsShouldReturnTheArrayOfAccounts() {
        let testExpectation = expectation(description: "User test: get accounts.")

        let json: String = "[{" +
            "\"currency\": \"EUR\"," +
            "\"id\": \"foo\"," +
            "\"label\": \"bar\"," +
            "\"status\": \"foobar\"," +
            "\"type\": \"fiz\"" +
        "}," +
        "{" +
            "\"currency\": \"USD\"," +
            "\"id\": \"bar\"," +
            "\"label\": \"foo\"," +
            "\"status\": \"foobiz\"," +
            "\"type\": \"biz\"" +
        "}]"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getAccounts().then { (accounts: [Account]) -> () in
            XCTAssertEqual(accounts.count, 2, "Failed: Wrong number of accounts.")
            XCTAssertEqual(accounts[0].currency, "EUR", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[0].id, "foo", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[0].label, "bar", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[0].status, "foobar", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[0].type, "fiz", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[1].currency, "USD", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[1].id, "bar", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[1].label, "foo", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[1].status, "foobiz", "Failed: Wrong account object.")
            XCTAssertEqual(accounts[1].type, "biz", "Failed: Wrong account object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get accounts error.")
        })

        wait()
    }

    func testGetBalancesByCurrencyShouldReturnTheCurrencyBalance() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let json: String = "{" +
            "\"balances\": {" +
                "\"total\": \"1083.77\"," +
                "\"currencies\": {" +
                    "\"CNY\": {" +
                        "\"amount\": \"6.98\"," +
                        "\"balance\": \"42.82\"," +
                        "\"currency\": \"USD\"," +
                        "\"rate\": \"6.13880\"" +
                    "}," +
                    "\"BTC\": {" +
                        "\"amount\": \"2.98\"," +
                        "\"balance\": \"890.82\"," +
                        "\"currency\": \"USD\"," +
                        "\"rate\": \"300.14202\"" +
                    "}," +
                    "\"EUR\": {" +
                        "\"amount\": \"75.01\"," +
                        "\"balance\": \"58.05\"," +
                        "\"currency\": \"EUR\"," +
                        "\"rate\": \"1.29220\"" +
                    "}" +
                "}" +
            "}" +
        "}"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getBalanceByCurrency(currency: "EUR").then { (currency: Currency) -> () in
            XCTAssertEqual(currency.amount, "75.01", "Failed: Wrong currency amount.")
            XCTAssertEqual(currency.balance, "58.05", "Failed: Wrong currency balance.")
            XCTAssertEqual(currency.currency, "EUR", "Failed: Wrong currency.")
            XCTAssertEqual(currency.rate, "1.29220", "Failed: Wrong currency.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get balances by currency error.")
        })

        wait()
    }

    func testGetBalancesByCurrencyShouldReturnCurrencyDoesNotExistError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let json: String = "{" +
            "\"balances\": {" +
                "\"total\": \"1083.77\"," +
                "\"currencies\": {" +
                    "\"CNY\": {" +
                        "\"amount\": \"6.98\"," +
                        "\"balance\": \"42.82\"," +
                        "\"currency\": \"USD\"," +
                        "\"rate\": \"6.13880\"" +
                    "}," +
                    "\"EUR\": {" +
                        "\"amount\": \"75.01\"," +
                        "\"balance\": \"58.05\"," +
                        "\"currency\": \"EUR\"," +
                        "\"rate\": \"1.29220\"" +
                    "}" +
                "}" +
            "}" +
        "}"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getBalanceByCurrency(currency: "USD").catch(execute: { (error: Error) in
            guard let error = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "Currency does not exist.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetBalancesByCurrencyShouldReturnEmptyBalancesError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: "{}")

        user.getBalanceByCurrency(currency: "EUR").catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
            XCTAssertEqual(error.description, "Balances should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetBalancesByCurrencyShouldReturnEmptyCurrenciesError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: "{\"balances\": {} }")

        user.getBalanceByCurrency(currency: "EUR").catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
            XCTAssertEqual(error.description, "Currencies should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetBalancesShouldReturnTheArrayOfBalances() {
        let testExpectation = expectation(description: "User test: get balances.")

        let json: String = "{" +
            "\"balances\": {" +
                "\"total\": \"1083.77\"," +
                "\"currencies\": {" +
                    "\"CNY\": {" +
                        "\"amount\": \"6.98\"" +
                    "}," +
                    "\"BTC\": {" +
                        "\"amount\": \"2.45\"" +
                    "}," +
                    "\"EUR\": {" +
                        "\"amount\": \"75.01\"" +
                    "}" +
                "}" +
            "}" +
        "}"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getBalances().then { (currencies: [Currency]) -> () in
            XCTAssertEqual(currencies.count, 3, "Failed: Wrong number of currencies.")
            XCTAssertEqual(currencies[0].amount, "2.45", "Failed: Wrong currency amount.")
            XCTAssertEqual(currencies[1].amount, "6.98", "Failed: Wrong currency amount.")
            XCTAssertEqual(currencies[2].amount, "75.01", "Failed: Wrong currency amount.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get balances error.")
        })

        wait()
    }

    func testGetBalancesShouldReturnEmptyBalancesError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: "{}")

        user.getBalances().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
            XCTAssertEqual(error.description, "Balances should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetBalancesShouldReturnEmptyCurrenciesError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: "{\"balances\": {} }")

        user.getBalances().catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
            XCTAssertEqual(error.description, "Currencies should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetCardsByCurrencyShouldReturnTheArrayOfCardsWithCurrency() {
        let testExpectation = expectation(description: "User test: get cards by currency.")

        let cards: [Card] = [Fixtures.loadCard(fields: ["id": "foobar", "currency": "USD"]), Fixtures.loadCard(fields: ["id": "foobiz", "currency": "BTC"]), Fixtures.loadCard(fields: ["id": "fuzbuz", "currency": "BTC"])]
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(cards)!)

        user.getCardsByCurrency(currency: "BTC").then { (cards: [Card]) -> () in
            XCTAssertEqual(cards.count, 2, "Failed: Wrong number of card objects.")
            XCTAssertEqual(cards[0].id, "foobiz", "Failed: Wrong card object.")
            XCTAssertEqual(cards[0].currency, "BTC", "Failed: Wrong card currency.")
            XCTAssertEqual(cards[1].id, "fuzbuz", "Failed: Wrong card object.")
            XCTAssertEqual(cards[1].currency, "BTC", "Failed: Wrong card currency.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get cards by currency error.")
        })

        wait()
    }

    func testGetCardsByCurrencyShouldReturnUnmatchedCurrencyError() {
        let testExpectation = expectation(description: "User test: get balances by currency.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(Fixtures.loadCard(fields: ["id": "foobar", "currency": "BTC"]))!)

        user.getCardsByCurrency(currency: "USD").catch(execute: { (error: Error) in
            guard let error = error as? LogicError else {
                XCTFail("Error should be LogicError.")

                return
            }

            XCTAssertNil(error.code, "Failed: Wrong code.")
            XCTAssertEqual(error.description, "There are no cards in the given currency.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetCardByIdShouldReturnTheCard() {
        let testExpectation = expectation(description: "User test: get card by id.")

        let card: Card = Fixtures.loadCard(fields: ["id": "foobar"])
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(card)!)

        user.getCardById(cardId: "foobar").then { (card: Card) -> () in
            XCTAssertEqual(card.id, "foobar", "Failed: Wrong card object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get card by id error.")
        })

        wait()
    }

    func testGetCardsShouldReturnTheArrayOfCards() {
        let testExpectation = expectation(description: "User test: get cards.")

        let cards: [Card] = [Fixtures.loadCard(fields: ["id": "foo"]), Fixtures.loadCard(fields: ["id": "bar"])]
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(cards)!)

        user.getCards().then { (cards: [Card]) -> () in
            XCTAssertEqual(cards[0].id, "foo", "Failed: Wrong card object.")
            XCTAssertEqual(cards[1].id, "bar", "Failed: Wrong card object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get cards error.")
        })

        wait()
    }

    func testGetContactsShouldReturnTheListOfContacts() {
        let testExpectation = expectation(description: "User test: get contacts.")

        let json: String = "[{" +
            "\"id\": \"foobar\"," +
            "\"firstName\": \"Foo\"," +
            "\"lastName\": \"Bar\"," +
            "\"company\": \"biz\"," +
            "\"emails\": [" +
                "\"foo@bar.org\"" +
            "]," +
            "\"addresses\": [\"FooBar FooBiz\"]," +
            "\"name\": \"Foo Bar\"" +
            "}, {" +
            "\"id\": \"fizbar\"," +
            "\"firstName\": \"Fuz\"," +
            "\"lastName\": \"Buz\"," +
            "\"company\": \"fiz\"," +
            "\"emails\": [" +
                "\"fuzbuz@buz.org\"" +
            "]," +
            "\"addresses\": [\"FizBiz FooBiz\"]," +
            "\"name\": \"Fuz Buz\"" +
        "}]"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getContacts().then { (contact: [Contact]) -> () in
            XCTAssertEqual(contact.count, 2, "Failed: Wrong number of contacts objects.")
            XCTAssertEqual(contact[0].addresses!.count, 1, "Failed: Wrong number of addresses.")
            XCTAssertEqual(contact[0].addresses![0], "FooBar FooBiz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].company, "biz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].emails!.count, 1, "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].emails![0], "foo@bar.org", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].firstName, "Foo", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].id, "foobar", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].lastName, "Bar", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[0].name, "Foo Bar", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].addresses!.count, 1, "Failed: Wrong number of addresses.")
            XCTAssertEqual(contact[1].addresses![0], "FizBiz FooBiz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].company, "fiz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].emails!.count, 1, "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].emails![0], "fuzbuz@buz.org", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].firstName, "Fuz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].id, "fizbar", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].lastName, "Buz", "Failed: Wrong contact object.")
            XCTAssertEqual(contact[1].name, "Fuz Buz", "Failed: Wrong contact object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get contacts error.")
        })

        wait()
    }

    func testGetPhonesShouldReturnTheListOfPhones() {
        let testExpectation = expectation(description: "User test: get phones.")

        let json: String = "[{" +
            "\"id\": \"foobar\"," +
            "\"verified\": true," +
            "\"primary\": true," +
            "\"e164Masked\": \"+XXXXXXXXX04\"," +
            "\"nationalMasked\": \"(XXX) XXX-XX04\"," +
            "\"internationalMasked\": \"+X XXX-XXX-XX04\"" +
        "}]"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getPhones().then { (phones: [Phone]) -> () in
            XCTAssertEqual(phones.count, 1, "Failed: Wrong number of phone objects.")
            XCTAssertEqual(phones[0].e164Masked, "+XXXXXXXXX04", "Failed: Wrong phone e164Masked field.")
            XCTAssertEqual(phones[0].id, "foobar", "Failed: Wrong phone id.")
            XCTAssertEqual(phones[0].internationalMasked, "+X XXX-XXX-XX04", "Failed: Wrong phone internationalMasked field.")
            XCTAssertEqual(phones[0].nationalMasked, "(XXX) XXX-XX04", "Failed: Wrong phone nationalMasked field.")
            XCTAssertTrue(phones[0].primary!, "Failed: Wrong phone primary field.")
            XCTAssertTrue(phones[0].verified!, "Failed: Wrong phone verified field.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get phones error.")
        })

        wait()
    }

    func testGetTotalBalancesShouldReturnTheTotalBalance() {
        let testExpectation = expectation(description: "User test: get total balances.")

        let json: String = "{" +
            "\"balances\": {" +
                "\"total\": \"1083.77\"," +
                "\"currencies\": {" +
                    "\"CNY\": {" +
                        "\"amount\": \"6.98\"," +
                        "\"balance\": \"42.82\"," +
                        "\"currency\": \"USD\"," +
                        "\"rate\": \"6.13880\"" +
                    "}," +
                    "\"EUR\": {" +
                        "\"amount\": \"75.01\"," +
                        "\"balance\": \"58.05\"," +
                        "\"currency\": \"EUR\"," +
                        "\"rate\": \"1.29220\"" +
                    "}" +
                "}" +
            "}" +
        "}"
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: json)

        user.getTotalBalances().then { (balances: UserBalance) -> () in
            guard let currencies = balances.currencies else {
                XCTFail("Currencies should not be nil.")

                return
            }

            XCTAssertEqual(currencies.count, 2, "Failed: Wrong number of currencies.")
            XCTAssertEqual(currencies["CNY"]!.amount, "6.98", "Failed: Wrong currency amount.")
            XCTAssertEqual(currencies["CNY"]!.balance, "42.82", "Failed: Wrong currency balance.")
            XCTAssertEqual(currencies["CNY"]!.currency, "USD", "Failed: Wrong currency currency.")
            XCTAssertEqual(currencies["CNY"]!.rate, "6.13880", "Failed: Wrong currency rate.")
            XCTAssertEqual(currencies["EUR"]!.amount, "75.01", "Failed: Wrong currency amount.")
            XCTAssertEqual(currencies["EUR"]!.balance, "58.05", "Failed: Wrong currency balance.")
            XCTAssertEqual(currencies["EUR"]!.currency, "EUR", "Failed: Wrong currency currency.")
            XCTAssertEqual(currencies["EUR"]!.rate, "1.29220", "Failed: Wrong currency rate.")
            XCTAssertEqual(balances.total, "1083.77", "Failed: Wrong balance total.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: get total balances error.")
        })

        wait()
    }

    func testGetTotalBalancesShouldReturnEmptyBalancesError() {
        let testExpectation = expectation(description: "User test: get total balances.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: "{}")
        let promise: Promise<UserBalance> = user.getTotalBalances()

        promise.catch(execute: { (error: Error) in
            guard let error = error as? UnexpectedResponseError else {
                XCTFail("Error should be UnexpectedResponseError.")

                return
            }

            XCTAssertNil(error.code, "Failed: HTTP status code should be nil.")
            XCTAssertEqual(error.description, "Balances should not be nil.", "Failed: Wrong message.")

            testExpectation.fulfill()
        })

        wait()
    }

    func testGetTransactionsShouldReturnTheArrayOfTransactions() {
        let testExpectation = expectation(description: "User test: get transactions.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!)

        user.getUserTransactions().elements.then(execute: { (transactions: [Transaction]) -> () in
            let mockRestAdapter: MockRestAdapter = (user.adapter as? MockRestAdapter)!

            XCTAssertEqual(mockRestAdapter.headers!.count, 1, "Failed: Wrong number of headers.")
            XCTAssertEqual(mockRestAdapter.headers!["Range"], "items=0-49", "Failed: Wrong number of headers.")
            XCTAssertEqual(transactions.count, 2, "Failed: Wrong number of transaction objects.")
            XCTAssertEqual(transactions[0].id, "foobar", "Failed: Wrong transaction object.")
            XCTAssertEqual(transactions[1].id, "foobiz", "Failed: Wrong transaction object.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorCount() {
        let testExpectation = expectation(description: "User test: get transactions.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!, headers: ["content-range": "0-2/60"])

        user.getUserTransactions().count().then(execute: { (count: Int) -> () in
            XCTAssertEqual(count, 60, "Failed: Wrong paginator count.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorHasNext() {
        let testExpectation = expectation(description: "User test: get transactions.")

        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!, headers: ["content-range": "0-49/51"])

        user.getUserTransactions().hasNext().then(execute: { (bool: Bool) -> () in
            XCTAssertTrue(bool, "Failed: Wrong paginator hasNext value.")

            testExpectation.fulfill()
        }).catch(execute: { (error: Error) in
            XCTFail("User test: get transactions error.")
        })

        wait()
    }

    func testGetTransactionsShouldReturnThePaginatorNextPage() {
        let user: User = Fixtures.loadUser()
        user.adapter = MockRestAdapter(body: Mapper().toJSONString([Fixtures.loadTransaction(fields: ["transactionId": "foobar"]), Fixtures.loadTransaction(fields: ["transactionId": "foobiz"])])!)
        let paginator: Paginator<Transaction> = user.getUserTransactions()

        paginator.getNext().catch(execute: { (error: Error) in
            XCTFail("User test: get next transactions error.")
        })

        let firstRequestHeaders = (user.adapter as? MockRestAdapter)!.headers

        paginator.getNext().catch(execute: { (error: Error) in
            XCTFail("User test: get next transactions error.")
        })

        let secondRequestHeaders = (user.adapter as? MockRestAdapter)!.headers

        XCTAssertEqual(firstRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!.count, 1, "Failed: Wrong number of headers.")
        XCTAssertEqual(firstRequestHeaders!["Range"], "items=50-99", "Failed: Wrong number of headers.")
        XCTAssertEqual(secondRequestHeaders!["Range"], "items=100-149", "Failed: Wrong number of headers.")
    }

    func testUpdateShouldReturnTheUser() {
        let testExpectation = expectation(description: "User test: update user.")

        let user: User = Fixtures.loadUser(fields: ["username": "foobar"])
        user.adapter = MockRestAdapter(body: Mapper().toJSONString(user)!)

        user.update(updateFields: ["username": "foobar"]).then { (user: User) -> () in
            XCTAssertEqual(user.username, "foobar", "Failed: Wrong username.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("User test: update user error.")
        })

        wait()
    }

    func testUserMapperShouldReturnAUser() {
        let json: String = "{" +
            "\"username\": \"foobar\"," +
            "\"email\": \"foo@bar.org\"," +
            "\"firstName\": \"foo\"," +
            "\"lastName\": \"bar\"," +
            "\"name\": \"Foo Bar\"," +
            "\"country\": \"BAR\"," +
            "\"state\": \"FOO\"," +
            "\"currencies\": [" +
                "\"BTC\"," +
            "]," +
            "\"status\": \"ok\"," +
            "\"settings\": {" +
                "\"theme\": \"minimalistic\"," +
                "\"currency\": \"USD\"," +
                "\"hasNewsSubscription\": true," +
                "\"intl\": {" +
                    "\"language\": {" +
                        "\"locale\": \"en-US\"" +
                    "}," +
                    "\"dateTimeFormat\": {" +
                        "\"locale\": \"en-US\"" +
                    "}," +
                    "\"numberFormat\": {" +
                        "\"locale\": \"en-US\"" +
                    "}" +
                "}," +
                "\"otp\": {" +
                    "\"login\": {" +
                        "\"enabled\": false" +
                    "}," +
                    "\"transactions\": {" +
                        "\"send\": {" +
                            "\"enabled\": false" +
                        "}," +
                        "\"transfer\": {" +
                            "\"enabled\": true" +
                        "}," +
                        "\"withdraw\": {" +
                            "\"crypto\": {" +
                                "\"enabled\": true" +
                            "}" +
                        "}" +
                    "}" +
                "}" +
            "}" +
        "}"
        let user = Mapper<User>().map(JSONString: json)

        XCTAssertEqual(user!.country!, "BAR", "Failed: User country didn't match.")
        XCTAssertEqual(user!.currencies!.count, 1, "Failed: User currencies didn't match.")
        XCTAssertEqual(user!.currencies![0], "BTC", "Failed: User currencies didn't match.")
        XCTAssertEqual(user!.email!, "foo@bar.org", "Failed: User email didn't match.")
        XCTAssertEqual(user!.firstName!, "foo", "Failed: User first name didn't match.")
        XCTAssertEqual(user!.lastName!, "bar", "Failed: User last name didn't match.")
        XCTAssertEqual(user!.name!, "Foo Bar", "Failed: User name didn't match.")
        XCTAssertEqual(user!.settings!.currency!, "USD", "Failed: User settings currency didn't match.")
        XCTAssertTrue(user!.settings!.hasNewsSubscription!, "Failed: User settings hasNewsSubscription didn't match.")
        XCTAssertEqual(user!.settings!.intl!.dateTimeFormat!.locale!, "en-US", "Failed: User settings intl dateTimeFormat didn't match.")
        XCTAssertEqual(user!.settings!.intl!.language!.locale!, "en-US", "Failed: User settings intl language didn't match.")
        XCTAssertEqual(user!.settings!.intl!.numberFormat!.locale!, "en-US", "Failed: User settings intl numberFormat didn't match.")
        XCTAssertFalse(user!.settings!.otp!.login!.enabled!, "Failed: User settings otp login didn't match.")
        XCTAssertFalse(user!.settings!.otp!.transactions!.send!.enabled!, "Failed: User settings otp transactions send didn't match.")
        XCTAssertTrue(user!.settings!.otp!.transactions!.transfer!.enabled!, "Failed: User settings otp transactions transfer didn't match.")
        XCTAssertTrue(user!.settings!.otp!.transactions!.withdraw!.crypto!.enabled!, "Failed: User settings otp login didn't match.")
        XCTAssertEqual(user!.settings!.theme!, "minimalistic", "Failed: User settings theme didn't match.")
        XCTAssertEqual(user!.state!, "FOO", "Failed: User name didn't match.")
        XCTAssertEqual(user!.status!, "ok", "Failed: User name didn't match.")
        XCTAssertEqual(user!.username!, "foobar", "Failed: User name didn't match.")
    }

}
