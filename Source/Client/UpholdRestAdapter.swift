import Foundation
import ObjectMapper
import PromiseKit
import SwiftClient

/// Uphold REST adapter.
open class UpholdRestAdapter {

    /**
      Constructor.
     */
    public init() {
    }

    /**
      Builds the HTTP request with the headers data.

      - parameter request: The HTTP request.

      - returns: The configured HTTP request.
    */
    open func buildRequest(request: Request) -> Request {
        guard let bearerToken = SessionManager.sharedInstance.getBearerToken() else {
            return request.set(headers: Header.getDefaultHeaders())
        }

        _ = request.set(headers: Header.getDefaultHeaders())

        return request.set(headers: Header.buildAuthorizationHeader(token: bearerToken))
    }

    /**
      Handles responses that should have empty bodies.

      - parameter request: The HTTP request.

      - returns: A promise of Response.
    */
    open func buildEmptyResponse(request: Request) -> Promise<Response> {
        return Promise { fulfill, reject in
            request.end(done: { (response: Response) -> Void in
                if (response.basicStatus != Response.BasicResponseType.ok) {
                    reject(UpholdClientErrorHandling.handleError(response: response))

                    return
                }

                if let body = response.text, !body.isEmpty {
                    reject(LogicError(code: nil, message: "Response body should be empty."))
                } else {
                    fulfill(response)
                }

                }, onError: { (error: Error) -> Void in
                    reject(error)
            })
        }
    }

    /**
      Maps the JSON from the HTTP response to a T object.

      - parameter request: The HTTP request.

      - returns: A promise of T object.
    */
    open func buildResponse<T: Mappable>(request: Request) -> Promise<T> {
        return Promise { fulfill, reject in
            request.end(done: { (response: Response) -> Void in
                if (response.basicStatus != Response.BasicResponseType.ok) {
                    reject(UpholdClientErrorHandling.handleError(response: response))

                    return
                }

                guard let body = response.text else {
                    reject(LogicError(code: nil, message: "Response body should not be empty."))

                    return
                }

                guard let object: T = Mapper<T>().map(JSONString: body) else {
                    reject(LogicError(code: nil, message: "Failed to map the JSON object."))

                    return
                }

                fulfill(object)
                }) { (error: Error) -> Void in
                    reject(error)
            }
        }
    }

    /**
      Maps the JSON from the HTTP response to an array of T object.

      - parameter request: The HTTP request.

      - returns: A promise of an array of T objects.
    */
    open func buildResponse<T: Mappable>(request: Request) -> Promise<[T]> {
        return Promise { fulfill, reject in
            request.end(done: { (response: Response) -> Void in
                if (response.basicStatus != Response.BasicResponseType.ok) {
                    reject(UpholdClientErrorHandling.handleError(response: response))

                    return
                }

                guard let body = response.text else {
                    reject(LogicError(code: nil, message: "Response body should not be empty."))

                    return
                }

                guard let object: [T] = Mapper<T>().mapArray(JSONString: body) else {
                    reject(LogicError(code: nil, message: "Failed to map the JSON object."))

                    return
                }

                fulfill(object)
                }) { (error: Error) -> Void in
                    reject(error)
            }
        }
    }

}
