import XCTest

/// Uphold asynchronous test classe's super class
class UpholdTestCase: XCTestCase {

    func wait() {
        waitForExpectations(timeout: 5, handler: { error in
            if let error = error {
                print(String(format:"Test timed out with error: %@.", error as CVarArg))
            }
        })
    }

}
