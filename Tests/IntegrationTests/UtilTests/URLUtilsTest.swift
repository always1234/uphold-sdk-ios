import XCTest
import UpholdSdk

/// URL utils integration tests.
class URLUtilsTest: XCTestCase {

    /// The SwiftLint rules that must be disabled.
    // swiftlint:disable force_try

    func testEscapeShouldReturnEscapedURL() {
        let url = "https://foobar.com/foobiz=foo biz"

        XCTAssertNil(NSURL(string: url), "Failed: Wrong URL.")
        XCTAssertNotNil(try! URLUtils.escapeURL(url: url), "Failed: Escaping URL failed.")
    }

}
