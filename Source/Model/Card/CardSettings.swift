import Foundation
import ObjectMapper

/// CardSettings model.
open class CardSettings: Mappable {

    /// The position of the card.
    public private(set) final var position: Int?

    /// A boolean indicating if the card is starred.
    public private(set) final var starred: Bool?

    /**
      Constructor.

      - parameter position: The position of the card.
      - parameter starred: A boolean indicating if the card is starred.
    */
    public init(position: Int, starred: Bool) {
        self.position = position
        self.starred = starred
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
        position  <- map["position"]
        starred <- map["starred"]
    }

}
