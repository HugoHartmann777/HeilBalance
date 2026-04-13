
//
//  RepeatDaysView.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct RepeatDaysRow: View {
    @Binding var selectedDays: Set<Int>
    let weekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]

    var body: some View {
        NavigationLink(destination: RepeatDaysView(selectedDays: $selectedDays)) {
            HStack {
                Image(systemName: "arrow.2.circlepath").foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("重复")
                    Text(repeatDescription())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private func repeatDescription() -> String {
        if selectedDays.count == 7 {
            return "每天"
        } else if selectedDays.isEmpty {
            return "不重复"
        } else {
            return selectedDays.sorted()
                .compactMap { (0..<weekDays.count).contains($0) ? weekDays[$0] : nil }
                .joined(separator: "，")
        }
    }
}

struct RepeatDaysView: View {
    @Binding var selectedDays: Set<Int>
    let weekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    
    var body: some View {
        List {
            ForEach(0..<7, id: \.self) { index in
                Button(action: {
                    if selectedDays.contains(index) {
                        selectedDays.remove(index)
                    } else {
                        selectedDays.insert(index)
                    }
                }) {
                    HStack {
                        Text(weekDays[index])
                        Spacer()
                        if selectedDays.contains(index) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("选择重复日")
    }
}

