import Foundation
import KeychainSwift
import UpholdSdk

/// Mock session manager.
open class MockSessionManager {

    /// The singleton's shared instance.
    static let sharedInstance = MockSessionManager()

    /// The mocked keychain key to access the bearer token.
    private static let MOCK_KEYCHAIN_TOKEN_KEY: String = "com.uphold.sdk.mock.token"

    /// The mocked keychain access object.
    let keychain: MockKeychain

    /// Queue to manage concurrency.
    let lockQueue: DispatchQueue

    /**
      Constructor.
    */
    init() {
        self.keychain = MockKeychain()
        self.lockQueue = DispatchQueue(label: GlobalConfigurations.BUNDLE_NAME, attributes: [])

        self.invalidateSession()
    }

    /**
      Gets the bearer token.

      - returns: The bearer token.
    */
    func getBearerToken() -> String? {
        guard let token = self.keychain.get(key: MockSessionManager.MOCK_KEYCHAIN_TOKEN_KEY) else {
            return nil
        }

        return token
    }

    /**
      Sets the bearer token.

      - parameter token: The bearer token.
    */
    func setBearerToken(token: String) {
        self.invalidateSession()

        _ = self.lockQueue.sync {
            self.keychain.set(token: token, key: MockSessionManager.MOCK_KEYCHAIN_TOKEN_KEY)
        }
    }

    /**
      Deletes the bearer token from the keychain.
    */
    func invalidateSession() {
        _ = self.lockQueue.sync {
            self.keychain.delete(key: MockSessionManager.MOCK_KEYCHAIN_TOKEN_KEY)
        }
    }
}
