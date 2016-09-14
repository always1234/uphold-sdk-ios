import Foundation
import ObjectMapper

/// Transaction deposit request model.
open class TransactionDepositRequest: TransactionRequest {

    /// The origin of the transaction request in case of a deposit.
    public private(set) final var origin: String?

    /**
      Constructor.

      - parameter denomination: The denomination of the transaction request.
      - parameter origin: The origin of the transaction request in case of a deposit.
    */
    public init(denomination: TransactionDenominationRequest, origin: String) {
        super.init(denomination: denomination)

        self.origin = origin
    }

    // MARK: Required by the ObjectMapper.

    /**
      Constructor.

      - parameter map: Mapping data object.
    */
    required public init?(map: Map) {
        super.init(map: map)
    }

    /**
      Maps the JSON to the Object.

      - parameter map: The object to map.
    */
    open override func mapping(map: Map) {
        super.mapping(map: map)

        self.origin <- map["origin"]
    }

}
