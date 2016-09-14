import Foundation
import ObjectMapper

/// Rate model.
open class Rate: Mappable {

    /// The rate ask.
    public private(set) final var ask: String?

    /// The rate bid.
    public private(set) final var bid: String?

    /// The rate currency.
    public private(set) final var currency: String?

    /// The rate pair.
    public private(set) final var pair: String?

    /**
      Constructor.

      - parameter ask: The rate ask.
      - parameter bid: The rate bid.
      - parameter currency: The rate currency.
      - parameter pair: The rate pair.
    */
    public init(ask: String, bid: String, currency: String, pair: String) {
        self.ask = ask
        self.bid = bid
        self.currency = currency
        self.pair = pair
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
        ask  <- map["ask"]
        bid <- map["bid"]
        currency <- map["currency"]
        pair <- map["pair"]
    }

}
