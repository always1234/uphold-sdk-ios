import Foundation
import SwiftClient

/// Uphold client error handling.
open class UpholdClientErrorHandling {

    /**
      Handles the uphold client errors.

      - parameter response: The response type object obtained when ending a request.

      - returns: The UpholdClientError child for each ResponseType.
    */
    open static func handleError(response: Response) -> UpholdClientError {
        switch (response.status) {

            case Response.ResponseType.badRequest:
                return BadRequestError(code: 400, message: "HTTP error 400 - Bad request.", response: response)

            case Response.ResponseType.unauthorized:
                return AuthenticationError(code: 401, message: "HTTP error 401 - Unauthorized.", response: response)

            case Response.ResponseType.notFound:
                return NotFoundError(code: 404, message: String(format: "HTTP error 404 - Object or route not found: %@.", response.request.url), response: response)

            case Response.ResponseType.preConditionFail:
                return BadRequestError(code: 412, message: "HTTP error 412 - Precondition failed.", response: response)

            case Response.ResponseType.authenticationTimeout:
                return BadRequestError(code: 419, message: "HTTP error 419 - Requested range not satisfiable.", response: response)

            case Response.ResponseType.tooManyRequests:
                return ApiLimitExceedError(code: 429, message: String(format: "HTTP error 429 - You have exceeded Uphold's API rate limit of %@ requests. Current time window ends in %@ seconds.", Header.getRateLimitValue(headers: response.headers)!, Header.getSecondsUntilRateLimitReset(headers: response.headers)!), response: response)

            default:
                return UnhandledError(code: nil, message: "Invalid status code.", response: response)

        }
    }

}
