import Foundation
import ObjectMapper
import PromiseKit

/// Paginator model.
open class Paginator<T>: PaginatorProtocol {

    /// Default offset page.
    static var DEFAULT_OFFSET: Int {
        return 50
    }

    /// Default start page.
    static var DEFAULT_START: Int {
        return 0
    }

    /// The current page.
    private var currentPage: Int

    /// A promise with the first list of elements.
    open let elements: Promise<[T]>

    /// Closure to get a promise with the total number of elements.
    let countClosure: () -> Promise<Int>

    /// Closure to get a promise with a bolean indicating if exists a next page of elements.
    let hasNextPageClosure: (_ currentPage: Int) -> Promise<Bool>

    /// Closure to get a promise with the next page of elements.
    let nextPageClosure: (_ range: String) -> Promise<[T]>

    /**
      Constructor

      - parameter countClosure: A closure to get the total number of elements.
      - parameter elements: A promise with the first page of elements.
      - parameter hasNextPageClosure: A closure to check if there are more pages.
      - parameter nextPageClosure: A closure to get the next page of elements.
    */
    init(countClosure: @escaping () -> Promise<Int>, elements: Promise<[T]>, hasNextPageClosure: @escaping (_ currentPage: Int) -> Promise<Bool>, nextPageClosure: @escaping (_ range: String) -> Promise<[T]>) {
        self.countClosure = countClosure
        self.currentPage = 1
        self.elements = elements
        self.hasNextPageClosure = hasNextPageClosure
        self.nextPageClosure = nextPageClosure
    }

    /**
      Gets the total number of elements.

      - returns: A promise with the total number of elements.
    */
    open func count() -> Promise<Int> {
        return countClosure()
    }

    /**
      Gets the next page of elements.

      - returns: A promise with the array of elements.
    */
    open func getNext() -> Promise<[T]> {
        defer {
            currentPage += 1

            objc_sync_exit(self.currentPage)
        }

        objc_sync_enter(self.currentPage)

        let promise: Promise<[T]> = self.nextPageClosure(Header.buildRangeHeader(start: (Paginator.DEFAULT_OFFSET * currentPage), end: ((Paginator.DEFAULT_OFFSET * currentPage) + Paginator.DEFAULT_OFFSET) - 1))

        return promise
    }

    /**
      Gets a promise with a bolean indicating if exists a next page of elements.

      - returns: A promise with the bolean indicator.
    */
    open func hasNext() -> Promise<Bool> {
        return self.hasNextPageClosure(self.currentPage)
    }

}
