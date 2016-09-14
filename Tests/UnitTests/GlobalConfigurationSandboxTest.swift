import XCTest
import UpholdSdk

/// GlobalConfiguration unit tests using the sandbox environment.
class GlobalConfigurationSandboxTest: XCTestCase {

    func testUpholdApiUrlShouldReturnSandboxApiUrl() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_API_URL, "https://api-sandbox.uphold.com", "Failed: Wrong URL value.")
    }

    func testUpholdAuthorizationServerUrlShouldReturnSandboxAuthorizationServerUrl() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_AUTHORIZATION_SERVER_URL, "https://sandbox.uphold.com", "Failed: Wrong URL value.")
    }

    func testUpholdSdkVersionShouldReturnSdkVersion() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_SDK_VERSION, "0.2.1", "Failed: Wrong URL value.")
    }

}
