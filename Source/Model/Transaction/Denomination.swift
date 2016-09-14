import Foundation
import ObjectMapper

/// Denomination model.
open class Denomination: Mappable {

    /// The amount of the transaction.
    public private(set) final var amount: String?

    /// The currency of the transaction.
    public private(set) final var currency: String?

    /// The pair of the transaction.
    public private(set) final var pair: String?

    /// The rate of the transaction.
    public private(set) final var rate: String?

    /**
      Constructor.

      - parameter amount: The amount of the transaction.
      - parameter currency: The currency of the transaction.
      - parameter pair: The pair of the transaction.
      - parameter rate: The rate of the transaction.
    */
    public init(amount: String, currency: String, pair: String, rate: String) {
        self.amount = amount
        self.currency = currency
        self.pair = pair
        self.rate = rate
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
        amount  <- map["amount"]
        currency <- map["currency"]
        pair <- map["pair"]
        rate <- map["rate"]
    }

}
