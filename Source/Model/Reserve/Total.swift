import Foundation
import ObjectMapper

/// Total model.
open class Total: Mappable {

    /// The assets from the corresponding holding.
    public private(set) final var assets: String?

    /// The commission from the corresponding holding.
    public private(set) final var commissions: String?

    /// The liabilities from the corresponding holding.
    public private(set) final var liabilities: String?

    /// The transactions from the corresponding holding.
    public private(set) final var transactions: String?

    /**
      Constructor.

      - parameter assets: The assets from the corresponding holding.
      - parameter commissions: The commission from the corresponding holding.
      - parameter liabilities: The liabilities from the corresponding holding.
      - parameter transactions: The transactions from the corresponding holding.
    */
    public init(assets: String, commissions: String, liabilities: String, transactions: String) {
        self.assets = assets
        self.commissions = commissions
        self.liabilities = liabilities
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
        self.assets <- map["assets"]
        self.commissions <- map["commissions"]
        self.liabilities <- map["liabilities"]
        self.transactions <- map["transactions"]
    }

}
