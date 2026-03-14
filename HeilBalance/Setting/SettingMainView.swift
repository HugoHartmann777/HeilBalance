//
//  SettingMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//


import SwiftUI

struct SettingMainView: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: TermsView()) {
                    Label("使用条款", systemImage: "doc.text")
                }
                
                NavigationLink(destination: LanguageSettingsView()) {
                    Label("语言设置", systemImage: "globe")
                }
                
                Button(action: {
                    if let url = URL(string: "https://twitter.com/HeilBalance") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label("在 X 上关注我们", systemImage: "person.crop.circle.badge.plus")
                }
            }
            .navigationTitle("设置")
        }
    }
}




