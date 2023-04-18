//
//  AddStockView.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import SwiftUI

struct AddStockView: View {
    @ObservedObject var viewModel: StocksViewModel
    @State var stockTextField: String = ""
    @State var stocksFound = [Response]()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Find stocks")
            TextField("Ticker Symbol", text: $stockTextField)
                .frame(maxWidth: .infinity)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            
            Button {
                Task {
                    do {
                        let response = try await viewModel.fetchStocks(symbol: stockTextField)
                        stocksFound.append(response)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            } label: {
                Text("Submit")
            }

            List(stocksFound, id: \.id) { stock in
                Text(stock.chart.result.first?.meta.symbol ?? "NA")
                    .onTapGesture {
                        viewModel.add(stock)
                        dismiss()
                    }
            }
        }
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView(viewModel: StocksViewModel())
    }
}
