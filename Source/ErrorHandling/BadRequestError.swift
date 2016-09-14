import Foundation
import SwiftClient

/// BadRequestError error.
open class BadRequestError: UpholdClientError {

    /**
      Constructor.

      - parameter code: The HTTP status code.
      - parameter message: The error message being shown to the user.
      - parameter response: The HTTP response.
    */
    public init(code: Int, message: String, response: Response) {
        let info: [String: String] = ["Bad request error": message]

        super.init(code: code, info: info, response: response)
    }

}
