import XCTest
import PromiseKit
@testable import UpholdSdk

/// Paginator integration tests.
class PaginatorTest: UpholdTestCase {

    let paginator: Paginator<AnyObject> = Paginator(countClosure: { () -> Promise<Int> in
            return Promise { fulfill, _ in
                fulfill(10)
            }
        },
        elements: Promise { fulfill, _ in
            fulfill([AnyObject]())
        },
        hasNextPageClosure: { (_) -> Promise<Bool> in
            return Promise { fulfill, _ in
                fulfill(true)
            }
        },
        nextPageClosure: { (_) -> Promise<[AnyObject]> in
            return Promise { fulfill, _ in
                let arrayObject = ["foo", "bar"]
                fulfill(arrayObject as [AnyObject])
            }
        })

    func testCount() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.count().then { (count: Int) -> Void in
            XCTAssertEqual(count, 10, "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testGetNext() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.getNext().then { (objects: [AnyObject]) -> Void in
            XCTAssertEqual(objects[0] as? String, "foo", "Failed: Wrong object.")
            XCTAssertEqual(objects[1] as? String, "bar", "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testGetNextPage() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.nextPageClosure("foobar").then { (objects: [AnyObject]) -> Void in
            XCTAssertEqual(objects[0] as? String, "foo", "Failed: Wrong object.")
            XCTAssertEqual(objects[1] as? String, "bar", "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (_: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testHasNextPage() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.hasNextPageClosure(1).then { (hasNext: Bool) -> Void in
            XCTAssertTrue(hasNext, "Failed: Wrong object.")

            testExpectation.fulfill()
            }.catch(execute: { (_: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

}
