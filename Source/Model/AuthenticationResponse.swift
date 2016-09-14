import Foundation
import ObjectMapper

/// Authentication response model.
open class AuthenticationResponse: Mappable {

    /// The user access token.
    public private(set) final var accessToken: String?

    /// The expiration date from the token.
    public private(set) final var expiresIn: Int?

    /// The token access permissions.
    public private(set) final var scope: String?

    /// The description from the authentication response.
    public private(set) final var tokenType: String?

     /**
       Constructor.

       - parameter accessToken: The user access token.
       - parameter expiresIn: The expiration date from the token.
       - parameter scope: The token access permissions.
       - parameter tokenType: The description from the authentication response.
    */
    public init(accessToken: String, expiresIn: Int, scope: String, tokenType: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.scope = scope
        self.tokenType = tokenType
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
        self.accessToken <- map["access_token"]
        self.expiresIn <- map["expires_in"]
        self.scope <- map["scope"]
        self.tokenType <- map["token_type"]
    }

}
