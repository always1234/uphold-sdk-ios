import Foundation
import ObjectMapper
import PromiseKit

/// Paginator Protocol.
protocol PaginatorProtocol {

    /// Paginator generic type.
    associatedtype PaginatorType

    /**
      A closure to get a promise with the total number of elements.

      - returns: A promise with the number of elements.
    */
    var countClosure: () -> Promise<Int> {get}

    /**
      A closure to get a promise with the next page of elements.

      - returns: A promise with the array of elements.
    */
    var nextPageClosure: (_ range: String) -> Promise<[PaginatorType]> {get}

    /**
      A closure to get a promise with a bolean indicating if exists a next page of elements.

      - returns: A promise with the bolean indicator.
    */
    var hasNextPageClosure: (_ currentPage: Int) -> Promise<Bool> {get}

}
