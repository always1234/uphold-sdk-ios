import Foundation
import ObjectMapper

/// ReserveStatistics model.
open class ReserveStatistics: Mappable {

    /// The currency from the reserve.
    public private(set) final var currency: String?

    /// The commissions, transaction volume, assets and liabilities.
    public private(set) final var totals: Total?

    /// The value of held in the associated currency in all supported forms.
    public private(set) final var values: [Value]?

    /**
      Constructor.

      - parameter currency: The currency from the reserve.
      - parameter totals: The commissions, transaction volume, assets and liabilities.
      - parameter values: The value of held in the associated currency in all supported forms.
    */
    public init(currency: String, totals: Total, values: [Value]) {
        self.currency = currency
        self.totals = totals
        self.values = values
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
        self.currency <- map["currency"]
        self.totals <- map["totals"]
        self.values <- map["values"]
    }

}
