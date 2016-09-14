import Foundation
import SwiftClient

/// OAuth2 service.
open class OAuth2Service {

    /**
      Performs a request to get a user access token.

      - parameter clientId: The client id.
      - parameter clientSecret: The client secret.
      - parameter code: The code from the authorize.
      - parameter grantType: The grant type.

      - returns: A request to get the bearer token.
    */
    static func requestToken(clientId: String, clientSecret: String, code: String, grantType: String) -> Request {
        return UpholdClient().post(url: "/oauth2/token").auth(username: clientId, password: clientSecret).send(data: String(format: "code=%@", code)).send(data: String(format: "grant_type=%@", grantType))
    }

}
