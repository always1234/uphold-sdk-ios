import Foundation
import SwiftClient

/// Base model.
open class BaseModel {

    /// The Uphold REST adapter.
    public internal(set) final var adapter: UpholdRestAdapter

    /**
      Constructor.
     */
    init() {
        self.adapter = UpholdRestAdapter()
    }

}
