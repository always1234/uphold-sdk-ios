import PromiseKit
import UIKit
import UpholdSdk

/// Logged in user view controller.
class UserViewController: UIViewController {

    @IBOutlet weak var authenticatedLabel: UILabel!

    var bearerToken: String?
    var user: User?

    /**
      Presents the user's first name and the total number of cards.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let bearerToken = self.bearerToken else {
            self.handleError()

            return
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        self.authenticatedLabel.text = String(NSLocalizedString("user-view-controller.fetching-data", comment: "Fetching data."))

        /// Instantiate UpholdClient with the bearer token.
        let client = UpholdClient(bearerToken: bearerToken)

        client.getUser().always { () -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }.then { (user: User) -> Promise<[Card]> in
            self.user = user

            return user.getCards()
        }.then { (cards: [Card]) -> () in
            guard let user = self.user, let firstName = user.firstName else {
                return
            }

            self.authenticatedLabel.text = String(format: NSLocalizedString("user-view-controller.presenting-data", comment: "Presenting data."), firstName, cards.count)
        }.catch(execute: { (error: Error) in
            self.handleError()
        })
    }

    /**
      Handles login errors.
    */
    func handleError() {
        let alertController = UIAlertController(title: String(NSLocalizedString("user-view-controller.alert-title-fetching-error", comment: "Fetching error.")), message: String(NSLocalizedString("global.unknown-error", comment: "Something went wrong.")), preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: String(NSLocalizedString("global.dismiss", comment: "Dismiss.")), style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
