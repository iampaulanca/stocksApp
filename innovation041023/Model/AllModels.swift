//
//  AllModels.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import Foundation
import Charts

struct Response: Codable, Hashable, Identifiable {
    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let chart: StockChart
    let id = UUID()
}

struct StockChart: Codable {
    let result: [Result]
}

struct Result: Codable {
    let meta: Meta
    let timestamp: [Int]
    let indicators: Indicators
}

struct PlotXY: Identifiable, Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let x: Date
    let y: Double
    let id = UUID()
}

struct Meta: Codable {
    let currency: String
    let symbol: String
    let exchangeName: String
    let instrumentType: String
    let firstTradeDate: Int
    let regularMarketTime: Int
    let gmtoffset: Int
    let timezone: String
    let exchangeTimezoneName: String
    let regularMarketPrice: Double
    let chartPreviousClose: Double
    let priceHint: Int
    let currentTradingPeriod: CurrentTradingPeriod
    let dataGranularity: String
    let range: String
    let validRanges: [String]
}

struct CurrentTradingPeriod: Codable {
    let pre: Pre
    let regular: Regular
    let post: Post
}

struct Pre: Codable {
    let timezone: String
    let start: Int
    let end: Int
    let gmtoffset: Int
}

struct Regular: Codable {
    let timezone: String
    let start: Int
    let end: Int
    let gmtoffset: Int
}

struct Post: Codable {
    let timezone: String
    let start: Int
    let end: Int
    let gmtoffset: Int
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable, Equatable {
    let low: [Double]
    let open: [Double]
    let close: [Double]
    let high: [Double]
    let volume: [Double]
    // Add other necessary properties here
}

enum Interval: String, CaseIterable {
    case oneMinute = "1m"
    case twoMinutes = "2m"
    case fiveMinutes = "5m"
    case fifteenMinutes = "15m"
    case thirtyMinutes = "30m"
    case sixtyMinutes = "60m"
    case ninetyMinutes = "90m"
    case oneHour = "1h"
    case oneDay = "1d"
    case fiveDays = "5d"
    case oneWeek = "1wk"
    case oneMonth = "1mo"
    case threeMonths = "3mo"
}

enum Range: String, CaseIterable {
    case oneDay = "1d"
    case oneWeek = "1wk"
    case oneMonth = "1mo"
    case threeMonths = "3mo"
    case sixMonths = "6mo"
    case oneYears = "1y"
    case twoYears = "2y"
    case fiveYears = "5y"
    case tenYears = "10y"
    case yearToDate = "ytd"
    case maxYears = "max"
}
