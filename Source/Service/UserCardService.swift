import Foundation
import SwiftClient

/// UserCard service.
open class UserCardService {

    /**
      Creates a request to cancel a transaction.

      - parameter cardId: The id of the card.
      - parameter transactionId: The id of the transaction.

      - returns: A request to cancel the transaction.
    */
    static func cancelTransaction(cardId: String, transactionId: String) -> Request {
        return UpholdClient().post(url: String(format: "/v0/me/cards/%@/transactions/%@/cancel", cardId, transactionId))
    }

    /**
      Creates a new address for the card.

      - parameter cardId: The card id.
      - parameter addressRequest: The card address request information.

      - returns: A request to create a card.
    */
    static func createCardAddress(cardId: String, addressRequest: Any) -> Request {
        return UpholdClient().post(url: String(format: "/v0/me/cards/%@/addresses", cardId)).send(data: addressRequest)
    }

    /**
      Creates a request to confirm a transaction.

      - parameter cardId: The id of the card.
      - parameter otp: the otp code to confirm the transaction.
      - parameter transactionId: The id of the transaction.
      - parameter transactionCommitRequest: The transaction commit information.

      - returns: A request to confirm the transaction.
    */
    static func confirmTransaction(cardId: String, otp: String?, transactionId: String, transactionCommitRequest: Any?) -> Request {
        let request = UpholdClient().post(url: String(format: "/v0/me/cards/%@/transactions/%@/commit", cardId, transactionId))

        guard let guardedOtp = otp, let guardedTransactionCommitRequest = transactionCommitRequest else {
            if let otp = otp {
                return request.set(key: "X-Bitreserve-OTP", value: otp)
            } else if let transactionCommitRequest = transactionCommitRequest {
                return request.send(data: transactionCommitRequest)
            }

            return request
        }

        return request.set(key: "X-Bitreserve-OTP", value: guardedOtp).send(data: guardedTransactionCommitRequest)
    }

    /**
      Creates a request to create a transaction.

      - parameter cardId: The id of the card.
      - parameter commit: A boolean to indicate if it is to commit the transaction on the creation process.
      - parameter transactionRequest: The transaction request.

      - returns: A request to create a transaction.
    */
    static func createTransaction(cardId: String, commit: Bool, transactionRequest: Any) -> Request {
        return UpholdClient().post(url: String(format: "/v0/me/cards/%@/transactions", cardId)).query(query: ["commit": commit ? "true" : "false"]).send(data: transactionRequest)
    }

    /**
      Creates a request to create a card.

      - parameter cardRequest: The card request.

      - returns: A request to create a card.
    */
    static func createUserCard(cardRequest: Any) -> Request {
        return UpholdClient().post(url: "/v0/me/cards").send(data: cardRequest)
    }

    /**
      Creates a request to get the user's card by id.

      - parameter cardId: The id of the card.

      - returns: A request to create a transaction.
    */
    static func getUserCardById(cardId: String) -> Request {
        return UpholdClient().get(url: String(format: "/v0/me/cards/%@", cardId))
    }

    /**
      Creates a request to get the user cards.

      - returns: A request to get the user cards.
    */
    static func getUserCards() -> Request {
        return UpholdClient().get(url: "/v0/me/cards")
    }

    /**
      Creates a request to get the list of transactions for a card.

      - parameter cardId: The id of the card.
      - parameter range: The range of the request.

      - returns: A request to get the list of transactions for a card.
    */
    static func getUserCardTransactions(cardId: String, range: String) -> Request {
        return UpholdClient().get(url: String(format: "/v0/me/cards/%@/transactions", cardId)).set(key: "Range", value: range)
    }

    /**
      Creates a request to update the card.

      - parameter cardId: The id of the card.
      - parameter updateFields: The card fields to update.

      - returns: A request to update a card.
    */
    static func updateCard(cardId: String, updateFields: Any) -> Request {
        return UpholdClient().patch(url: String(format: "/v0/me/cards/%@", cardId)).send(data: updateFields)
    }

}
