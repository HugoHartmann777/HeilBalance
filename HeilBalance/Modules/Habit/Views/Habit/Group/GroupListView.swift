import SwiftUI
import CoreData

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default
    ) private var categorys: FetchedResults<Category>

    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) private var dismiss

    // 记录待删除的 Category 及其 Habit 名称，用于弹窗显示
    @State private var categoryToDelete: Category?
    @State private var habitNamesToDelete: String = ""
    @State private var showDeleteAlert = false

    var body: some View {
        List {
            ForEach(categorys, id: \.self) { category in
                Button(action: {
                    selectedCategory = category   // 更新绑定
                    dismiss()                     // 然后关闭页面
                }) {
                    HStack {
                        Text(category.name ?? "默认分组")
                        if category == selectedCategory {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
//                Button(action: {
//                    dismiss()
//                }) {
//                    HStack {
//                        Text(category.name ?? "默认分组")
//                        if category == selectedCategory {
//                            Spacer()
//                            Image(systemName: "checkmark")
//                        }
//                    }
//                }
            }
            .onDelete(perform: confirmDeleteCategorys)
        }
        .navigationTitle("选择分组")
        .alert("以下Habit将被删除：", isPresented: $showDeleteAlert, presenting: categoryToDelete) { category in
            Button("确认删除", role: .destructive) {
                deleteCategory(category)
            }
            Button("取消", role: .cancel) {}
        } message: { category in
            Text(habitNamesToDelete.isEmpty ? "该分组没有习惯" : habitNamesToDelete)
        }
    }

    private func confirmDeleteCategorys(at offsets: IndexSet) {
        // 这里只处理第一个被删除的分组，通常用户一次只删一个
        if let index = offsets.first {
            let category = categorys[index]
            categoryToDelete = category
            
            if let habits = category.habits as? Set<Habit>, !habits.isEmpty {
                // 拼接习惯名，每个换行
                habitNamesToDelete = habits
                    .sorted { $0.name ?? "" < $1.name ?? "" }
                    .compactMap { $0.name }
                    .joined(separator: "\n")
            } else {
                habitNamesToDelete = ""
            }
            
            showDeleteAlert = true
        }
    }

    private func deleteCategory(_ category: Category) {
        if let habits = category.habits as? Set<Habit> {
            for habit in habits {
                context.delete(habit)
            }
        }
        context.delete(category)

        do {
            try context.save()
        } catch {
            print("删除分组失败: \(error)")
        }
    }
}
