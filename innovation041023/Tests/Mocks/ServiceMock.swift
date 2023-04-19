//
//  ServiceMock.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/19/23.
//

import Foundation

// Create a mock object that conforms to the ServiceProtocol
class MockService: ServiceProtocol {
    var fetchStockPricesWithIntervalCalled = false
    var fetchStockPricesWithIntervalSymbol: String?
    var fetchStockPricesWithIntervalRange: Range?
    var fetchStockPricesWithIntervalReturnValue: Response?
    var fetchStockPricesWithIntervalError: Error?

    func fetchStockPricesWithInterval(symbol: String, range: Range) async throws -> Response {
        fetchStockPricesWithIntervalCalled = true
        fetchStockPricesWithIntervalSymbol = symbol
        fetchStockPricesWithIntervalRange = range

        if let error = fetchStockPricesWithIntervalError {
            throw error
        } else {
            let response = try JSONDecoder().decode(Response.self, from: jsonData)
            return fetchStockPricesWithIntervalReturnValue ?? response // Replace with your desired return value
        }
    }
}
