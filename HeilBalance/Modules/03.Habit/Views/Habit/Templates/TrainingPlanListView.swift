//import SwiftUI
//import CoreData
//
//struct TrainingPlanListView: View {
//    @FetchRequest(
//        entity: TrainingPlan.entity(),
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \TrainingPlan.sort, ascending: true)
//        ]
//    ) var plans: FetchedResults<TrainingPlan>
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    ForEach(plans, id: \.id) { plan in
//                        TrainingDayCardView(plan: plan)
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("训练计划")
//        }
//    }
//}
//
//struct TrainingDayCardView: View {
//    @ObservedObject var plan: TrainingPlan
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // 标题信息
//            HStack {
//                Text(plan.date ?? "某天")
//                    .font(.title2)
//                    .bold()
//                Spacer()
//                Text(plan.type ?? "")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//
//            Text("轮数：\(plan.rounds) × 休息：\(plan.restBetweenRounds ?? "")")
//                .font(.caption)
//
//            Divider()
//
//            
//            Text("动作数量：\(plan.exercisesArray.count)")
//                .font(.caption)
//                .foregroundColor(.blue)
//            // 训练动作列表
//            ForEach(plan.exercisesArray) { exercise in
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(exercise.name ?? "未命名")
//                        .font(.headline)
//
//                    HStack(spacing: 10) {
//                        if let reps = exercise.reps, !reps.isEmpty {
//                            Label(reps, systemImage: "repeat")
//                        }
//                        if let duration = exercise.duration, !duration.isEmpty {
//                            Label(duration, systemImage: "timer")
//                        }
//                        if let rest = exercise.rest, !rest.isEmpty {
//                            Label("Rest: \(rest)", systemImage: "pause")
//                                .foregroundColor(.secondary)
//                        }
//
//                        Spacer()
//
//                        Image(systemName: exercise.done ? "checkmark.circle.fill" : "circle")
//                            .foregroundColor(exercise.done ? .green : .gray)
//                    }
//                    .font(.caption)
//                }
//                .padding(.vertical, 4)
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color(.systemGray6))
//                .shadow(radius: 3)
//        )
//        .onAppear() {
//            AppLogger.debug("plan.date = \(plan.date)")
//        }
//    }
//}
//
//extension TrainingPlan {
//    var exercisesArray: [Exercise] {
//        let set = exercises as? Set<Exercise> ?? []
//        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
//    }
//}
