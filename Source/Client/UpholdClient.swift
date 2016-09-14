import Foundation
import PromiseKit
import SafariServices
import SwiftClient
import UIKit

/// Uphold client.
open class UpholdClient: Client {

    /// The SwiftLint rules that must be disabled.
    // swiftlint:disable force_try

    /// The Uphold user's token.
    open private(set) var token: Token

    /**
      Constructor.
     */
    public override init() {
        self.token = Token()

        super.init()

        _ = self.baseUrl(url: GlobalConfigurations.UPHOLD_API_URL)
    }

    /**
      Contructor.

      - parameter bearerToken: Authenticated user token.
     */
    public convenience init(bearerToken: String) {
        self.init()

        self.token = Token(bearerToken: bearerToken)

        if let token = token.bearerToken {
            SessionManager.sharedInstance.setBearerToken(token: token)
        }
    }

    /**
      Starts the authorization flow.

      - parameter applicationViewController: The application view controller where the Uphold connect flow starts.
      - parameter clientId: The client id.
      - parameter scopes: The permissions to request from the user.
      - parameter state: An unguessable, cryptographically secure random string used to protect against cross-site request forgery attacks.

      - returns: The authorization view controller presented modally.
    */
    open func beginAuthorization(applicationViewController: UIViewController, clientId: String, scopes: [String], state: String) -> AuthorizationViewController? {
        let url = String(format: "%@/authorize/%@?scope=%@&state=%@", GlobalConfigurations.UPHOLD_AUTHORIZATION_SERVER_URL, clientId, scopes.joined(separator: " "), state)

        /// This try forces a runtime exception whenever the URL is not valid after escaping it.
        let authorizationViewController = try! AuthorizationViewController(url: URLUtils.escapeURL(url: url), entersReaderIfAvailable: false)

        applicationViewController.present(authorizationViewController, animated: true, completion: nil)

        return authorizationViewController
    }

    /**
      Completes the authorization flow.

      - parameter authorizationViewController: The Uphold AuthorizationViewController.
      - parameter clientId: The client secret.
      - parameter clientSecret: The client id.
      - parameter grantType: The grant type.
      - parameter state: The state.
      - parameter uri: The uri returned by the delegate method called by the begin authorization flow.

      - returns: A promise with the AuthenticationResponse.
    */
    open func completeAuthorization(authorizationViewController: AuthorizationViewController, clientId: String, clientSecret: String, grantType: String, state: String, uri: URL) -> Promise<AuthenticationResponse> {
        let adapter = self.token.adapter

        authorizationViewController.dismiss(animated: true, completion: nil)

        guard let queryParameters = URLComponents(url: uri, resolvingAgainstBaseURL: false)?.queryItems, let stateParameter = queryParameters.filter({ parameter in parameter.name == "state" }).first, let responseState = stateParameter.value else {
            return Promise<AuthenticationResponse>(error: UnexpectedResponseError(message: "URL query parameter state should not be nil."))
        }

        if (responseState != state) {
            return Promise<AuthenticationResponse>(error: StateMatchError(message: "URL query parameter state does not match."))
        }

        guard let responseCode = queryParameters.filter({ parameter in parameter.name == "code" }).first, let code = responseCode.value else {
            return Promise<AuthenticationResponse>(error: UnexpectedResponseError(message: "URL query parameter code should not be nil."))
        }

        return adapter.buildResponse(request: adapter.buildRequest(request: OAuth2Service.requestToken(clientId: clientId, clientSecret: clientSecret, code: code, grantType: grantType)))
    }

    /**
      Gets the reserve object.

      - returns: The reserve object.
     */
    open func getReserve() -> Reserve {
        return Reserve()
    }

    /**
      Gets all the exchange rates for all currency pairs.

      - returns: A promise with all exchanges rates for all currency pairs.
     */
    open func getTickers() -> Promise<[Rate]> {
        let adapter = self.token.adapter

        return adapter.buildResponse(request: adapter.buildRequest(request: TickerService.getAllTickers()))
    }

    /**
      Gets all the exchange rates to a given currency.

      - parameter currency: The filter currency.

      - returns: A promise with all exchanges rates relative to a given currency.
     */
    open func getTickersByCurrency(currency: String) -> Promise<[Rate]> {
        let adapter = self.token.adapter

        return adapter.buildResponse(request: adapter.buildRequest(request: TickerService.getAllTickersByCurrency(currency: currency)))
    }

    /**
      Gets the current user.

      - returns: A promise with the user.
     */
    open func getUser() -> Promise<User> {
        return self.token.getUser()
    }

    /**
      Invalidates the client session.
    */
    open func invalidateSession() {
        SessionManager.sharedInstance.invalidateSession()
    }

}
