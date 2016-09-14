import Foundation
import SafariServices
import UIKit

/// Uphold authorization view controller.
open class AuthorizationViewController: SFSafariViewController {

    /**
      Constructor.

      - parameter URL: The authorization URL.
      - parameter entersReaderIfAvailable: A boolean that defines if reader mode should be entered automatically when it is available for the webpage.
    */
    override init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
    }

}
