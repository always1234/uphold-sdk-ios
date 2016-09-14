import Foundation
import SwiftClient

/// User service.
open class UserService {

    /**
      Creates a request to create a contact.

      - parameter contactRequest: The request contact information.

      - returns: A request to create a contact.
    */
    static func createContact(contactRequest: Any) -> Request {
        return UpholdClient().post(url: "/v0/me/contacts").send(data: contactRequest)
    }

    /**
      Creates a request to get the user information.

      - returns: A request to get the user information.
    */
    static func getUser() -> Request {
        return UpholdClient().get(url: "/v0/me")
    }

    /**
      Creates a request to get the user balances.

      - returns: A request to get the user balances.
    */
    static func getUserBalances() -> Request {
        return UpholdClient().get(url: "/v0/me")
    }

    /**
      Creates a request to get the user contacts.

      - returns: A request to get the user contacts.
    */
    static func getUserContacts() -> Request {
        return UpholdClient().get(url: "/v0/me/contacts")
    }

    /**
      Creates a request to get the user phones.

      - returns: A request to get the user phones.
    */
    static func getUserPhones() -> Request {
        return UpholdClient().get(url: "/v0/me/phones")
    }

    /**
      Creates a request to get the user transactions.

      - parameter range: The request range.

      - returns: A request to get the user transactions.
    */
    static func getUserTransactions(range: String) -> Request {
        return UpholdClient().get(url: "/v0/me/transactions").set(key: "Range", value: range)
    }

    /**
      Creates a request to update the user information.

      - parameter updatefields: The fields to be updated.

      - returns: A request to update the user information.
    */
    static func updateUser(updatefields: Any) -> Request {
        return UpholdClient().patch(url: "/v0/me").send(data: updatefields)
    }

}
