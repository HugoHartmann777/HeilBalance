//
//  CategoryPickerRow.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI
import CoreData

struct CategoryPickerRow: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default
    ) private var categorys: FetchedResults<Category>
    
    @Binding var selectedCategory: Category?
    
    @State private var showCreateCategory = false
    
    var body: some View {
        NavigationLink(destination: CategoryListView(selectedCategory: $selectedCategory)) {
            HStack {
                Image(systemName: "folder")
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("分组")
                    Text(selectedCategory?.name ?? "未选择")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    showCreateCategory = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                // 按钮不要影响整个行的点击
            }
        }
        .sheet(isPresented: $showCreateCategory) {
            NavigationView {
                CreateGroupView(isPresented: $showCreateCategory)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
