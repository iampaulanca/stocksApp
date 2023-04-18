//
//  Test.swift
//  innovation041023
//
//  Created by Paul Ancajima on 4/17/23.
//

import SwiftUI
import Charts

struct MonthlyHoursOfSunshine: Identifiable {
    var date: Date
    var hoursOfSunshine: Double
    var id = UUID()
    
    init(month: Int, hoursOfSunshine: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: 2020, month: month))!
        self.hoursOfSunshine = hoursOfSunshine
    }
}
struct Test: View {
   
    
    var data: [MonthlyHoursOfSunshine] = [
        MonthlyHoursOfSunshine(month: 1, hoursOfSunshine: 74),
        MonthlyHoursOfSunshine(month: 2, hoursOfSunshine: 99),
        // ...
        MonthlyHoursOfSunshine(month: 12, hoursOfSunshine: 62)
    ]
    
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Month", $0.date),
                y: .value("Hours of Sunshine", $0.hoursOfSunshine)
            )
        }
        .padding()
        .frame(height: 200)
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}


