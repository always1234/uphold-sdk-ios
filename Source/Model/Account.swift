import Foundation
import ObjectMapper

/// Account model.
open class Account: Mappable {

    /// The currency.
    public private(set) final var currency: String?

    /// The id.
    public private(set) final var id: String?

    /// The label.
    public private(set) final var label: String?

    /// The status.
    public private(set) final var status: String?

    /// The type.
    public private(set) final var type: String?

    /**
      Constructor.

      - parameter currency: The currency.
      - parameter id: The id.
      - parameter label: The label.
      - parameter status: The status.
      - parameter type: The type.
    */
    public init(currency: String, id: String, label: String, status: String, type: String) {
        self.currency = currency
        self.id = id
        self.label = label
        self.status = status
        self.type = type
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
        self.id <- map["id"]
        self.label <- map["label"]
        self.status <- map["status"]
        self.type <- map["type"]
    }

}
