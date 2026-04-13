import SwiftUI
import CoreData
import Combine

// ViewModel 负责数据绑定、读取和保存
class HabitFormViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    private var habit: Habit?  // 不再强制提前创建
    let isEditing: Bool

    // 对应 UI 的绑定属性
    @Published var name: String = ""
    @Published var icon: String = "flame.fill"
    @Published var repeatDays: Set<Int> = []
    @Published var timeOfDay: String = "任何时间"
    @Published var reminderTime: Date = Date()
    @Published var checklist: String = ""
    @Published var startDate: Date = Date()
    @Published var selectedCategory: Category?
    @Published var goalNumber: Int = 1
    @Published var goalUnit: String = ""
    @Published var goalFrequency: String = ""

    init(habit: Habit? = nil, context: NSManagedObjectContext, isEditing: Bool) {
        self.viewContext = context
        self.isEditing = isEditing
        self.habit = habit

//        if let habit = habit {
//            self.selectedCategory = habit.category
//            loadHabitData(from: habit)
//        }
        
        if let habit = habit {
            // 编辑模式，直接用 habit 的分组
            self.selectedCategory = habit.category
            loadHabitData(from: habit)
        } else {
            // 新建模式，不选中任何分组
            self.selectedCategory = nil
        }
    }

    private func loadHabitData(from habit: Habit) {
        name = habit.name ?? ""
        icon = habit.icon ?? "flame.fill"
        if let data = habit.repeatDays as? Data {
            repeatDays = Set((try? JSONDecoder().decode([Int].self, from: data)) ?? [])
        }
        goalNumber = Int(habit.goalNumber)
        goalUnit = habit.goalUnit ?? ""
        goalFrequency = habit.goalFrequency ?? ""
        timeOfDay = habit.timeOfDay ?? "任何时间"
        reminderTime = habit.reminderTime ?? Date()
        checklist = habit.checklist ?? ""
        startDate = habit.startDate ?? Date()
    }

    func save() {
        let habitToSave = habit ?? Habit(context: viewContext)

        if habit == nil {
            habitToSave.id = UUID()
            habitToSave.createdAt = Date()
        }

        habitToSave.name = name
        habitToSave.icon = icon
        do {
            let data = try JSONEncoder().encode(Array(repeatDays))
            habitToSave.repeatDays = data
        } catch {
            print("❌ encode repeatDays failed: \(error)")
        }
        habitToSave.goalNumber = Int64(goalNumber)
        habitToSave.goalUnit = goalUnit
        habitToSave.goalFrequency = goalFrequency
        habitToSave.timeOfDay = timeOfDay
        habitToSave.reminderTime = reminderTime
        habitToSave.checklist = checklist
        habitToSave.startDate = startDate
        habitToSave.isRemoved = false
        habitToSave.isArchived = false

        if let selectedCategory = selectedCategory {
            selectedCategory.addToHabits(habitToSave)
            habitToSave.category = selectedCategory
        } else if let defaultCategory = fetchDefaultCategory() {
            defaultCategory.addToHabits(habitToSave)
            habitToSave.category = defaultCategory
        } else {
            let category = Category(context: viewContext)
            category.id = UUID()
            category.name = "默认分组"
            category.icon = "tray"
            category.createdAt = Date()
            try? viewContext.save()
            category.addToHabits(habitToSave)
            habitToSave.category = category
        }

        do {
            try viewContext.save()
            print("✅ Habit 保存成功: \(habitToSave.name ?? "")")
        } catch {
            print("❌ Habit 保存失败: \(error)")
        }

        self.habit = habitToSave  // 保存后可以赋值，便于后续继续编辑
    }

    func fetchDefaultCategory() -> Category? {
        guard viewContext.persistentStoreCoordinator != nil else { return nil }
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "默认分组")
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }
}
