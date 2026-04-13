//
//  StartDatePicker.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct StartDatePicker: View {
    @Binding var startDate: Date

    var body: some View {
        DatePicker(selection: $startDate, displayedComponents: .date) {
            HStack {
                Image(systemName: "calendar").foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("开始日期")
                    Text(DateFormatter.yearMonthDay.string(from: startDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
