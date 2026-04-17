//
//  HabitStatisticsView.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct HabitStatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var cdHelper: CoreDataHelper { CoreDataHelper(context: viewContext) }
    let habit: Habit
    @Environment(\.dismiss) var dismiss
    
    @State private var showEditHabit: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 连胜天数大展示
            VStack(spacing: 8) {
                Text("连续打卡")
                    .font(.headline)
                Text("\(cdHelper.getConsecutiveCompletedDays(for: habit)) 天")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
            // 最近7天圆圈视图
            recent7DaysView
            
            // 2x2方块统计
            gridStatisticsView
        }
        .padding()
    }
    
    // MARK: - 最近7天打卡视图
    @State private var selectedDay: Date? = nil
    @State private var showingActionSheet = false
    private var recent7DaysView: some View {
        let days = cdHelper.getLast7DaysCompletion(for: habit)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "E"
        
    @ObservedObject var lang = LanguageManager.shared
        let startDate = Calendar.current.startOfDay(for: habit.startDate ?? Date.distantFuture)

        return HStack(spacing: 16) {
            ForEach(days, id: \.date) { day in
                let isBeforeStart = day.date < startDate

                VStack(spacing: 6) {
                    Button {
                        selectedDay = day.date
                        showingActionSheet = true
                    } label: {
                        Circle()
                            .fill(
                                isBeforeStart ? Color.gray.opacity(0.3) :
                                day.completed ? Color.green :
                                day.skipped ? Color.orange :
                                Color.red
                            )
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isBeforeStart) // ⛔ 禁用旧日期
                    .opacity(isBeforeStart ? 0.7 : 1.0) // 可选：加点透明度

                    Text(formatter.string(from: day.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .confirmationDialog("选择操作", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("打卡") {
                if let date = selectedDay {
                    cdHelper.markHabitCompleted(for: habit, on: date)
                }
            }
            Button("跳过") {
                if let date = selectedDay {
                    cdHelper.markHabitSkipped(for: habit, on: date)
                }
            }
            Button("未打卡") {
                if let date = selectedDay {
                    cdHelper.markHabitUnchecked(for: habit, on: date)
                }
            }
            Button("取消", role: .cancel) { }
        }
    }
    
    // ✅ 移到 recent7DaysView 外部
    private var gridStatisticsView: some View {
        let stats = cdHelper.calculateStats(for: habit)
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            statBox(title: "已完成", value: "\(stats.completed)", color: .green)
            statBox(title: "已跳过", value: "\(stats.skipped)", color: .orange)
            statBox(title: "未完成", value: "\(stats.unchecked)", color: .red)
            statBox(title: "总天数", value: "\(stats.totalDays)", color: .blue)
        }
    }
    
    // ✅ 也移到外部
    private func statBox(title: String, value: String, color: Color) -> some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
