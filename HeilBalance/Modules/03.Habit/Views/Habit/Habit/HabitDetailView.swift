import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var cdHelper: CoreDataHelper { CoreDataHelper(context: viewContext) }
    @ObservedObject var habit: Habit
    @Environment(\.dismiss) var dismiss
    
    @State private var editSheet: Bool = false
    @State private var noteSheet: Bool = false
    @State private var showDeleteConfirm: Bool = false
    @State private var showArchiveConfirm: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HabitStatisticsView(habit: habit)
                    Divider()
                    // 🔥 显示所有 note
                    VStack(alignment: .leading, spacing: 12) {
                        Text("记录：")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        if sortedNotes.isEmpty {
                            Text("暂无记录")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        } else {
                            ForEach(sortedNotes, id: \.objectID) { log in
                                VStack(alignment: .leading, spacing: 4) {
                                    if let note = log.note, !note.isEmpty {
                                        Text(note)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                    }
                                    if let date = log.date {
                                        Text(date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                    }
                    
                }
                .padding()
            }
            .navigationTitle(habit.name ?? "习惯详情")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            noteSheet = true
                        }) {
                            Label("记录", systemImage: "plus")
                                .font(.system(size: 24))
                        }
                        
                        Divider()
                        
                        Button(action: {
                            editSheet = true
                        }) {
                            Label("编辑", systemImage: "pencil.circle")
                                .font(.system(size: 24))
                        }
                        
                        Button {
                            showArchiveConfirm = true
                        } label: {
                            Label("归档", systemImage: "archivebox")
                        }
                        .tint(.blue) // 影响图标颜色
                        
                        Button(role: .destructive, action: {
                            showDeleteConfirm = true
                        }) {
                            Label("删除", systemImage: "trash")
                                .font(.system(size: 24))
                        }
                    } label: {
                        ZStack {
                            Color.clear.frame(width: 44, height: 44)
                            Image(systemName: "ellipsis")
                                .foregroundColor(.primary)
                                .font(.title2)
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .sheet(isPresented: $noteSheet) {
                AddHabitNoteView(habit: habit)
            }
            .sheet(isPresented: $editSheet) {
                EditHabitView(habit: habit)
            }
            .confirmationDialog("确定要归档该习惯吗？", isPresented: $showArchiveConfirm, titleVisibility: .visible) {
                Button("归档", role: .destructive) {
                    cdHelper.markHabitArchived(for: habit)
                    dismiss()  // 删除后关闭详情页
                }
                Button("取消", role: .cancel) { }
            }
            .confirmationDialog("确定要删除该习惯吗？", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("删除", role: .destructive) {
                    cdHelper.markHabitRemoved(for: habit)
                    dismiss()  // 删除后关闭详情页
                }
                Button("取消", role: .cancel) { }
            }
        }
    }
    
    // MARK: - Notes 排序
    private var sortedNotes: [HabitLog] {
        let logs = habit.habitLogsArray.filter { ($0.note ?? "").isEmpty == false }
        return logs.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }
}


// MARK: - Habit 扩展
extension Habit {
    var habitLogsArray: [HabitLog] {
        (habitLogs as? Set<HabitLog>)?.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) } ?? []
    }
}
