import Foundation
import SwiftClient

/// State match error.
open class StateMatchError: UpholdClientError {

    /**
      Constructor.

      - parameter message: The error message being shown to the user.
    */
    public init(message: String) {
        let info: [String: String] = ["State match response error": message]

        super.init(code: nil, info: info, response: nil)
    }

}
