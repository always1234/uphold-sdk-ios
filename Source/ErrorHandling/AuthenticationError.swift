import Foundation
import SwiftClient

/// AuthenticationError error.
open class AuthenticationError: UpholdClientError {

    /**
      Constructor.

      - parameter code: The HTTP status code.
      - parameter message: The error message being shown to the user.
      - parameter response: The HTTP response.
    */
    public init(code: Int, message: String, response: Response) {
        let info: [String: String] = ["Authentication error": message]

        super.init(code: code, info: info, response: response)
    }

}
