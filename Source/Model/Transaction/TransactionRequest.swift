import Foundation
import ObjectMapper

/// Transaction request model.
open class TransactionRequest: Mappable {

    /// The denomination of the transaction request.
    public private(set) final var denomination: TransactionDenominationRequest?

    /**
      Constructor.

      - parameter denomination: The denomination of the transaction request.
    */
    public init(denomination: TransactionDenominationRequest) {
        self.denomination = denomination
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
        self.denomination <- map["denomination"]
    }

}
