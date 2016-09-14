import Foundation
import ObjectMapper

/// Currency model.
open class Currency: Mappable {

    /// The amount of the currency.
    public private(set) final var amount: String?

    /// The balance of the currency.
    public private(set) final var balance: String?

    /// The currency.
    public private(set) final var currency: String?

    /// The rate of the currency.
    public private(set) final var rate: String?

    /**
      Constructor.

      - parameter amount: The amount of the currency.
      - parameter balance: The balance of the currency.
      - parameter currency: The currency.
      - parameter rate: The rate of the currency.
    */
    public init(amount: String, balance: String, currency: String, rate: String) {
        self.amount = amount
        self.balance = balance
        self.currency = currency
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
        self.amount <- map["amount"]
        self.balance <- map["balance"]
        self.currency <- map["currency"]
        self.rate <- map["rate"]
    }

}
