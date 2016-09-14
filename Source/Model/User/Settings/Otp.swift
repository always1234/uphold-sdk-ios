import Foundation
import ObjectMapper

/// Otp settings model.
open class Otp: Mappable {

    /// The login otp settings.
    public private(set) final var login: Login?

    /// The transactions otp settings.
    public private(set) final var transactions: Transactions?

    /**
      Constructor.

      - parameter login: The login otp settings.
      - parameter transactions: The transactions otp settings.
    */
    public init(login: Login, transactions: Transactions) {
        self.login = login
        self.transactions = transactions
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
        self.login <- map["login"]
        self.transactions <- map["transactions"]
    }

}
