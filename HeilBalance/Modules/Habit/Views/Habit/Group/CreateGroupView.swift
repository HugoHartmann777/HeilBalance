//
//  CreateGroupView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI
import CoreData

struct CreateGroupView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var icon: String = "folder"  // 默认图标
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default
    ) private var categorys: FetchedResults<Category>

    var body: some View {
        Form {
            Section(header: Text("图标")) {
                TextField("图标名称（SF Symbol）", text: $icon)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            Section(header: Text("名称")) {
                TextField("请输入分组名称", text: $name)
            }
            Section {
                Button("保存") {
                    addCategory()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("新建分组")
        .navigationBarItems(
            leading: Button("取消") { isPresented = false }
        )
    }

    private func addCategory() {
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.icon = icon
        newCategory.createdAt = Date()
        
        print("尝试保存分组:", newCategory.name ?? "nil")
        print("context persistentStoreCoordinator:", context.persistentStoreCoordinator != nil)
        
        do {
            try context.save()
            print("✅ 保存成功: \(name)")
            isPresented = false
        } catch let nserror as NSError {
            print("❌ 保存分组失败:", nserror, nserror.userInfo)
        } catch {
            print("❌ 保存分组失败: 未知错误")
        }
    }
}
