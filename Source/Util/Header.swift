import Foundation
import SwiftClient

/// Header util class.
open class Header {

    /**
      Builds the authorization header.

      - parameter token: The bearer token.

      - returns: The authorization header.
     */
    open static func buildAuthorizationHeader(token: String) -> [String: String] {
        return ["authorization": String(format: "Bearer %@", token)]
    }

    /**
      Builds a string with the range header.

     - parameter start: The position of the first element.
     - parameter end: The position of the last element.

     - returns: The string with the header value.
     */
    open static func buildRangeHeader(start: Int, end: Int) -> String {
        return String(format: "items=%i-%i", start, end)
    }

    /**
      Gets the default headers.

      - returns: The default headers.
    */
    open static func getDefaultHeaders() -> [String: String] {
        let headers: [String: String] = ["user-agent": String(format: "uphold-ios-sdk/%@ (%@)", GlobalConfigurations.UPHOLD_SDK_VERSION, GlobalConfigurations.SDK_GITHUB_URL)]

        return headers
    }

    /**
      Gets the rate limit value.

      - parameter headers: The response headers.

      - returns: The rate limit value.
    */
    open static func getRateLimitValue(headers: [String: String]) -> String? {
        guard let rateLimit = headers["x-ratelimit-limit"] else {
            return nil
        }

        return rateLimit
    }

    /**
      Gets the rate limit reset time.

      - parameter headers: The response headers.

      - returns: The rate limit reset time.
    */
    open static func getSecondsUntilRateLimitReset(headers: [String: String]) -> String? {
        guard let resetTime = headers["retry-after"] else {
            return nil
        }

        return resetTime
    }

    /**
      Gets the total number of the results available for the request.

      - parameter headers: The response headers.

      - returns: The total number of elements.
    */
    open static func getTotalNumberOfResults(headers: [String: String]) -> Int? {
        guard let contentRange = headers["content-range"] else {
            return nil
        }

        return NSString(string: contentRange.substring(from: contentRange.range(of: "/")!.upperBound)).integerValue
    }

}
