import Foundation
import SwiftClient

/// Authentication required error.
open class AuthenticationRequiredError: UpholdClientError {

    /**
      Constructor.

      - parameter message: The error message being shown to the user.
    */
    public init(message: String) {
        let info: [String: String] = ["Authentication required error": message]

        super.init(code: nil, info: info, response: nil)
    }

}
