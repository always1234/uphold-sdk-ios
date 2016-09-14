import XCTest
@testable import SwiftClient
@testable import UpholdSdk

/// OAuth2 service integration tests.
class OAuth2ServiceTest: XCTestCase {

    func testRequestTokenShouldReturnTheToken() {
        let request = OAuth2Service.requestToken(clientId: "foo", clientSecret: "bar", code: "foobar", grantType: "foobiz")
        let loginData: Data = "foo:bar".data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: [])

        XCTAssertEqual(request.url, String(format: "%@/oauth2/token", GlobalConfigurations.UPHOLD_API_URL), "Failed: Wrong URL.")
        XCTAssertEqual(request.headers["authorization"], String(format: "Basic %@", base64LoginString), "Failed: Wrong method.")
        XCTAssertEqual(request.method, "POST", "Failed: Wrong method.")
        XCTAssertEqual(request.data! as? String, "code=foobar&grant_type=foobiz", "Failed: Wrong body.")
    }

}
