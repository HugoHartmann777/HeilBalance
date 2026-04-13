import SwiftUI
import CoreData

struct CreateHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext  // 明确类型

    var body: some View {
        NavigationView {
            HabitFormView(isEditing: false, context: viewContext)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
