//
//  AddHabitNoteView.swift
//  MindZen
//
//  Created by Hugo on 22.09.25.
//

import SwiftUI
import CoreData

struct AddHabitNoteView: View {
    @ObservedObject var habit: Habit
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss   // 用于关闭页面

    @State private var habitNote: String = ""     // 输入框绑定的内容

    var body: some View {
        VStack(spacing: 16) {
            Text("添加记录")
                .font(.headline)

            TextEditor(text: $habitNote)
                .frame(height: 320)
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5))
                )

            Button(action: saveNote) {
                Text("保存")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(habitNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Spacer()
        }
        .padding()
    }

    private func saveNote() {
        let targetDate = Date()
        let start = Calendar.current.startOfDay(for: targetDate) as NSDate
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start as Date)! as NSDate

        let fetchRequest: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@ AND (date >= %@ AND date < %@)", habit, start, end)
        fetchRequest.fetchLimit = 1

        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingLog = results.first {
                // 已存在今天的记录 → 更新 note
                existingLog.note = habitNote
                print("✅ 修改日志 note 成功！")
            } else {
                // 不存在 → 新建
                let newLog = HabitLog(context: viewContext)
                newLog.id = UUID()
                newLog.date = targetDate
                newLog.note = habitNote
                newLog.habit = habit
                habit.addToHabitLogs(newLog)
                print("✅ 新建日志并添加 note 成功！")
            }
            try viewContext.save()
            dismiss()
        } catch {
            print("❌ 保存失败: \(error.localizedDescription)")
        }
    }
}
