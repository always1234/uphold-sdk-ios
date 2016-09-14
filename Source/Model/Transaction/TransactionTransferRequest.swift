import Foundation
import ObjectMapper

/// Transaction destination request model.
open class TransactionTransferRequest: TransactionRequest {

    /// The destination of the transaction request.
    public private(set) final var destination: String?

    /**
      Constructor.

      - parameter denomination: The denomination of the transaction request.
      - parameter destination: The destination of the transaction request.
    */
    public init(denomination: TransactionDenominationRequest, destination: String) {
        super.init(denomination: denomination)

        self.destination = destination
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

        self.destination <- map["destination"]
    }

}
