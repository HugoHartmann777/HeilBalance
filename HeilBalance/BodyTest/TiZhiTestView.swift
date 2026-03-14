//
//  TiZhiTestView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import Foundation

// MARK: - 通用测试视图
struct TiZhiTestView: View {
    let testData: TestData
    
    @State private var currentIndex = 0
    @State private var scores: [String: Int] = [:]
    @State private var showResult = false
    
    var body: some View {
        VStack {
            if showResult { resultView } else { testView }
        }
        .padding()
        .animation(.easeInOut, value: showResult)
        .onAppear {
            for type in testData.types { scores[type.id] = 0 }
        }
    }
    
    // MARK: 测试题视图
    private var testView: some View {
        VStack(spacing: 30) {
            Text(testData.title).font(.title).bold()
            
            Text("第 \(currentIndex + 1) 题 / \(testData.questions.count)")
                .foregroundColor(.secondary)
            
            Text(testData.questions[currentIndex].text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(spacing: 15) {
                answerButton(score: 0, title: "从不")
                answerButton(score: 1, title: "偶尔")
                answerButton(score: 2, title: "经常")
                answerButton(score: 3, title: "总是")
            }
        }
    }
    
    private func answerButton(score: Int, title: String) -> some View {
        Button(title) {
            let typeId = testData.questions[currentIndex].type
            scores[typeId, default: 0] += score
            
            if currentIndex < testData.questions.count - 1 { currentIndex += 1 }
            else { showResult = true }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: 结果视图
    private var resultView: some View {
        let maxEntry = scores.max { $0.value < $1.value }
        let resultType = testData.types.first { $0.id == maxEntry?.key }
        
        return VStack(spacing: 20) {
            Text("测试结果").font(.largeTitle).bold()
            
            if let resultType = resultType {
                Text(resultType.name)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(resultType.description)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Button("重新测试") { resetTest() }.padding()
        }
    }
    
    private func resetTest() {
        currentIndex = 0
        for key in scores.keys { scores[key] = 0 }
        showResult = false
    }
}
