import SwiftUI
import CoreData

struct HabitFormView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: HabitFormViewModel
    
    @State private var showIconPicker = false
    @State private var showGoalPicker = false
    @State private var isNavigatingToTemplate = false

    init(habit: Habit? = nil, isEditing: Bool, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitFormViewModel(
            habit: habit,
            context: context,
            isEditing: isEditing))
    }
    
    var body: some View {
        Form {
            iconSection
            settingsSection
            categorySection
            extraSection
        }
        .navigationTitle(viewModel.isEditing ? "编辑习惯" : "新建习惯")
        .navigationBarItems(
            leading: Button("取消") { dismiss() },
            trailing: Button("保存") {
                viewModel.save()
                dismiss()
            }
                .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        )
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    isNavigatingToTemplate = true
//                }) {
//                    Text("从模版导入")
//                }
//            }
//        }
//        .background(
//            NavigationLink(
//                destination: HabitTemplateListView(),
//                isActive: $isNavigatingToTemplate,
//                label: { EmptyView() }
//            )
//        )
    }
    
    private var categorySection: some View {
        Section {
            // 显示分组名逻辑
            if let selectedCategory = viewModel.selectedCategory {
                // 选中了分组，显示分组名
                Text(selectedCategory.name ?? "默认分组")
            } else {
                // selectedCategory 为 nil，显示默认分组
                Text("默认分组")
            }
            CategoryPickerRow(selectedCategory: $viewModel.selectedCategory)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private var iconSection: some View {
        Section {
            HStack(spacing: 16) {
                IconPickerButton(iconName: viewModel.icon, action: { showIconPicker = true })
                TextField("请输入习惯名称", text: $viewModel.name)
                    .font(.system(size: 18, weight: .medium))
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
            }
        }
    }
    
    private var settingsSection: some View {
        Section {
            RepeatDaysRow(selectedDays: $viewModel.repeatDays)
            GoalPickerRow(goalNumber: $viewModel.goalNumber,
                          goalUnit: $viewModel.goalUnit,
                          goalFrequency: $viewModel.goalFrequency)
            TimeOfDayPicker(selectedTime: $viewModel.timeOfDay)
        }
    }
    
    private var extraSection: some View {
        Section {
            ReminderPicker(reminderTime: $viewModel.reminderTime)
            ChecklistRow(checklist: $viewModel.checklist)
            StartDatePicker(startDate: $viewModel.startDate)
        }
    }
}
