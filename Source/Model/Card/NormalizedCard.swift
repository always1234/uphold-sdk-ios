import Foundation
import ObjectMapper

/// Card normalized model.
open class NormalizedCard: Mappable {

    /// The amount available normalized.
    public private(set) final var available: String?

    /// The balance available normalized.
    public private(set) final var balance: String?

    /// The currency used in the normalization.
    public private(set) final var currency: String?

    /**
      Constructor.

      - parameter available: The amount available normalized.
      - parameter balance: The balance available normalized.
      - parameter currency: The currency used in the normalization.
    */
    public init(available: String, balance: String, currency: String) {
        self.available = available
        self.balance = balance
        self.currency = currency
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
        available  <- map["available"]
        balance <- map["balance"]
        currency <- map["currency"]
    }

}
