import Foundation
import UpholdSdk

/// Mock keychain.
open class MockKeychain {

    /**
      Deletes the token for a given key from the mock keychain.
    */
    func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    /**
      Gets the token for a given key from the mock keychain.

      - returns: The bearer token.
    */
    func get(key: String) -> String? {
        let token = UserDefaults.standard.value(forKey: key) as? String

        return token
    }

    /**
      Sets the token with a given key in the mock keychain.
    */
    func set(token: String, key: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

}
