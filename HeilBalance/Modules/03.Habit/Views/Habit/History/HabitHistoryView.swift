//
//  HabitHistoryView.swift
//  Habit
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct HabitHistoryView: View {
    
    @State private var showingCalendar = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("打卡历史")
                .font(.headline)
                .padding(.leading)
            
            Button(action: {
                showingCalendar = true
            }) {
                HStack {
                    Text("查看本月日历")
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarSheetView() // ⚠️ 注意：habits 来源不明，需定义
        }
    }
}
