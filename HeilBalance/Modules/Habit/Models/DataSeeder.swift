//
//  DataSeeder.swift
//  MindZen
//
//  Created by J on 5/21/25.
//
import CoreData
import Foundation

class DataSeeder {
    static let shared = DataSeeder()

    private func findOrCreateHabitTemplateCategory(in context: NSManagedObjectContext) -> Category {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", "习惯模版")
        fetchRequest.fetchLimit = 1

        do {
            if let existingCategory = try context.fetch(fetchRequest).first {
                return existingCategory
            } else {
                // 不存在，创建一个新的
                let newCategory = Category(context: context)
                newCategory.id = UUID()
                newCategory.name = "习惯模版"
                newCategory.icon = "rectangle.stack"
                return newCategory
            }
        } catch {
            print("❌ 查询 Category 失败: \(error.localizedDescription)")
            // 出错时也返回新建对象以避免崩溃
            let fallbackCategory = Category(context: context)
            fallbackCategory.id = UUID()
            fallbackCategory.name = "习惯模版"
            fallbackCategory.icon = "rectangle.stack"
            return fallbackCategory
        }
    }
    
    func seedInitialPlanIfNeeded(context: NSManagedObjectContext) {
        let userDefaultsKey = "hasSeededInitialPlan"

        // 避免重复导入：只在第一次启动时执行
        if UserDefaults.standard.bool(forKey: userDefaultsKey) == false {

            // 1. 读取 JSON 文件
            guard let url = Bundle.main.url(forResource: "TemplateFitness", withExtension: "json") else {
                
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                 return
            }

            // 2. 使用 Decodable 结构体解析 JSON
            let decoder = JSONDecoder()
            guard let habitTemplates = try? decoder.decode([HabitTemplate].self, from: data) else {
                return
            }

            let tempCategory = findOrCreateHabitTemplateCategory(in: context)
            // 3. 将解析结果写入 Core Data
            for (index, habitTemplate) in habitTemplates.enumerated() {
                let habit = Habit(context: context)
                habit.id = UUID()
                habit.name = habitTemplate.name
                habit.icon = habitTemplate.icon
                habit.goalNumber = Int64(habitTemplate.goalNumber)
                habit.goalUnit = habitTemplate.goalUnit
                habit.goalFrequency = habitTemplate.goalFrequency
                habit.isTemplate = true
                habit.category = tempCategory
            }

            // 4. 保存到 Core Data
            do {
                try context.save()
                // 5. 标记已导入
                UserDefaults.standard.set(true, forKey: userDefaultsKey)
            } catch {
            }
        }
    }
}
