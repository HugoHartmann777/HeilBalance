//
//  GoalPickerRow.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI
struct GoalPickerRow: View {
    @Binding var goalNumber: Int
    @Binding var goalUnit: String
    @Binding var goalFrequency: String

    var body: some View {
        NavigationLink(destination:
            GoalOptionsView(
                goalNumber: $goalNumber,
                goalUnit: $goalUnit,
                goalFrequency: $goalFrequency
            )
        ) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("目标")
                    Text("\(goalNumber) \(getUnitDisplayName(for: goalUnit)) / \(getFrequencyDisplayName(for: goalFrequency))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct GoalOptionsView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var goalNumber: Int
    @Binding var goalUnit: String     // 传入的是 GoalUnitType 的 rawValue（如 "timeDays"）
    @Binding var goalFrequency: String  // 传入的是 GoalFrequencyType 的 rawValue（如 "perDay"）

    let numbers = Array(0...1000)

    @State private var selectedNumber: Int = 0
    @State private var selectedUnit: GoalDisplayUnit = .count
    @State private var selectedFrequency: GoalDisplayFrequency = .everyTime

    var body: some View {
        VStack {
            Text("设置目标")
                .font(.headline)
                .padding(.bottom, 20)

            HStack {
                Picker(selection: $selectedNumber, label: Text("")) {
                    ForEach(1..<numbers.count, id: \.self) { index in
                        Text("\(numbers[index])").tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)

                Picker(selection: $selectedUnit, label: Text("")) {
                    ForEach(GoalDisplayUnit.allCases, id: \.self) { unit in
                        Text(unit.displayName).tag(unit)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)

                Picker(selection: $selectedFrequency, label: Text("")) {
                    ForEach(GoalDisplayFrequency.allCases, id: \.self) { freq in
                        Text(freq.displayName).tag(freq)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 150)

            Text("目标：\(numbers[selectedNumber])\(selectedUnit.displayName) / \(selectedFrequency.displayName)")
                .padding(.top, 20)
                .font(.subheadline)
        }
        .padding()
        .navigationBarItems(
            trailing:
                Button("完成") {
                    goalNumber = numbers[selectedNumber]
                    goalUnit = selectedUnit.unitType.rawValue
                    goalFrequency = selectedFrequency.frequencyType.rawValue
                    print("完成 = \(goalNumber) \(selectedUnit.displayName) / \(selectedFrequency.displayName)")
                    dismiss()
                }
        )
        .onAppear {
            selectedNumber = goalNumber
            if let unitType = GoalUnitType(rawValue: goalUnit) {
                selectedUnit = unitType.displayUnit
            }
            if let frequencyType = GoalFrequencyType(rawValue: goalFrequency) {
                selectedFrequency = frequencyType.displayFrequency
            }
        }
    }
}
