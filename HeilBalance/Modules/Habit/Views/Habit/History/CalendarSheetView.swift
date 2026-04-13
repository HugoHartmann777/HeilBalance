//
//  CalendarSheetView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct CalendarSheetView: View {
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
            animation: .default
        ) private var habits: FetchedResults<Habit>
    
    @Environment(\.dismiss) var dismiss

    // 初始展示当前月
    @State private var selectedMonthIndex = 0
    private let monthRange = -12...12  // 可前后滑动 1 年

    var body: some View {
        VStack {
            HStack {
                Text("打卡历史")
                    .font(.headline)
                Spacer()
                Button("关闭") {
                    dismiss()
                }
            }
            .padding()

            TabView(selection: $selectedMonthIndex) {
                ForEach(monthRange, id: \.self) { offset in
                    let monthDate = Calendar.current.date(byAdding: .month, value: offset, to: Date())!
                    SingleMonthCalendarView(date: monthDate, habits: Array(habits))  // 这里转成数组
                        .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
    }
}
