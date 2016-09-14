import UIKit

/// Application delegate.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
      Handles the application launch.

      - parameter application: Singleton application object.
      - parameter launchOptions: A dictionary indicating the reason the app was launched (if any).

      - returns: A boolean indicating if the application was launch successfully.
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        guard let window = self.window else {
            return false
        }

        window.rootViewController = LoginViewController()
        window.makeKeyAndVisible()

        return true
    }

    /**
      Handles the callback URL to complete the authorization process.

      - parameter application: Singleton application object.
      - parameter url: The callback URL.
      - parameter options: A dictionary of launch options.

      - returns: A boolean indicating if the application can handle the URL resource or continue a user activity.
    */
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        guard let window = self.window, let rootViewController = window.rootViewController, let loginViewController = rootViewController as? LoginViewController else {
            return false
        }

        loginViewController.completeAuthorization(url)

        return true
    }

}
