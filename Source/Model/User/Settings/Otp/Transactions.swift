import Foundation
import ObjectMapper

/// Transactions otp settings model.
open class Transactions: Mappable {

    /// The send transactions otp settings.
    public private(set) final var send: Send?

    /// The transfer transactions otp settings.
    public private(set) final var transfer: Transfer?

    /// The withdraw transactions otp settings.
    public private(set) final var withdraw: Withdraw?

    /**
      Constructor.

      - parameter send: The send transactions otp settings.
      - parameter transfer: The transfer transactions otp settings.
      - parameter withdraw: The withdraw transactions otp settings.
    */
    public init(send: Send, transfer: Transfer, withdraw: Withdraw) {
        self.send = send
        self.transfer = transfer
        self.withdraw = withdraw
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
        self.send <- map["send"]
        self.transfer <- map["transfer"]
        self.withdraw <- map["withdraw"]
    }

}
