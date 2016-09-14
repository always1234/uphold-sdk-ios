import Foundation
import SwiftClient

/// LogicError error.
open class LogicError: UpholdClientError {

    /**
      Constructor.

      - parameter code: The HTTP status code.
      - parameter message: The error message being shown to the user.
    */
    public init(code: Int?, message: String) {
        let info: [String: String] = ["Logic error": message]

        super.init(code: code, info: info, response: nil)
    }

}
