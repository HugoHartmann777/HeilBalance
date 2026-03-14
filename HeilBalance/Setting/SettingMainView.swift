//
//  SettingMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//


import SwiftUI

struct SettingMainView: View {
    
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        NavigationStack {
            List {

                NavigationLink(destination: LanguageSettingsView()) {
                    Label(lang.localizedString("language_settings"), systemImage: "globe")
                }
                
                Button(action: {
                    if let url = URL(string: "https://twitter.com/HeilBalance") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label(lang.localizedString("follow_us_X"), systemImage: "person.crop.circle.badge.plus")
                }
            }
            .navigationTitle(lang.localizedString("设置"))
        }
    }
}




