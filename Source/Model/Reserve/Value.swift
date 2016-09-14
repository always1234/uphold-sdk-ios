import Foundation
import ObjectMapper

/// Value model.
open class Value: Mappable {

    /// The quantity of assets held for the corresponding holding, but converted to a different currency.
    public private(set) final var assets: String?

    /// The currency we are computing the current holding in.
    public private(set) final var currency: String?

    /// The quantity of liabilities for the corresponding holding, but converted to a different currency.
    public private(set) final var liabilities: String?

    /// The rate we used when computing the holding to the corresponding currency.
    public private(set) final var rate: String?

    /**
      Constructor.

      - parameter assets: The quantity of assets held for the corresponding holding, but converted to a different currency.
      - parameter currency: The currency we are computing the current holding in.
      - parameter liabilities: The quantity of liabilities for the corresponding holding, but converted to a different currency.
      - parameter rate: The rate we used when computing the holding to the corresponding currency.
    */
    public init(assets: String, currency: String, liabilities: String, rate: String) {
        self.assets = assets
        self.currency = currency
        self.liabilities = liabilities
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
        self.assets <- map["assets"]
        self.currency <- map["currency"]
        self.liabilities <- map["liabilities"]
        self.rate <- map["rate"]
    }

}
