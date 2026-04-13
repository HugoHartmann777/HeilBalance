//
//  HabitEmptyView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct HabitEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "scribble.variable")
                .resizable()
                .frame(maxWidth: 100, maxHeight: 100)
                .foregroundColor(.gray)
            Text("欢迎使用打卡日记")
                .font(.headline)
            Text("添加一个新习惯，开始你的旅程吧！")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top, 100)
    }
}
