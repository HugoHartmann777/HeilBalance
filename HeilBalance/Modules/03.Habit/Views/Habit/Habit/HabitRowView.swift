import SwiftUI
import CoreData


// MARK: - 传入的habit已经过滤，isRemoved == false && isArchived == false
struct HabitRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var habit: Habit
    private var cdHelper: CoreDataHelper { CoreDataHelper(context: viewContext) }
    
    @State private var goalUnit: GoalDisplayUnit = .count
    @State private var goalFrequency: GoalDisplayFrequency = .everyTime
    
    // 查询今天的 log
    @FetchRequest var todayLogs: FetchedResults<HabitLog>

    init(habit: Habit) {
        self.habit = habit
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        _todayLogs = FetchRequest(
            entity: HabitLog.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "habit == %@ AND date >= %@ AND date < %@", habit, today as NSDate, tomorrow as NSDate),
            animation: .default
        )
    }

    var body: some View {
        let isCompleted = todayLogs.contains { $0.typeEnum == .completed }
        let isSkipped = todayLogs.contains { $0.typeEnum == .skipped }
        
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: habit.icon ?? "circle")
                .font(.title2)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name ?? "")
                    .font(.headline)
                    .foregroundColor(habit.isRemoved ? .gray : (isSkipped ? .red : .primary))
                    .strikethrough(cdHelper.isHabitCompletedToday(habit), color: cdHelper.isHabitCompletedToday(habit) ? .green : nil)
            
                Text("目标 \(habit.goalNumber) \(goalUnit.displayName) / \(goalFrequency.displayName)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text("累计打卡 \(cdHelper.getCompletedDays(for: habit)) 次") // 你可以用 habit 上的字段或 helper 方法
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .onAppear() {
                goalUnit = GoalUnitType(rawValue: habit.goalUnit ?? "")?.displayUnit ?? .count
                goalFrequency = GoalFrequencyType(rawValue: habit.goalFrequency ?? "")?.displayFrequency ?? .everyTime
            }

            Spacer()

            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            } else if isSkipped {
                Text("已跳过")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(10)
            } else {
                Button {
                    cdHelper.markHabitCompleted(for: habit)
                } label: {
                    Text("未打卡")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                let helper = CoreDataHelper(context: viewContext)
                if isCompleted || isSkipped {
                    helper.resetTodayStatus(for: habit)
                } else {
                    helper.markHabitSkipped(for: habit)
                }
            } label: {
                Label(isCompleted || isSkipped ? "撤回" : "跳过", systemImage: "arrow.uturn.backward")
            }
            .tint(isCompleted || isSkipped ? .orange : .gray)
        }
    }
}
