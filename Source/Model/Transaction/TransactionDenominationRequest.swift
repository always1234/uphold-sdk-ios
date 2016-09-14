import Foundation
import ObjectMapper

/// Transaction denomination request model.
open class TransactionDenominationRequest: Mappable {

    /// The amount of the transaction request.
    public private(set) final var amount: String?

    /// The currency of the transaction request.
    public private(set) final var currency: String?

    /**
      Constructor.

      - parameter amount: The amount of the transaction request.
      - parameter currency: The currency of the transaction request.
    */
    public init(amount: String, currency: String) {
        self.amount = amount
        self.currency = currency
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
        self.amount <- map["amount"]
        self.currency <- map["currency"]
    }

}
