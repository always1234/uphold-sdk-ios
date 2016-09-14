import Foundation
import UpholdSdk

/// Mock base model.
open class MockBaseModel {

    /// The mock uphold REST adapter.
    public internal(set) final var mockAdapter: MockRestAdapter

    /**
      Constructor.
    */
    init() {
        self.mockAdapter = MockRestAdapter()
    }

}
