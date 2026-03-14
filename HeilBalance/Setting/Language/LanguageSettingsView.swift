

import SwiftUI

struct LanguageSettingsView: View {
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(lang.localizedString("language_settings"))
                    .font(.title3.bold())
                    .foregroundColor(.primary)) {
                        
                        languageRow(title: "中文", code: "zh-Hans", systemIcon: "character.book.closed")
                        languageRow(title: "English", code: "en", systemIcon: "globe")
                        languageRow(title: "Deutsch", code: "de", systemIcon: "text.book.closed")
                    }
            }
            .listStyle(.insetGrouped) // iOS 原生分组列表风格
            .navigationTitle(lang.localizedString("language_settings"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func languageRow(title: String, code: String, systemIcon: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                LanguageManager.shared.language = code
            }
        }) {
            HStack {
                Image(systemName: systemIcon)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if LanguageManager.shared.language == code {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle()) // ⚡ 整行点击
        }
        .buttonStyle(PlainButtonStyle())
    }
}
