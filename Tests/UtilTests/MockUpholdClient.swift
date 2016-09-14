import Foundation
import UIKit
import PromiseKit
@testable import UpholdSdk

/// Mock uphold client.
open class MockUpholdClient: UpholdClient {

    /// The mock uphold user's token.
    open private(set) var mockToken: MockToken

    /**
      Constructor.
    */
    public override init() {
        self.mockToken = MockToken()

        super.init()

        _ = self.baseUrl(url: GlobalConfigurations.UPHOLD_API_URL)
    }

    /**
      Contructor.

      - parameter bearerToken: Authenticated user token.
    */
    public convenience init(bearerToken: String) {
        self.init()

        self.mockToken = MockToken(bearerToken: bearerToken)

        if let mockToken = self.mockToken.bearerToken {
            MockSessionManager.sharedInstance.setBearerToken(token: mockToken)
        }
    }

    /**
      Gets the current user.

      - returns: A promise with the user.
    */
    override open func getUser() -> Promise<User> {
        return self.mockToken.getUser()
    }

    /**
      Invalidates the mock client session.
    */
    override open func invalidateSession() {
        MockSessionManager.sharedInstance.invalidateSession()
    }

}
