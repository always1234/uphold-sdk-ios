import Foundation
import ObjectMapper

/// Authentication request model.
open class AuthenticationRequest: Mappable {

    /// The description for the authentication request.
    public private(set) final var description: String?

    /**
      Constructor.

      - parameter description: The description for the authentication request.
    */
    public init(description: String) {
        self.description = description
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
        self.description <- map["description"]
    }

}
