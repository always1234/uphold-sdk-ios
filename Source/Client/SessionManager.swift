import Foundation
import KeychainSwift

/// Session manager.
open class SessionManager {

    /// The keychain key to access the bearer token.
    static let KEYCHAIN_TOKEN_KEY = "com.uphold.sdk.token"

    /// The singleton's shared instance.
    static let sharedInstance = SessionManager()

    /// Keychain access object.
    let keychain: KeychainSwift

    /// Queue to manage concurrency.
    let lockQueue: DispatchQueue

    /**
      Constructor.
     */
    private init() {
        self.keychain = KeychainSwift()
        self.lockQueue = DispatchQueue(label: GlobalConfigurations.BUNDLE_NAME, attributes: [])

        self.invalidateSession()
    }

    /**
      Gets the bearer token.

      - returns: The bearer token.
    */
    func getBearerToken() -> String? {
        guard let token = self.keychain.get(SessionManager.KEYCHAIN_TOKEN_KEY) else {
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
            self.keychain.set(token, forKey: SessionManager.KEYCHAIN_TOKEN_KEY)
        }
    }

    /**
      Deletes the bearer token from the keychain.
     */
    func invalidateSession() {
        _ = self.lockQueue.sync {
            self.keychain.delete(SessionManager.KEYCHAIN_TOKEN_KEY)
        }
    }

}
