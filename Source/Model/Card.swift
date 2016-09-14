import Foundation
import ObjectMapper
import PromiseKit
import SwiftClient

/// Card model.
open class Card: BaseModel, Mappable {

    /// The id of the card.
    public private(set) final var id: String?

    /// The card's primary address dictionary.
    public private(set) final var address: [String : String]?

    /// The balance available for withdrawal/usage.
    public private(set) final var available: String?

    /// The total balance of the card, including all pending transactions.
    public private(set) final var balance: String?

    /// The currency of the card.
    public private(set) final var currency: String?

    /// The display name of the card as chosen by the user.
    public private(set) final var label: String?

    /// A timestamp of the last time a transaction on this card was conducted.
    public private(set) final var lastTransactionAt: String?

    /// The list with the normalized fields.
    public private(set) final var normalized: [NormalizedCard]?

    /// The card settings.
    public private(set) final var settings: CardSettings?

    /**
      Constructor.

      - parameter id: The id of the card.
      - parameter address: The card's primary address dictionary.
      - parameter available: The balance available for withdrawal/usage.
      - parameter balance: The total balance of the card, including all pending transactions.
      - parameter currency: The currency of the card.
      - parameter label: The display name of the card as chosen by the user.
      - parameter lastTransactionAt: A timestamp of the last time a transaction on this card was conducted.
      - parameter normalized: The list with the normalized fields.
      - parameter settings: The Settings of the card.
    */
    public init(id: String, address: [String : String], available: String, balance: String, currency: String, label: String, lastTransactionAt: String?, normalized: [NormalizedCard], settings: CardSettings) {
        self.id = id
        self.address = address
        self.available = available
        self.balance = balance
        self.currency = currency
        self.label = label
        self.lastTransactionAt = lastTransactionAt
        self.normalized = normalized
        self.settings = settings
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
        self.id <- map["id"]
        self.address <- map["address"]
        self.available <- map["available"]
        self.balance <- map["balance"]
        self.currency <- map["currency"]
        self.label <- map["label"]
        self.lastTransactionAt <- map["lastTransactionAt"]
        self.normalized <- map["normalized"]
        self.settings <- map["settings"]
    }

    /**
      Creates an address to the card.

      - parameter addressRequest: The AddressRequest with the network of the address.

      - returns: A promise with the created address.
    */
    open func createAddress(addressRequest: AddressRequest) -> Promise<Address> {
        guard let id = self.id else {
            return Promise<Address>(error: UnexpectedResponseError(message: "Card id should not be nil."))
        }

        let request = self.adapter.buildRequest(request: UserCardService.createCardAddress(cardId: id, addressRequest: Mapper().toJSON(addressRequest)))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Creates a transaction.

      - parameter transactionRequest: The transaction request information.

      - returns: A promise with the transaction.
    */
    open func createTransaction(transactionRequest: TransactionRequest) -> Promise<Transaction> {
        return createTransaction(commit: false, transactionRequest: transactionRequest)
    }

    /**
      Creates a transaction.

      - parameter commit: A boolean to indicate if it is to commit the transaction on the creation process.
      - parameter transactionRequest: The transaction request information.

      - returns: A promise with the transaction.
    */
    open func createTransaction(commit: Bool, transactionRequest: TransactionRequest) -> Promise<Transaction> {
        guard let id = self.id else {
            return Promise<Transaction>(error: UnexpectedResponseError(message: "Card id should not be nil."))
        }

        let request = self.adapter.buildRequest(request: UserCardService.createTransaction(cardId: id, commit: commit, transactionRequest: Mapper().toJSON(transactionRequest)))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the transactions for the current card.

      - returns: A paginator with the list of transactions for the current card.
    */
    open func getTransactions() -> Paginator<Transaction> {
        guard let id = self.id else {
            let error = UnexpectedResponseError(message: "Card id should not be nil.")

            return Paginator<Transaction>(countClosure: { () -> Promise<Int> in
                    return Promise<Int>(error: error)
                },
                elements: Promise<[Transaction]>(error: error),
                hasNextPageClosure: { (currentPage) -> Promise<Bool> in
                    return Promise<Bool>(error: error)
                },
                nextPageClosure: { (range) -> Promise<[Transaction]> in
                    return Promise<[Transaction]>(error: error)
                })
        }

        let request = self.adapter.buildRequest(request: UserCardService.getUserCardTransactions(cardId: id, range: Header.buildRangeHeader(start: Paginator<Transaction>.DEFAULT_START, end: Paginator<Transaction>.DEFAULT_OFFSET - 1)))

        let paginator: Paginator<Transaction> = Paginator(countClosure: { () -> Promise<Int> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: UserCardService.getUserCardTransactions(cardId: id, range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill(count)
                    })
                }
            },
            elements: self.adapter.buildResponse(request: request),
            hasNextPageClosure: { (currentPage) -> Promise<Bool> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: UserCardService.getUserCardTransactions(cardId: id, range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill((currentPage * Paginator<Transaction>.DEFAULT_OFFSET) < count)
                    })
                }
            },
            nextPageClosure: { (range) -> Promise<[Transaction]> in
                let request = self.adapter.buildRequest(request: UserCardService.getUserCardTransactions(cardId: id, range: range))
                let promise: Promise<[Transaction]> = self.adapter.buildResponse(request: request)

                return promise
            })

        return paginator
    }

    /**
      Update the card information.

      - parameter updateFields: The card fields to update.

      - returns: A promise with the card updated.
    */
    open func update(updateFields: [String: Any]) -> Promise<Card> {
        guard let id = self.id else {
            return Promise<Card>(error: UnexpectedResponseError(message: "Card id should not be nil."))
        }

        let request = self.adapter.buildRequest(request: UserCardService.updateCard(cardId: id, updateFields: updateFields))

        return self.adapter.buildResponse(request: request)
    }

}
