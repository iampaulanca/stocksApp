//
//  Service.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import Foundation
enum NetworkError: Error {
    case urlError
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "NO URL"
        }
    }
}

class Service {
    func fetchStockPricesWithInterval(symbol: String, range: Range) async throws -> Response {
        var interval: Interval = .oneMonth
        switch range {
        case .oneDay:
            interval = .oneMinute
        case .oneWeek:
            interval = .oneHour
        case .oneMonth:
            interval = .thirtyMinutes
        case .threeMonths:
            interval = .oneDay
        case .sixMonths:
            interval = .fiveDays
        case .oneYears:
            interval = .oneWeek
        case .twoYears:
            interval = .oneMonth
        case .fiveYears:
            interval = .threeMonths
        case .tenYears:
            interval = .threeMonths
        case .yearToDate:
            interval = .fiveDays
        case .maxYears:
            interval = .threeMonths
        }
        if let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?interval=\(interval.rawValue)&range=\(range.rawValue)") {
            let request = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            let stockObject = try JSONDecoder().decode(Response.self, from: data)
            return stockObject
        } else {
            throw NetworkError.urlError
        }
    }
}
