//
//  HabitInformationView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct HabitInformationView: View {
    let habit: Habit
    
    var body: some View {
        Text("名称: \(habit.name ?? "未知名称")")
    }
}
