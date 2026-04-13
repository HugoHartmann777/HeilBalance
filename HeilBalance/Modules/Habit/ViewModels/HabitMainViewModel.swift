import Foundation
import CoreData
import SwiftUI
import Combine

class HabitMainViewModel: ObservableObject {
    @State private var selectedFilter: HabitFilter = .all
    @Published var categoryHabits: [String: [Habit]] = [:]
    @Published var isEditing: Bool = false

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits()
    }

    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)]

        do {
            let habits = try context.fetch(request)
            categoryHabits = Dictionary(grouping: habits) { $0.category?.name ?? "未分组" }
        } catch {
            print("获取习惯失败: \(error)")
        }
    }

    func deleteHabit(_ habit: Habit) {
        context.delete(habit)
        saveContext()
        fetchHabits()
    }

    func toggleEditing() {
        isEditing.toggle()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("保存失败: \(error)")
        }
    }
}
