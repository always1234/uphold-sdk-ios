import Foundation
import ObjectMapper

/// Fee model.
open class Fee: Mappable {

    /// The amount.
    public private(set) final var amount: String?

    /// The currency.
    public private(set) final var currency: String?

    /// The percentage.
    public private(set) final var percentage: String?

    /// The target.
    public private(set) final var target: String?

    /// The type.
    public private(set) final var type: String?

    /**
      Constructor.

      - parameter amount: The amount.
      - parameter currency: The currency.
      - parameter percentage: The percentage.
      - parameter target: The target.
      - parameter type: The type.
    */
    public init(amount: String, currency: String, percentage: String, target: String, type: String) {
        self.amount = amount
        self.currency = currency
        self.percentage = percentage
        self.target = target
        self.type = type
    }

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
        amount <- map["amount"]
        currency <- map["currency"]
        percentage <- map["percentage"]
        target <- map["target"]
        type <- map["type"]
    }

}
