//
//  HabitRowViewModel.swift
//  MindZen
//
//  Created by J on 5/17/25.
//
import Foundation
import CoreData
import SwiftUI
import Combine

class HabitRowViewModel: ObservableObject {
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    func fetchTodayLogsCount(for habit: Habit) -> Int {
//        let calendar = Calendar.current
//        let startOfDay = calendar.startOfDay(for: Date())
//        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return 0 }
//        
//        let fetchRequest: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "habit == %@ AND (date >= %@) AND (date < %@)", habit, startOfDay as NSDate, endOfDay as NSDate)
//        
//        do {
//            let count = try viewContext.count(for: fetchRequest)
//            return count
//        } catch {
//            print("Error fetching today's logs: \(error)")
//            return 0
//        }
//    }
//    
//    func isHabitSkippedToday(habit: Habit) -> Bool {
//        let request: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
//        let calendar = Calendar.current
//        let todayStart = calendar.startOfDay(for: Date())
//        let todayEnd = calendar.date(byAdding: .day, value: 1, to: todayStart)?.addingTimeInterval(-1)
//
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//            NSPredicate(format: "habit == %@", habit),
//            NSPredicate(format: "date >= %@ AND date <= %@", todayStart as NSDate, todayEnd! as NSDate),
//            NSPredicate(format: "isSkipped == YES")
//        ])
//        request.fetchLimit = 1
//
//        return (try? viewContext.count(for: request)) ?? 0 > 0
//    }
}
