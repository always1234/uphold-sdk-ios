import XCTest
import PromiseKit
@testable import UpholdSdk

/// Paginator integration tests.
class PaginatorTest: UpholdTestCase {

    let paginator: Paginator<AnyObject> = Paginator(countClosure: { () -> Promise<Int> in
            return Promise { fulfill, reject in
                fulfill(10)
            }
        },
        elements: Promise { fulfill, reject in
            fulfill([AnyObject]())
        },
        hasNextPageClosure: { (currentPage) -> Promise<Bool> in
            return Promise { fulfill, reject in
                fulfill(true)
            }
        },
        nextPageClosure: { (range) -> Promise<[AnyObject]> in
            return Promise { fulfill, reject in
                let arrayObject = ["foo", "bar"]
                fulfill(arrayObject as [AnyObject])
            }
        })

    func testCount() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.count().then { (count: Int) -> () in
            XCTAssertEqual(count, 10, "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testGetNext() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.getNext().then { (objects: [AnyObject]) -> () in
            XCTAssertEqual(objects[0] as? String, "foo", "Failed: Wrong object.")
            XCTAssertEqual(objects[1] as? String, "bar", "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testGetNextPage() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.nextPageClosure("foobar").then { (objects: [AnyObject]) -> () in
            XCTAssertEqual(objects[0] as? String, "foo", "Failed: Wrong object.")
            XCTAssertEqual(objects[1] as? String, "bar", "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

    func testHasNextPage() {
        let testExpectation = expectation(description: "Paginator test.")

        paginator.hasNextPageClosure(1).then { (hasNext: Bool) -> () in
            XCTAssertTrue(hasNext, "Failed: Wrong object.")

            testExpectation.fulfill()
        }.catch(execute: { (error: Error) in
            XCTFail("Paginator test error.")
        })

        wait()
    }

}
