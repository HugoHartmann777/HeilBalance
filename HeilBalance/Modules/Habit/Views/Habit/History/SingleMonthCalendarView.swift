//
//  SingleMonthCalendarView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct SingleMonthCalendarView: View {
    var date: Date
    var habits: [Habit]

    var body: some View {
        VStack(alignment: .leading) {
            Text(formattedMonth(date))
                .font(.title2)
                .bold()
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { weekday in
                    Text(weekday)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                ForEach(getAllDaysInMonth(for: date), id: \.self) { day in
                    if Calendar.current.isDate(day, equalTo: Date.distantPast, toGranularity: .day) {
                        Color.clear.frame(height: 40)
                    } else {
                        let isMarked = habits.contains { isHabitCompleted($0, on: day) }
                        VStack {
                            Text("\(Calendar.current.component(.day, from: day))")
                                .font(.footnote)
                                .foregroundColor(isToday(day) ? .blue : .primary)
                            Circle()
                                .fill(isMarked ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                        .frame(maxWidth: .infinity, minHeight: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: date)
    }

    func getAllDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        let weekdayOffset = calendar.component(.weekday, from: monthStart) - 1
        var dates: [Date] = Array(repeating: Date.distantPast, count: weekdayOffset)

        for day in range {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                dates.append(dayDate)
            }
        }

        return dates
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isHabitCompleted(_ habit: Habit, on date: Date) -> Bool {
        guard let logs = habit.habitLogs as? Set<HabitLog> else { return false }
        return logs.contains { log in
            if let logDate = log.date {
                return Calendar.current.isDate(logDate, inSameDayAs: date)
            }
            return false
        }
    }
}
