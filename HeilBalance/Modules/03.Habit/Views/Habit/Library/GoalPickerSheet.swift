//
//  GoalPickerSheet.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI
import Combine

// MARK: - GoalPickerSheet 作为弹窗拆分

struct GoalPickerSheet: View {
    @ObservedObject var viewModel: HabitFormViewModel
    @Binding var isPresented: Bool

    let units = ["次", "分钟"]
    let frequencies = ["每天", "每周", "每月"]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("完成") {
                    isPresented = false
                }
                .padding()
            }
            Divider()
            HStack(spacing: 0) {
                Picker("数量", selection: $viewModel.goalNumber) {
                    ForEach(1...1000, id: \.self) { Text("\($0)").tag($0) }
                }
                .frame(maxWidth: .infinity)
                .pickerStyle(.wheel)

                Picker("单位", selection: $viewModel.goalUnit) {
                    ForEach(units, id: \.self) { Text($0).tag($0) }
                }
                .frame(maxWidth: .infinity)
                .pickerStyle(.wheel)

                Picker("频率", selection: $viewModel.goalFrequency) {
                    ForEach(frequencies, id: \.self) { Text($0).tag($0) }
                }
                .frame(maxWidth: .infinity)
                .pickerStyle(.wheel)
            }
            .frame(height: 200)
            Divider()
            Text("\(viewModel.goalNumber) \(viewModel.goalUnit) \(viewModel.goalFrequency)")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
}
