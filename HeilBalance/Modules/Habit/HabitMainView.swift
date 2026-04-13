import SwiftUI
import WebKit


struct HabitMainView: View {
    @State private var habits: [Habit] = [
        Habit(name: "喝水 8 杯", completedDates: []),
        Habit(name: "运动 30 分钟", completedDates: []),
        Habit(name: "阅读 20 分钟", completedDates: [])
    ]
    
    @State private var newHabitName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                // 添加新习惯
                HStack {
                    TextField("新增习惯...", text: $newHabitName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        addHabit()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding()
                
                // 今日日期
                Text("今天：\(formattedDate(Date()))")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // 习惯列表
                List {
                    ForEach(habits.indices, id: \.self) { index in
                        HabitRowView(
                            habit: habits[index],
                            isCompletedToday: isCompletedToday(habits[index]),
                            toggleAction: {
                                toggleHabit(index)
                            }
                        )
                    }
                    .onDelete(perform: deleteHabit)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("习惯打卡")
        }
    }
    
    // MARK: - 功能方法
    
    private func addHabit() {
        guard !newHabitName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        habits.append(Habit(name: newHabitName, completedDates: []))
        newHabitName = ""
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    private func toggleHabit(_ index: Int) {
        let today = startOfDay(Date())
        
        if habits[index].completedDates.contains(today) {
            habits[index].completedDates.removeAll { $0 == today }
        } else {
            habits[index].completedDates.append(today)
        }
    }
    
    private func isCompletedToday(_ habit: Habit) -> Bool {
        let today = startOfDay(Date())
        return habit.completedDates.contains(today)
    }
    
    private func startOfDay(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
}

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var completedDates: [Date]
}

struct HabitRowView: View {
    let habit: Habit
    let isCompletedToday: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.body)
                
                Text("累计打卡：\(habit.completedDates.count) 天")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: toggleAction) {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompletedToday ? .green : .gray)
            }
        }
        .padding(.vertical, 5)
    }
}
