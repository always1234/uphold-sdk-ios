import Foundation

/// Configuration missing error.
open class ConfigurationMissingError: UpholdClientError {

    /**
      Constructor.

      - parameter message: The error message being shown to the user.
    */
    public init(message: String) {
        let info: [String: String] = ["Configuration missing error": message]

        super.init(code: nil, info: info, response: nil)
    }

}
