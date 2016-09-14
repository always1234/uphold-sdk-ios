import Foundation
import SwiftClient

/// Reserve service.
open class ReserveService {

    /**
      Creates a request to get the reserve ledger.

      - parameter range: The range of the request.

      - returns: A request to get the reserve ledger.
    */
    static func getLedger(range: String) -> Request {
        return UpholdClient().get(url: "/v0/reserve/ledger").set(key: "Range", value: range)
    }

    /**
      Creates a request to get a reserve transaction.

      - parameter transactionId: The id of the transaction.

      - returns: A request to get a reserve transaction.
    */
    static func getReserveTransactionById(transactionId: String) -> Request {
        return UpholdClient().get(url: String(format: "/v0/reserve/transactions/%@", transactionId))
    }

    /**
      Creates a request to get the reserve transactions.

      - parameter range: The range of the request.

      - returns: A request to get the reserve transactions.
    */
    static func getReserveTransactions(range: String) -> Request {
        return UpholdClient().get(url: "/v0/reserve/transactions").set(key: "Range", value: range)
    }

    /**
      Creates a request to get the reserve statistics.

      - returns: A request to get the reserve statistics.
    */
    static func getStatistics() -> Request {
        return UpholdClient().get(url: "/v0/reserve/statistics")
    }

}
