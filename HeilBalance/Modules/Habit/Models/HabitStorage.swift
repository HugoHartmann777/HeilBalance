//
//  HabitStorage.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class HabitStorage: ObservableObject {
    @Published var habits: [Habit] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = MindZenPersistenceController.shared.container.viewContext) {
        self.context = context
        fetchHabits()
    }

    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: true)]
        
        do {
            habits = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch habits: \(error)")
        }
    }

    func resetHabitStatusForNewDay() {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard

        if let lastReset = defaults.object(forKey: "lastResetDate") as? Date {
            let lastResetDay = Calendar.current.startOfDay(for: lastReset)
            if lastResetDay == today {
                return // 已重置过
            }
        }

        saveContext()
        defaults.set(today, forKey: "lastResetDate")
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }

    // MARK: - 工具方法
    static func getAllDaysInCurrentMonth() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else { return [] }

        let weekdayOffset = calendar.component(.weekday, from: monthStart) - 1 // Sunday = 1 → offset 0
        var dates: [Date] = Array(repeating: Date.distantPast, count: weekdayOffset)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                dates.append(date)
            }
        }
        return dates
    }

    static func getFormattedDate() -> String {
        let strWeekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = formatter.string(from: date)
        let weekday = (Calendar.current.component(.weekday, from: Date()) - 1) % 7
        return "\(strWeekDays[weekday])\n\(formattedDate)"
    }
    
    func createHabitTemplate() {
        
    }
}
