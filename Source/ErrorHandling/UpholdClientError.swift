import Foundation
import SwiftClient

/// UpholdClientError error.
open class UpholdClientError: Error, CustomStringConvertible {

    /// The HTTP status code.
    public final var code: Int?

    /// The description to be printed when a UpholdClientError occurs.
    public final var description: String {
        guard let message = info.values.first else {
            return "Unknown error"
        }

        return message
    }

    /// The error's information being shown to the user.
    public final let info: [String: String]

    /// The HTTP response.
    public final var response: Response?

    /**
      Constructor.

      - parameter code: The HTTP status code.
      - parameter info: The error's information being shown to the user.
      - parameter response: The HTTP response.
    */
    public init(code: Int?, info: [String: String], response: Response?) {
        self.code = code
        self.info = info
        self.response = response
    }

}
