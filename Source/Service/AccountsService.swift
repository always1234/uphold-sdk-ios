import Foundation
import SwiftClient

/// Accounts service.
open class AccountsService {

    /**
      Gets an user account.

      - parameter accountId: The account id.

      - returns: A request to get an user account.
    */
    static func getUserAccountById(accountId: String) -> Request {
        return UpholdClient().get(url: String(format: "/v0/me/accounts/%@", accountId))
    }

    /**
      Gets the user's list of accounts.

      - returns: A request to get the user accounts.
    */
    static func getUserAccounts() -> Request {
        return UpholdClient().get(url: "/v0/me/accounts")
    }

}
