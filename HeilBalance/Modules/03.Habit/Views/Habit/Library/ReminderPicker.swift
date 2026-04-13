//
//  ReminderPicker.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct ReminderPicker: View {
    @Binding var reminderTime: Date

    var body: some View {
        DatePicker(selection: $reminderTime, displayedComponents: .hourAndMinute) {
            HStack {
                Image(systemName: "bell.fill").foregroundColor(.purple)
                VStack(alignment: .leading) {
                    Text("提醒")
                    Text(DateFormatter.hourMinute.string(from: reminderTime))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
