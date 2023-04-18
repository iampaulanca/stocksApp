//
//  ContentView.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import SwiftUI

enum Navigation: Hashable {
    case stockDetails(Response)
    case addStock
}
struct ContentView: View {
    @StateObject var stocksViewModel = StocksViewModel()
    @State var navigationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                List {
                    ForEach(stocksViewModel.stocks, id: \.id) { symbol in
                        NavigationLink(value: Navigation.stockDetails(symbol)) {
                            Text(symbol.chart.result.first?.meta.symbol ?? "NA")
                            
                        }
                    }
                }
                .navigationDestination(for: Navigation.self) { navigation in
                    switch navigation {
                    case .addStock:
                        AddStockView(viewModel: stocksViewModel)
                    case .stockDetails(let stock):
                        StockDetailView(viewModel: stocksViewModel, stock: stock)
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Stonks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigationPath.append(Navigation.addStock)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .padding(.trailing)

                }
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            Task {
                do {
                    try await stocksViewModel.fetchDefaultStocks(range: .oneWeek)
                } catch {
                    print(error)
                }
            }
            
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
