import Foundation
import ObjectMapper

/// Source model.
open class Source: Mappable {

    /// The id of the source.
    public private(set) final var id: String?

    /// The amount of the source.
    public private(set) final var amount: String?

    /**
      Constructor.

      - parameter id: The id of the source.
      - parameter amount: The amount of the source.
    */
    public init(id: String, amount: String) {
        self.id = id
        self.amount = amount
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
        id  <- map["id"]
        amount <- map["amount"]
    }

}
