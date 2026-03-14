//
//  GenericTestView.swift
//  HeilBalance
//
//  Created by Hugo on 09.03.26.
//

import SwiftUI

struct GenericTestView: View {
    
    @ObservedObject var lang = LanguageManager.shared
    
    let testData: TestData
    @State private var currentIndex = 0
    @State private var scores: [String: Int] = [:]
    @State private var showResult = false
    
    var body: some View {
        VStack {
            if showResult {
                resultView
            } else {
                testView
            }
        }
        .padding()
        .animation(.easeInOut, value: showResult)
        .onAppear {
            for type in testData.types { scores[type.id] = 0 }
        }
    }
    
    private var testView: some View {
        VStack(spacing: 30) {
            Text(testData.title).font(.title).bold()
            Text(lang.localizedString("第 \(currentIndex + 1) 题 / \(testData.questions.count)")).foregroundColor(.secondary)
            Text(testData.questions[currentIndex].text).font(.title3).multilineTextAlignment(.center).padding()
            
            VStack(spacing: 15) {
                answerButton(title: lang.localizedString("从不"), score: 0)
                answerButton(title: lang.localizedString("偶尔"), score: 1)
                answerButton(title: lang.localizedString("经常"), score: 2)
                answerButton(title: lang.localizedString("总是"), score: 3)
            }
        }
    }
    
    private func answerButton(title: String, score: Int) -> some View {
        Button(action: {
            let type = testData.questions[currentIndex].type
            scores[type, default: 0] += score
            if currentIndex < testData.questions.count - 1 { currentIndex += 1 } else { showResult = true }
        }) {
            Text(title).frame(maxWidth: .infinity).padding().background(Color.blue.opacity(0.1)).cornerRadius(12)
        }
    }
    
    private var resultView: some View {
        let maxScoreEntry = scores.max { $0.value < $1.value }
        let resultType = testData.types.first { $0.id == maxScoreEntry?.key }
        
        return VStack(spacing: 20) {
            Text(lang.localizedString("测试结果")).font(.largeTitle).bold()
            if let resultType = resultType {
                Text(resultType.name).font(.title2).foregroundColor(.blue)
                Text(resultType.description).multilineTextAlignment(.center).padding()
            }
            Button(lang.localizedString("重新测试")) { resetTest() }.padding()
        }
    }
    
    private func resetTest() {
        currentIndex = 0
        for key in scores.keys { scores[key] = 0 }
        showResult = false
    }
}
