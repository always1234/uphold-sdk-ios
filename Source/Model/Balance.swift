import Foundation
import ObjectMapper

/// Balance model.
open class Balance: Mappable {

    /// The user balance.
    public private(set) final var balances: UserBalance?

    /**
      Constructor.

      - parameter balances: The user balance.
    */
    public init(balances: UserBalance) {
        self.balances = balances
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
        self.balances <- map["balances"]
    }

}
