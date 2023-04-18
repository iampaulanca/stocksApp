//
//  StocksViewModel.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import Foundation

@MainActor class StocksViewModel: ObservableObject {
    private let service = Service()
    @Published var stocks = [Response]()
    
    @discardableResult
    func fetchStocks(symbol: String, range: Range = .oneWeek) async throws -> Response{
        let stockInfo = try await service.fetchStockPricesWithInterval(symbol: symbol, range: range)
        return stockInfo
    }
    
    func fetchDefaultStocks(range: Range) async throws {
        let symbols = ["META", "AAPL", "AMZN", "NFLX", "GOOG"]
        let taskGroup = try await withThrowingTaskGroup(of: Response.self) { group in
            for symbol in symbols {
                group.addTask {
                    try await self.service.fetchStockPricesWithInterval(symbol: symbol, range: range)
                }
            }
            
            var results = [Response]()
            for try await result in group {
                results.append(result)
            }
            results.sort(by: { $0.chart.result.first?.meta.symbol ?? "" < $1.chart.result.first?.meta.symbol ?? "" })
            return results
        }
        
        self.stocks.append(contentsOf: taskGroup)
    }
    
    func add(_ stock: Response) {
        let stockSymbol = stock.chart.result.first?.meta.symbol
        if stocks.first(where: { $0.chart.result.first?.meta.symbol == stockSymbol }) == nil {
            self.stocks.append(stock)
        }
    }
}
