import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var cdHelper: CoreDataHelper { CoreDataHelper(context: viewContext) }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default
    ) private var categorys: FetchedResults<Category>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        predicate: NSPredicate(format: "isRemoved == false && isArchived == false"),
        animation: .default
    ) private var unRemovedHabits: FetchedResults<Habit>
    
    @State private var showingNewHabitSheet = false
    @State private var selectedHabit: Habit? = nil

    private func isHabitScheduledToday(_ habit: Habit) -> Bool {
        guard let days = habit.repeatDays as? [Int] else { return true }
        
        // 如果没有设置重复日期，默认每天都做
        if days.isEmpty {
            return true
        }
        
        // 转换为“周一=1 ... 周日=7”
        let weekday = Calendar.current.component(.weekday, from: Date())
        let converted = weekday == 1 ? 7 : weekday - 1
        
        return days.contains(converted)
    }

    var body: some View {
        VStack {
            if unRemovedHabits.isEmpty {
                HabitEmptyView()
                // 新建按钮
                Section {
                    Button(action: {
                        showingNewHabitSheet = true
                    }) {
                        Text("培养一个新习惯")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
            } else {
                List {
                    ForEach(categorys) { category in
                        let habits = (category.habits as? Set<Habit>)?
                            .filter { $0.isRemoved == false && $0.isArchived == false } ?? []
                        
                        let todayHabits = habits.filter { isHabitScheduledToday($0) }
                        let otherHabits = habits.filter { !isHabitScheduledToday($0) }
                        
                        if !todayHabits.isEmpty || !otherHabits.isEmpty {
                            Section(header: CategoryHeaderView(category: category)) {
                                
                                // 今天要做
                                if !todayHabits.isEmpty {
                                    Text("🔥 今天要做")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    
                                    ForEach(todayHabits.sorted { ($0.name ?? "") < ($1.name ?? "") }) { habit in
                                        HabitRowView(habit: habit)
                                            .onTapGesture {
                                                selectedHabit = habit
                                            }
                                    }
                                }
                                
                                // 分隔线
                                if !todayHabits.isEmpty && !otherHabits.isEmpty {
                                    Divider()
                                        .padding(.vertical, 4)
                                }
                                
                                // 今天不用做
                                if !otherHabits.isEmpty {
                                    Text("😌 今天不用做")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    ForEach(otherHabits.sorted { ($0.name ?? "") < ($1.name ?? "") }) { habit in
                                        HabitRowView(habit: habit)
                                            .opacity(0.6)
                                            .onTapGesture {
                                                selectedHabit = habit
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $showingNewHabitSheet) {
            CreateHabitView()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(item: $selectedHabit) { habit in
            HabitDetailView(habit: habit)
        }
    }
}

struct CategoryHeaderView: View {
    var category: Category
    
    var body: some View {
        HStack {
            Image(systemName: category.icon ?? "folder")
                .foregroundColor(.orange)
            Text(self.category.name ?? "未知分组")
                .font(.headline)
        }
    }
}
