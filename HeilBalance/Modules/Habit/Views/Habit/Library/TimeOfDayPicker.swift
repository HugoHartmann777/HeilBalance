//
//  TimeOfDayPicker.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct TimeOfDayPicker: View {
    @Binding var selectedTime: String

    var body: some View {
        Picker(selection: $selectedTime, label: HStack {
            Image(systemName: "sun.max.fill").foregroundColor(.orange)
            VStack(alignment: .leading) {
                Text("时间")
                Text(selectedTime)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }) {
            ForEach(["任何时间", "早上", "上午", "下午", "晚上"], id: \.self) {
                Text($0).tag($0)
            }
        }
    }
}
