import SwiftUI

// MARK: - 数据模型补全 (假设你的 Core Data 模型结构如下)
// 如果你已经定义了 Habit 和 HabitLog，可以忽略这两个占位结构


// 用于日历渲染的辅助模型
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date? // nil 表示月初的空白占位
}

struct SingleMonthCalendarView: View {
    let date: Date
    let habit: Habit
    
    private let calendar = Calendar.current
    // 预计算属性：将所有习惯的完成日期汇总到一个 Set 中，大幅提升渲染性能
    private var completedDateComponents: Set<DateComponents> {
        var completedSet = Set<DateComponents>()

        if let logs = habit.habitLogs as? Set<HabitLog> {
            for log in logs {
                if let logDate = log.date, !isLogSkipped(log) {
                    let components = calendar.dateComponents([.year, .month, .day], from: logDate)
                    completedSet.insert(components)
                }
            }
        }

        return completedSet
    }

    private var skippedDateComponents: Set<DateComponents> {
        var skippedSet = Set<DateComponents>()

        if let logs = habit.habitLogs as? Set<HabitLog> {
            for log in logs {
                if let logDate = log.date, isLogSkipped(log) {
                    let components = calendar.dateComponents([.year, .month, .day], from: logDate)
                    skippedSet.insert(components)
                }
            }
        }

        return skippedSet
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
        let isSkipped = isDateSkipped(dayDate)
        let isToday = calendar.isDateInToday(dayDate)
        let isFuture = calendar.startOfDay(for: dayDate) > calendar.startOfDay(for: Date())
        let createdAt = habit.createdAt ?? Date.distantPast
        let isBeforeCreated = calendar.startOfDay(for: dayDate) < calendar.startOfDay(for: createdAt)

        let dotColor: Color = {
            if isMarked { return .green }      // 已打卡
            if isSkipped { return .orange }   // 已跳过
            if isBeforeCreated { return Color.gray.opacity(0.25) } // 创建前日期
            if isFuture { return Color.gray.opacity(0.25) } // 未来未打卡
            return .red                       // 创建后且过去未打卡
        }()

        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: dayDate))")
                .font(.footnote)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .blue : .primary)

            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity, minHeight: 40)
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

    func isDateSkipped(_ date: Date) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return skippedDateComponents.contains(components)
    }

    func isLogSkipped(_ log: HabitLog) -> Bool {
        // 请确保 HabitLog 中有 isSkipped 字段（Bool）
        // 如果你的字段名不同，例如 status / skipped，请改成对应名字
        return log.isSkipped
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
