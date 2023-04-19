//
//  StockDetailView.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    @ObservedObject var viewModel: StocksViewModel
    @State var stock: Response
    @State var plots: [PlotXY] = []
    @State private var range = Range.oneWeek
    @State private var interval = Interval.oneDay
    @State var symbol: String = ""
    init(viewModel: StocksViewModel, stock: Response) {
        self.viewModel = viewModel
        self._stock = State(initialValue: stock)
        self._symbol = State(initialValue: stock.chart.result.first?.meta.symbol ?? "")
        if let range = Range(rawValue: stock.chart.result.first?.meta.range ?? "") {
            self._range = State(initialValue: range)
        }
        
        if let interval = Interval(rawValue: stock.chart.result.first?.meta.dataGranularity ?? "") {
            self._interval = State(initialValue: interval)
        }
        
    }
    var body: some View {
        VStack {
            HStack {
                Text("\(stock.chart.result.first?.meta.symbol ?? "")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                VStack {
                    Text("Range")
                    Picker("Range", selection: $range) {
                        ForEach(Range.allCases, id: \.self) { interval in
                            Text(interval.rawValue).tag(interval)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: range) { newValue in
                        Task {
                            self.stock = try await viewModel.fetchStocks(symbol: symbol, range: range)
                            buildPlot()
                        }
                    }
                }
            }
            .padding()
            
            ScrollView(.horizontal) {
                
                Chart {
                    ForEach(plots) { plot in
                        LineMark(
                            x: .value("Date", plot.x),
                            y: .value("Closing Price", plot.y)
                        )
                    }
                }
                .chartYScale(domain: [plots.min(by: { $0.y < $1.y })?.y ?? 0.0, plots.max(by: { $0.y < $1.y })?.y ?? 0.0] )
                .chartXAxis {
                    AxisMarks(values: .stride(by: range.rawValue.contains("wk") ? .day : .month, count: 1)) { value in
                        if value.as(Date.self) != nil {
                            switch range {
                            case .oneDay:
                                AxisValueLabel(format: .dateTime.hour())
                            case .oneWeek:
                                AxisValueLabel(format: .dateTime.day())
                            case .oneMonth:
                                AxisValueLabel(format: .dateTime.day())
                            case .threeMonths:
                                AxisValueLabel(format: .dateTime.month())
                            case .sixMonths:
                                AxisValueLabel(format: .dateTime.month())
                            case .oneYears:
                                AxisValueLabel(format: .dateTime.month())
                            case .twoYears:
                                AxisValueLabel(format: .dateTime.month())
                            case .fiveYears:
                                AxisValueLabel(format: .dateTime.year())
                            case .tenYears:
                                AxisValueLabel(format: .dateTime.year())
                            case .yearToDate:
                                AxisValueLabel(format: .dateTime.month())
                            case .maxYears:
                                AxisValueLabel(format: .dateTime.year())
                            }
//                            let hour = Calendar.current.component(.hour, from: date)
//                            let day = Calendar.current.component(.day, from: date)
//                            switch hour {
//                            case 0, 12:
                            
//                            default:
//                                AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
//                            }
                            
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
                .padding()
                .frame(width:
                        UIScreen.main.bounds.width)
                .onAppear {
                    buildPlot()
                }
            }
            .frame(maxHeight: 300)
        }
        
    }
    
    func buildPlot() {
        let timestamps = stock.chart.result.first?.timestamp.compactMap { Date(timeIntervalSince1970: TimeInterval($0)) } ?? []
        
        let quotes = stock.chart.result.first?.indicators.quote.first?.close ?? []
        var plots = [PlotXY]()
        for (timestamp, quote) in zip(timestamps, quotes) {
            plots.append(PlotXY(x: timestamp, y: quote))
        }
        self.plots = plots
       
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
            StockDetailView(viewModel: StocksViewModel(), stock: mockResponse)
        
    }
}

let jsonData: Data =
"""
{
  "chart": {
    "result": [
      {
        "meta": {
          "currency": "USD",
          "symbol": "GOOG",
          "exchangeName": "NMS",
          "instrumentType": "EQUITY",
          "firstTradeDate": 1092922200,
          "regularMarketTime": 1681746664,
          "gmtoffset": -14400,
          "timezone": "EDT",
          "exchangeTimezoneName": "America/New_York",
          "regularMarketPrice": 105.68,
          "chartPreviousClose": 102.46,
          "priceHint": 2,
          "currentTradingPeriod": {
            "pre": {
              "timezone": "EDT",
              "start": 1681718400,
              "end": 1681738200,
              "gmtoffset": -14400
            },
            "regular": {
              "timezone": "EDT",
              "start": 1681738200,
              "end": 1681761600,
              "gmtoffset": -14400
            },
            "post": {
              "timezone": "EDT",
              "start": 1681761600,
              "end": 1681776000,
              "gmtoffset": -14400
            }
          },
          "dataGranularity": "1d",
          "range": "1mo",
          "validRanges": [
            "1d",
            "5d",
            "1mo",
            "3mo",
            "6mo",
            "1y",
            "2y",
            "5y",
            "10y",
            "ytd",
            "max"
          ]
        },
        "timestamp": [
          1679059800,
          1679319000,
          1679405400,
          1679491800,
          1679578200,
          1679664600,
          1679923800,
          1680010200,
          1680096600,
          1680183000,
          1680269400,
          1680528600,
          1680615000,
          1680701400,
          1680787800,
          1681133400,
          1681219800,
          1681306200,
          1681392600,
          1681479000,
          1681746664
        ],
        "indicators": {
          "quote": [
            {
              "low": [
                100.75,
                100.79000091552734,
                101.86000061035156,
                104.20999908447266,
                105.41000366210938,
                104.73999786376953,
                102.62999725341797,
                100.27999877929688,
                101.02999877929688,
                100.29000091552734,
                101.44000244140625,
                102.37999725341797,
                104.5999984741211,
                104.10199737548828,
                104.81500244140625,
                105.5999984741211,
                105.27999877929688,
                104.97000122070312,
                106.44000244140625,
                107.58999633789062,
                105.33000183105469
              ],
              "open": [
                100.83999633789062,
                101.05999755859375,
                101.9800033569336,
                105.13999938964844,
                105.88999938964844,
                105.73999786376953,
                105.31999969482422,
                103,
                102.72000122070312,
                101.44000244140625,
                101.70999908447266,
                102.66999816894531,
                104.83999633789062,
                106.12000274658203,
                105.7699966430664,
                107.38999938964844,
                106.91999816894531,
                107.38999938964844,
                106.47000122070312,
                107.69000244140625,
                105.43000030517578
              ],
              "close": [
                102.45999908447266,
                101.93000030517578,
                105.83999633789062,
                104.22000122070312,
                106.26000213623047,
                106.05999755859375,
                103.05999755859375,
                101.36000061035156,
                101.9000015258789,
                101.31999969482422,
                104,
                104.91000366210938,
                105.12000274658203,
                104.94999694824219,
                108.9000015258789,
                106.94999694824219,
                106.12000274658203,
                105.22000122070312,
                108.19000244140625,
                109.45999908447266,
                105.68009948730469
              ],
              "high": [
                103.48999786376953,
                102.58000183105469,
                105.95999908447266,
                107.51000213623047,
                107.10099792480469,
                106.16000366210938,
                105.4000015258789,
                103,
                102.81999969482422,
                101.61000061035156,
                104.19000244140625,
                104.94999694824219,
                106.0999984741211,
                106.54000091552734,
                109.62999725341797,
                107.97000122070312,
                107.22000122070312,
                107.58699798583984,
                108.26499938964844,
                109.58000183105469,
                106.70999908447266
              ],
              "volume": [
                76140300,
                26033900,
                33122800,
                32336900,
                31385800,
                25245000,
                25393400,
                24913500,
                26148300,
                25009800,
                28086500,
                20719900,
                20377200,
                21864200,
                34684200,
                19741500,
                18721300,
                22761600,
                21650700,
                20745400,
                15135372
              ]
            }
          ],
          "adjclose": [
            {
              "adjclose": [
                102.45999908447266,
                101.93000030517578,
                105.83999633789062,
                104.22000122070312,
                106.26000213623047,
                106.05999755859375,
                103.05999755859375,
                101.36000061035156,
                101.9000015258789,
                101.31999969482422,
                104,
                104.91000366210938,
                105.12000274658203,
                104.94999694824219,
                108.9000015258789,
                106.94999694824219,
                106.12000274658203,
                105.22000122070312,
                108.19000244140625,
                109.45999908447266,
                105.68009948730469
              ]
            }
          ]
        }
      }
    ],
    "error": null
  }
}
""".data(using: .utf8)!
let mockResponse = try! JSONDecoder().decode(Response.self, from: jsonData)
