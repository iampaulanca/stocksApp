//
//  innovation041023Tests.swift
//  innovation041023Tests
//
//  Created by Paul Ancajima on 4/17/23.
//

import XCTest
@testable import innovation041023

final class innovation041023Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssert(1 == 1)
    }
    
    func testExample1() throws {
        XCTAssert(1 == 1)
    }
    
    func testExample2() throws {
        XCTAssert(1 == 1)
    }
    
    func testExample3() throws {
        XCTAssertFalse(1 == 2)
    }
    
    func testFetchStockPricesWithInterval_SuccessfulResponse_OneWeekRange() async throws {
            // Given
            let mockService = MockService()
            let symbol = "GOOG"
            let range = Range.oneWeek
            let expectedURL = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/AAPL?interval=1d&range=1mo")!
            let expectedResponse = mockResponse
            mockService.fetchStockPricesWithIntervalReturnValue = expectedResponse
            let service = mockService
            // When
            let result = try await service.fetchStockPricesWithInterval(symbol: symbol, range: range)
            
            // Then
            XCTAssertTrue(mockService.fetchStockPricesWithIntervalCalled)
            XCTAssertEqual(mockService.fetchStockPricesWithIntervalSymbol, symbol)
            XCTAssertEqual(mockService.fetchStockPricesWithIntervalRange, range)
            XCTAssertEqual(result, expectedResponse)
        }
}
