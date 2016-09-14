import Foundation

/// MalformedUrlError error.
open class MalformedUrlError: UpholdClientError {

    /**
      Constructor.

      - parameter message: The error message being shown to the user.
    */
    public init(message: String) {
        let info: [String: String] = ["Malformed URL error": message]

        super.init(code: nil, info: info, response: nil)
    }

}
