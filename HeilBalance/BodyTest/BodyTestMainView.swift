//
//  BodyTestMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//


import SwiftUI
import AVKit

struct BodyTestMainView: View {
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("健康自测")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    if let questionnaire = loadQuestionnaire(from: "TiZhiTest") {
                        TestMenuCard(title: lang.localizedString("中医体质自我评估"), systemImage: "figure.mind.and.body") {
                            DynamicTestView(questionnaire: questionnaire, types: questionnaire.types)
                        }
                    } else {
                        Text("Error⚠️")
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct TestMenuCard<Destination: View>: View {
    
    let title: String
    let systemImage: String
    let destination: Destination
    
    init(title: String,
         systemImage: String,
         @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(.brown)
                    .frame(width: 40)
                
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
