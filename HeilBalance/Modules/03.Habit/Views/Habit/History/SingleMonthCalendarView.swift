////
////  SingleMonthCalendarView.swift
////  Habit
////
////  Created by J on 5/17/25.
////
//
//import SwiftUI
//
//struct SingleMonthCalendarView: View {
//    var date: Date
//    var habits: [Habit]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(formattedMonth(date))
//                .font(.title2)
//                .bold()
//                .padding(.horizontal)
//
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
//                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { weekday in
//                    Text(weekday)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//
//                ForEach(getAllDaysInMonth(for: date), id: \.self) { day in
//                    if Calendar.current.isDate(day, equalTo: Date.distantPast, toGranularity: .day) {
//                        Color.clear.frame(height: 40)
//                    } else {
//                        let isMarked = habits.contains { isHabitCompleted($0, on: day) }
//                        VStack {
//                            Text("\(Calendar.current.component(.day, from: day))")
//                                .font(.footnote)
//                                .foregroundColor(isToday(day) ? .blue : .primary)
//                            Circle()
//                                .fill(isMarked ? Color.green : Color.gray.opacity(0.3))
//                                .frame(width: 8, height: 8)
//                        }
//                        .frame(maxWidth: .infinity, minHeight: 40)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//
//    func formattedMonth(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy年MM月"
//        return formatter.string(from: date)
//    }
//
//    func getAllDaysInMonth(for date: Date) -> [Date] {
//        let calendar = Calendar.current
//        guard let range = calendar.range(of: .day, in: .month, for: date),
//              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
//            return []
//        }
//
//        let weekdayOffset = calendar.component(.weekday, from: monthStart) - 1
//        var dates: [Date] = Array(repeating: Date.distantPast, count: weekdayOffset)
//
//        for day in range {
//            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
//                dates.append(dayDate)
//            }
//        }
//
//        return dates
//    }
//
//    func isToday(_ date: Date) -> Bool {
//        Calendar.current.isDateInToday(date)
//    }
//    
//    func isHabitCompleted(_ habit: Habit, on date: Date) -> Bool {
//        guard let logs = habit.habitLogs as? Set<HabitLog> else { return false }
//        return logs.contains { log in
//            if let logDate = log.date {
//                return Calendar.current.isDate(logDate, inSameDayAs: date)
//            }
//            return false
//        }
//    }
//}



import SwiftUI

// MARK: - 数据模型补全 (假设你的 Core Data 模型结构如下)
// 如果你已经定义了 Habit 和 HabitLog，可以忽略这两个占位结构
/*
struct Habit {
    var habitLogs: NSSet? // 对应 Core Data 的关系
}
struct HabitLog {
    var date: Date?
}
*/

// 用于日历渲染的辅助模型
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date? // nil 表示月初的空白占位
}

struct SingleMonthCalendarView: View {
    let date: Date
    let habits: [Habit]
    
    private let calendar = Calendar.current

    // 预计算属性：将所有习惯的完成日期汇总到一个 Set 中，大幅提升渲染性能
    private var completedDateComponents: Set<DateComponents> {
        var completedSet = Set<DateComponents>()
        for habit in habits {
            if let logs = habit.habitLogs as? Set<HabitLog> {
                for log in logs {
                    if let logDate = log.date {
                        let components = calendar.dateComponents([.year, .month, .day], from: logDate)
                        completedSet.insert(components)
                    }
                }
            }
        }
        return completedSet
    }

    // 预计算当月的所有日期单元格
    private var monthDays: [CalendarDay] {
        getAllDaysInMonth(for: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 月份标题
            Text(formattedMonth(date))
                .font(.title2)
                .bold()
                .padding(.horizontal)

            // 日历网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                // 星期表头
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption)
                        .bold()
                        .foregroundColor(.secondary)
                }

                // 日期单元格
                ForEach(monthDays) { day in
                    if let dateValue = day.date {
                        dayCell(for: dateValue)
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }

    // 单个日期单元格视图
    @ViewBuilder
    private func dayCell(for dayDate: Date) -> some View {
        let isMarked = isDateCompleted(dayDate)
        let isToday = calendar.isDateInToday(dayDate)
        
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: dayDate))")
                .font(.footnote)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .blue : .primary)
            
            Circle()
                .fill(isMarked ? Color.green : Color.gray.opacity(0.2))
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        // 如果需要点击日期查看详情，可以在这里加 .onTapGesture
    }
}

// MARK: - 逻辑扩展
extension SingleMonthCalendarView {
    
    func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: date)
    }

    func isDateCompleted(_ date: Date) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return completedDateComponents.contains(components)
    }

    func getAllDaysInMonth(for date: Date) -> [CalendarDay] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }

        // 计算月初是周几 (1-7, 1是周日)
        let weekday = calendar.component(.weekday, from: monthStart)
        let weekdayOffset = weekday - 1 // 得到前面需要补齐的空格数

        var days: [CalendarDay] = []

        // 1. 填充月初空白
        for _ in 0..<weekdayOffset {
            days.append(CalendarDay(date: nil))
        }

        // 2. 填充真实日期
        for day in range {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(CalendarDay(date: dayDate))
            }
        }

        return days
    }
}

// MARK: - 预览
struct SingleMonthCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // 这里只是示意，实际需要传入你的数据对象
        SingleMonthCalendarView(date: Date(), habits: [])
    }
}
