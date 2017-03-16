import Foundation
import ObjectMapper
import PromiseKit
import SwiftClient

/// User model.
open class User: BaseModel, Mappable {

    /// The user country.
    public private(set) final var country: String?

    /// The user's list of currencies.
    public private(set) final var currencies: [String]?

    /// The user email.
    public private(set) final var email: String?

    /// The user first name.
    public private(set) final var firstName: String?

    /// The user last name.
    public private(set) final var lastName: String?

    /// The user name.
    public private(set) final var name: String?

    /// The user's settings.
    public private(set) final var settings: UserSettings?

    /// The user state.
    public private(set) final var state: String?

    /// The user status.
    public private(set) final var status: String?

    /// The user username.
    public private(set) final var username: String?

    /**
      Constructor.

      - parameter country: The user country.
      - parameter currencies: The user list of currencies.
      - parameter email: The user email.
      - parameter firstName: The user first name.
      - parameter lastName: The user last name.
      - parameter name: The user name.
      - parameter settings: The user settings.
      - parameter state: The user state.
      - parameter status: The user status.
      - parameter username: The user username.
    */
    public init(country: String, currencies: [String], email: String, firstName: String, lastName: String, name: String, settings: UserSettings, state: String, status: String, username: String) {
        self.country = country
        self.currencies = currencies
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.name = name
        self.settings = settings
        self.state = state
        self.status = status
        self.username = username
    }

    // MARK: Required by the ObjectMapper.

    /**
      Constructor.

      - parameter map: Mapping data object.
    */
    required public init?(map: Map) {
    }

    /**
      Maps the JSON to the Object.

      - parameter map: The object to map.
    */
    open func mapping(map: Map) {
        self.country <- map["country"]
        self.currencies <- map["currencies"]
        self.email <- map["email"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
        self.name <- map["name"]
        self.settings <- map["settings"]
        self.state <- map["state"]
        self.status <- map["status"]
        self.username <- map["username"]
    }

    /**
      Creates a card to the user.

      - parameter cardRequest: The CardRequest with the information to create the card.

      - returns: A promise with the created card.
    */
    open func createCard(cardRequest: CardRequest) -> Promise<Card> {
        let request = self.adapter.buildRequest(request: UserCardService.createUserCard(cardRequest: Mapper().toJSON(cardRequest)))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Creates a contact for the user.

      - parameter contactRequest: The ContactRequest with the information to create the contact.

      - returns: A promise with the created contact.
     */
    open func createContact(contactRequest: ContactRequest) -> Promise<Contact> {
        let request = self.adapter.buildRequest(request: UserService.createContact(contactRequest: Mapper().toJSON(contactRequest)))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user accounts.

      - returns: A promise with the user accounts list.
    */
    open func getAccounts() -> Promise<[Account]> {
        let request = self.adapter.buildRequest(request: AccountsService.getUserAccounts())

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user account with the account id.

      - parameter accountId: The id of the account we want.

      - returns: A promise with the user account.
    */
    open func getAccountById(accountId: String) -> Promise<Account> {
        let request = self.adapter.buildRequest(request: AccountsService.getUserAccountById(accountId: accountId))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user balances.

      - returns: A promise with the user balance.
     */
    open func getBalances() -> Promise<[Currency]> {
        let request = self.adapter.buildRequest(request: UserService.getUserBalances())
        let balance: Promise<Balance> = self.adapter.buildResponse(request: request)

        return balance.then { (balance: Balance) -> Promise<[Currency]> in
            return Promise { fulfill, reject in
                var responseCurrencies: [Currency] = []

                guard let balances = balance.balances else {
                    reject(UnexpectedResponseError(message: "Balances should not be nil."))

                    return
                }

                guard let currencies = balances.currencies else {
                    reject(UnexpectedResponseError(message: "Currencies should not be nil."))

                    return
                }

                currencies.sorted(by: {$0.0 < $1.0}).forEach({ (currency: (String, Currency)) -> Void in
                    responseCurrencies.append(currency.1)
                })

                fulfill(responseCurrencies)
            }
        }
    }

    /**
      Gets the user balance by currency.

      - parameter currency: The currency to filter the balances.

      - returns: A promise with the user balance for the currency.
     */
    open func getBalanceByCurrency(currency: String) -> Promise<Currency> {
        let request = self.adapter.buildRequest(request: UserService.getUserBalances())
        let balance: Promise<Balance> = self.adapter.buildResponse(request: request)

        return balance.then { (balance: Balance) -> Promise<Currency> in
            return Promise { fulfill, reject in
                guard let balances = balance.balances else {
                    reject(UnexpectedResponseError(message: "Balances should not be nil."))

                    return
                }

                guard let currencies = balances.currencies else {
                    reject(UnexpectedResponseError(message: "Currencies should not be nil."))

                    return
                }

                guard let currency = currencies[currency] else {
                    reject(LogicError(code: nil, message: "Currency does not exist."))

                    return
                }

                fulfill(currency)
            }
        }
    }

    /**
      Gets user cards.

      - returns: A promise with the cards user list.
     */
    open func getCards() -> Promise<[Card]> {
        let request = self.adapter.buildRequest(request: UserCardService.getUserCards())

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user card with the card id.

      - parameter cardId: The id of the card we want.

      - returns: A promise with the card.
     */
    open func getCardById(cardId: String) -> Promise<Card> {
        let request = self.adapter.buildRequest(request: UserCardService.getUserCardById(cardId: cardId))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets current user’s cards on a given currency.

      - parameter currency: The currency to filter the cards.

      - returns: A promise with the list of cards.
     */
    open func getCardsByCurrency(currency: String) -> Promise<[Card]> {
        let request = self.adapter.buildRequest(request: UserCardService.getUserCards())
        let cards: Promise<[Card]> = self.adapter.buildResponse(request: request)

        return cards.then { (cards: [Card]) -> Promise<[Card]> in
            return Promise { fulfill, reject in
                let filteredCards = cards.filter {
                    $0.currency == currency
                }

                if (filteredCards.isEmpty) {
                    reject(LogicError(code: nil, message: "There are no cards in the given currency."))
                }

                fulfill(filteredCards)
            }
        }
    }

    /**
      Gets the user contacts.

      - returns: A promise with the list of user contacts.
     */
    open func getContacts() -> Promise<[Contact]> {
        let request = self.adapter.buildRequest(request: UserService.getUserContacts())

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user phones.

      - returns: A promise with the list of user phones.
     */
    open func getPhones() -> Promise<[Phone]> {
        let request = self.adapter.buildRequest(request: UserService.getUserPhones())

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the user total balance.

      - returns: A promise with the user balance.
     */
    open func getTotalBalances() -> Promise<UserBalance> {
        let request = self.adapter.buildRequest(request: UserService.getUserBalances())
        let balance: Promise<Balance> = self.adapter.buildResponse(request: request)

        return balance.then { (balance: Balance) -> Promise<UserBalance> in
            return Promise { fulfill, reject in
                guard let balances = balance.balances else {
                    reject(UnexpectedResponseError(message: "Balances should not be nil."))

                    return
                }

                fulfill(balances)
            }
        }
    }

    /**
      Gets the user transactions.

      - returns: A paginator with the user transactions.
     */
    open func getUserTransactions() -> Paginator<Transaction> {
        let request = self.adapter.buildRequest(request: UserService.getUserTransactions(range: Header.buildRangeHeader(start: Paginator<Transaction>.DEFAULT_START, end: Paginator<Transaction>.DEFAULT_OFFSET - 1)))

        let paginator: Paginator<Transaction> = Paginator(countClosure: { () -> Promise<Int> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: UserService.getUserTransactions(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Range header should not be nil."))

                            return
                        }

                        fulfill(count)
                    })
                }
            },
            elements: self.adapter.buildResponse(request: request),
            hasNextPageClosure: { (currentPage) -> Promise<Bool> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: UserService.getUserTransactions(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Range header should not be nil."))

                            return
                        }

                        fulfill((currentPage * Paginator<Transaction>.DEFAULT_OFFSET) < count)
                    })
                }
            },
            nextPageClosure: { (range) -> Promise<[Transaction]> in
                let request = self.adapter.buildRequest(request: UserService.getUserTransactions(range: range))
                let promise: Promise<[Transaction]> = self.adapter.buildResponse(request: request)

                return promise
            })

        return paginator
    }

    /**
      Updates the user.

      - parameter updateFields: The fields to update.

      - returns: A promise with the updated user.
     */
    open func update(updateFields: [String: Any]) -> Promise<User> {
        let request = self.adapter.buildRequest(request: UserService.updateUser(updatefields: updateFields))

        return self.adapter.buildResponse(request: request)
    }

}
