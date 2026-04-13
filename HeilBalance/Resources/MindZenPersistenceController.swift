import CoreData

class HabitPersistenceController {
    static let shared = HabitPersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HeilBalance")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { [weak self] _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            // 自动合并跨线程更改
            self?.container.viewContext.automaticallyMergesChangesFromParent = true
            
            // 先检查并种子数据
//            self?.seedInitialHabitsIfNeeded()
        }
    }
}
