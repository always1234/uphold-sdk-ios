import Foundation
import PromiseKit
@testable import UpholdSdk

/// Mock token model.
open class MockToken: MockBaseModel {

    /// The bearer token.
    private(set) final var bearerToken: String?

    /**
      Constructor.
    */
    public override init() {
        super.init()
    }

    /**
      Constructor.

      - parameter bearerToken: The bearer token.
    */
    public init(bearerToken: String) {
        super.init()

        self.bearerToken = bearerToken
    }

    /**
      Gets the current user.

      - returns: A promise with the user.
    */
    open func getUser() -> Promise<User> {
        guard let _ = MockSessionManager.sharedInstance.getBearerToken() else {
            return Promise<User>(error: AuthenticationRequiredError(message: "Missing bearer authorization"))
        }

        return mockAdapter.buildResponse(request: mockAdapter.buildRequest(request: UserService.getUser()))
    }

}
