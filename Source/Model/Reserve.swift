import Foundation
import PromiseKit
import SwiftClient

/// Reserve model.
open class Reserve: BaseModel {

    /**
      Gets the ledger.

      - returns: A paginator with the array of deposits.
    */
    open func getLedger() -> Paginator<Deposit> {
        let request = self.adapter.buildRequest(request: ReserveService.getLedger(range: Header.buildRangeHeader(start: Paginator<Deposit>.DEFAULT_START, end: Paginator<Deposit>.DEFAULT_OFFSET - 1)))

        let paginator: Paginator<Deposit> = Paginator(countClosure: { () -> Promise<Int> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: ReserveService.getLedger(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill(count)
                    })
                }
            },
            elements: self.adapter.buildResponse(request: request),
            hasNextPageClosure: { (currentPage) -> Promise<Bool> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: ReserveService.getLedger(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill((currentPage * Paginator<Deposit>.DEFAULT_OFFSET) < count)
                    })
                }
            },
            nextPageClosure: { (range) -> Promise<[Deposit]> in
                let request = self.adapter.buildRequest(request: ReserveService.getLedger(range: range))
                let promise: Promise<[Deposit]> = self.adapter.buildResponse(request: request)

                return promise
            })

        return paginator
    }

    /**
      Gets the reserve summary of all the obligations and assets within it.

      - returns: A promise with the reserve summary of all the obligations and assets within it.
    */
    open func getStatistics() -> Promise<[ReserveStatistics]> {
        let request = self.adapter.buildRequest(request: ReserveService.getStatistics())

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets the information of any transaction.

      - parameter transactionId: The id of the transaction.

      - returns: A promise with the transaction.
    */
    open func getTransactionById(transactionId: String) -> Promise<Transaction> {
        let request = self.adapter.buildRequest(request: ReserveService.getReserveTransactionById(transactionId: transactionId))

        return self.adapter.buildResponse(request: request)
    }

    /**
      Gets information of all the transactions from the beginning of time.

      - returns: A paginator with the array of transactions.
    */
    open func getTransactions() -> Paginator<Transaction> {
        let request = self.adapter.buildRequest(request: ReserveService.getReserveTransactions(range: Header.buildRangeHeader(start: Paginator<Transaction>.DEFAULT_START, end: Paginator<Transaction>.DEFAULT_OFFSET - 1)))

        let paginator: Paginator<Transaction> = Paginator(countClosure: { () -> Promise<Int> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: ReserveService.getReserveTransactions(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill(count)
                    })
                }
            },
            elements: self.adapter.buildResponse(request: request),
            hasNextPageClosure: { (currentPage) -> Promise<Bool> in
                return Promise { fulfill, reject in
                    self.adapter.buildRequest(request: ReserveService.getReserveTransactions(range: Header.buildRangeHeader(start: 0, end: 1))).end(done: { (response: Response) -> Void in
                        guard let count = Header.getTotalNumberOfResults(headers: response.headers) else {
                            reject(UnexpectedResponseError(message: "Content-Type header should not be nil."))

                            return
                        }

                        fulfill((currentPage * Paginator<Transaction>.DEFAULT_OFFSET) < count)
                    })
                }
            },
            nextPageClosure: { (range) -> Promise<[Transaction]> in
                let request = self.adapter.buildRequest(request: ReserveService.getReserveTransactions(range: range))
                let promise: Promise<[Transaction]> = self.adapter.buildResponse(request: request)

                return promise
            })

        return paginator
    }

}
