import XCTest
import UpholdSdk

/// GlobalConfiguration unit tests using the production environment.
class GlobalConfigurationProductionTest: XCTestCase {

    func testUpholdApiUrlShouldReturnProductionApiUrl() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_API_URL, "https://api.uphold.com", "Failed: Wrong URL value.")
    }

    func testUpholdAuthorizationServerUrlShouldReturnProductionAuthorizationServerUrl() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_AUTHORIZATION_SERVER_URL, "https://uphold.com", "Failed: Wrong URL value.")
    }

    func testUpholdSdkVersionShouldReturnSdkVersion() {
        XCTAssertEqual(GlobalConfigurations.UPHOLD_SDK_VERSION, "0.2.1", "Failed: Wrong URL value.")
    }

}
