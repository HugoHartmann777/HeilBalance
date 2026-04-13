//
//  CoreDataHelper.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import CoreData

final class CoreDataHelper {
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    // 工具函数：一天的起始时间
    func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    // 工具函数：下一天的起始时间
    func startOfNextDay(for date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay(for: date))!
    }
    
    // MARK: - 标记HabitLog
    private func markHabit(_ habit: Habit, as type: HabitLog.LogType, on date: Date? = nil) {
        let targetDate = date ?? Date()
        let start = startOfDay(for: targetDate) as NSDate
        let end = startOfNextDay(for: targetDate) as NSDate
        
        let fetchRequest: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@ AND (date >= %@ AND date < %@)", habit, start, end)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingLog = results.first {
                existingLog.type = type.rawValue
                print("✅ 修改日志为 \(type.rawValue) 成功！\(targetDate)")
            } else {
                let newLog = HabitLog(context: viewContext)
                newLog.id = UUID()
                newLog.type = type.rawValue
                newLog.date = targetDate
                newLog.habit = habit
                habit.addToHabitLogs(newLog)
                print("✅ 新建日志并标记为 \(type.rawValue) 成功！\(targetDate)")
            }
            try viewContext.save()
            print("✅ 保存成功")
        } catch {
            print("❌ 错误: \(error)")
        }
    }
    
    // MARK: - 判断某种类型是否存在（今天）
    private func isHabitMarkedToday(_ habit: Habit, as type: HabitLog.LogType) -> Bool {
        let today = Date()
        let start = startOfDay(for: today) as NSDate
        let end = startOfNextDay(for: today) as NSDate
        
        let fetchRequest: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:
                                                "habit == %@ AND type == %d AND (date >= %@ AND date < %@)",
                                             habit, type.rawValue, start, end)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("❌ 检查是否打卡/跳过失败: \(error)")
            return false
        }
    }
    // MARK: - 标记打卡
    func markHabitCompleted(for habit: Habit, on date: Date? = nil) {
        markHabit(habit, as: .completed, on: date)
    }
    
    // MARK: - 标记跳过
    func markHabitSkipped(for habit: Habit, on date: Date? = nil) {
        markHabit(habit, as: .skipped, on: date)
    }
    
    // MARK: - 是否已完成（今天）
    func isHabitCompletedToday(_ habit: Habit) -> Bool {
        return isHabitMarkedToday(habit, as: .completed)
    }
    
    // MARK: - 是否已跳过（今天）
    func isHabitSkippedToday(_ habit: Habit) -> Bool {
        return isHabitMarkedToday(habit, as: .skipped)
    }
    
    // MARK: - 撤回今日打卡或跳过记录
    func resetTodayStatus(for habit: Habit) {
        let calendar = Calendar.current
        
        if let logs = habit.habitLogs as? Set<HabitLog> {
            let logsToDelete = logs.filter { log in
                if let date = log.date, calendar.isDateInToday(date) {
                    return true
                }
                return false
            }
            
            for log in logsToDelete {
                habit.mutableSetValue(forKey: "habitLogs").remove(log)
                viewContext.delete(log)
            }
            
            do {
                try viewContext.save()
                print("✅ resetTodayStatus: 撤回成功！")
            } catch {
                print("撤回失败: \(error)")
            }
        }
    }
    
    // MARK: - 编辑 Habit
    private func editHabit(_ habit: Habit) {
        // TODO: 替换为你的编辑逻辑，比如弹出 Sheet 编辑名称和图标
        print("编辑 Habit: \(habit.name ?? "")")
    }
    
    // MARK: - 统计次数
    func getHabitLogCount(for habit: Habit) -> Int {
        return (habit.habitLogs as? Set<HabitLog>)?.count ?? 0
    }
    
    // MARK: - 统计完成的次数
    func getCompletedCount(for habit: Habit) -> Int {
        guard let logs = habit.habitLogs as? Set<HabitLog> else {
            return 0
        }
        return logs.filter { $0.isCompleted }.count
    }
    
    // MARK: - 计算最近7天打卡情况
    func getLast7DaysCompletion(for habit: Habit) -> [(date: Date, completed: Bool, skipped: Bool)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // 取出 habitLogs
        let logs = habit.habitLogs as? Set<HabitLog> ?? []
        
        // 近7天的日期数组（从旧到新）
        let last7Days = (0..<7).map { offset in
            calendar.date(byAdding: .day, value: -6 + offset, to: today)!
        }
        
        // 遍历每一天，检查是否有完成记录
        return last7Days.map { day in
            // 优先判断是否打卡
            let completed = logs.contains { log in
                guard let logDate = log.date, log.isCompleted else { return false }
                return calendar.isDate(logDate, inSameDayAs: day)
            }
            
            // 只有在未打卡时，才判断是否跳过
            let skipped = !completed && logs.contains { log in
                guard let logDate = log.date, log.isSkipped else { return false }
                return calendar.isDate(logDate, inSameDayAs: day)
            }
            return (date: day, completed: completed, skipped: skipped)
        }
    }
    
    // MARK: - 连续打卡的天数
    func getConsecutiveCompletedDays(for habit: Habit) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let logs = habit.habitLogs as? Set<HabitLog> ?? []
        
        // 先检查今天是否完成
        let completedToday = logs.contains { log in
            guard let date = log.date, log.isCompleted else { return false }
            return calendar.isDate(date, inSameDayAs: today)
        }
        
        // 从“起始日”开始，如果今天完成，起始日是今天，否则是昨天
        var currentDate = completedToday ? today : calendar.date(byAdding: .day, value: -1, to: today)!
        
        var consecutiveDays = 0
        
        while true {
            let completed = logs.contains { log in
                guard let date = log.date, log.isCompleted else { return false }
                return calendar.isDate(date, inSameDayAs: currentDate)
            }
            
            if completed {
                consecutiveDays += 1
                guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previousDate
            } else {
                break
            }
        }
        
        return consecutiveDays
    }
    
    // MARK: - Core Data 统计数据（打卡 / 跳过 / 未打卡 / 总计）
    func calculateStats(for habit: Habit) -> (completed: Int, skipped: Int, unchecked: Int, totalDays: Int) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let rawStartDate = habit.startDate else {
            return (0, 0, 0, 0)
        }
        
        let startDate = calendar.startOfDay(for: rawStartDate)
        
        guard startDate <= today else {
            return (0, 0, 0, 0)
        }
        
        let totalDays = calendar.dateComponents([.day], from: startDate, to: today).day! + 1
        
        let logs = habit.habitLogs as? Set<HabitLog> ?? []
        
        // 过滤已完成的日志，且日志日期非空
        let completed = logs.filter { log in
            log.isCompleted && log.date != nil
        }.count
        
        // 过滤已跳过的日志，且日志日期非空
        let skipped = logs.filter { log in
            log.isSkipped && log.date != nil
        }.count
        
        let unchecked = max(totalDays - completed - skipped, 0)
        
        print("🚀 calculateStats: totalDays = \(totalDays)")
        return (completed, skipped, unchecked, totalDays)
    }
    
    // MARK: - 标记删除习惯，放入回收站
    func markHabitRemoved(for habit: Habit) {
        do {
            habit.isRemoved = true
            try viewContext.save()
            print("✅ markHabitDeleted: 标记删除成功！")
        } catch {
            print("删除失败: \(error)")
        }
    }
    
    // MARK: - 标记归档习惯
    func markHabitArchived(for habit: Habit) {
        habit.isArchived = true
        
        do {
            try viewContext.save()
            print("✅ markHabitArchive: 归档成功！")
        } catch {
            print("撤回失败: \(error)")
        }
    }
    
    // MARK: - 彻底删除习惯
    func destroyHabit(for habit: Habit) {
        if let logsToDelete = habit.habitLogs as? Set<HabitLog> {
            for log in logsToDelete {
                habit.mutableSetValue(forKey: "habitLogs").remove(log)
                viewContext.delete(log)
            }
            
            viewContext.delete(habit)
            do {
                try viewContext.save()
                print("✅ resetTodayStatus: 撤回成功！")
            } catch {
                print("撤回失败: \(error)")
            }
        }
    }
    
    // MARK: - 统计完成天数
    func getCompletedDays(for habit: Habit) -> Int {
        let logs = habit.habitLogs as? Set<HabitLog> ?? []
        let completedCount = logs.filter { $0.isCompleted && $0.date != nil }.count
        return completedCount
    }
    

    
    
    
    
    
    // MARK: - 测试打印专用Func
    func forTest(for habit: Habit) {
        print("✅ forTest: habit.name = \(habit.name!)")
    }
}
