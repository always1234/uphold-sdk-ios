import Foundation
import ObjectMapper

/// Currency model.
open class UserBalance: Mappable {

    /// The list of the currencies.
    public private(set) final var currencies: [String: Currency]?

    /// The total of the balance.
    public private(set) final var total: String?

    /**
      Constructor.

      - parameter currencies: The list of the currencies.
      - parameter total: The total of the balance.
    */
    public init(currencies: [String: Currency], total: String) {
        self.currencies = currencies
        self.total = total
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
        self.currencies <- map["currencies"]
        self.total <- map["total"]
    }

}
