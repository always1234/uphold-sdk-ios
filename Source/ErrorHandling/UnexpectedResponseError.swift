import Foundation
import SwiftClient

/// UnexpectedResponseError error.
open class UnexpectedResponseError: UpholdClientError {

    /**
      Constructor.

      - parameter message: The error message being shown to the user.
    */
    public init(message: String) {
        let info: [String: String] = ["Unexpected response error": message]

        super.init(code: nil, info: info, response: nil)
    }

}
