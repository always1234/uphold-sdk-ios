import XCTest
import UpholdSdk
import ObjectMapper


class RateTest: XCTestCase {

    func testRateMapperShouldReturnARate() {
        let rate = Mapper<Rate>().map(JSONString: "{\"ask\":\"1\",\"bid\":\"1\",\"currency\":\"BTC\",\"pair\":\"BTCBTC\"}")

        XCTAssertEqual(rate!.ask!, "1", "Failed: Ask didn't match.")
        XCTAssertEqual(rate!.bid!, "1", "Failed: Bid didn't match.")
        XCTAssertEqual(rate!.currency!, "BTC", "Failed: Currency didn't match.")
        XCTAssertEqual(rate!.pair!, "BTCBTC", "Failed: Pair didn't match.")
    }

}
