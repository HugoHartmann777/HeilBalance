//
//
//import SwiftUI
//
//<<<<<<< HEAD
//struct LanguageSettingsView: View {
//    @ObservedObject var lang = LanguageManager.shared
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                Section(header: Text(lang.localizedString("language_settings"))
//                    .font(.title3.bold())
//                    .foregroundColor(.primary)) {
//                        
//                        languageRow(title: "中文", code: "zh-Hans", systemIcon: "character.book.closed")
//                        languageRow(title: "English", code: "en", systemIcon: "globe")
//                        languageRow(title: "Deutsch", code: "de", systemIcon: "text.book.closed")
//                    }
//=======
//
//struct TermsView: View {
//    @ObservedObject var lang = LanguageManager.shared
//    var body: some View {
//        Text(lang.localizedString("terms_content"))
//            .padding()
//            .navigationTitle(lang.localizedString("terms"))
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//
//struct LanguageSettingsView: View {
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var showConfirm = false
//    @State private var selectedLanguage: String = ""
//    @ObservedObject var lang = LanguageManager.shared
//        
//    private var alertTitle: String {
//        switch selectedLanguage {
//        case "en": return "Confirm language change?"
//        case "de": return "Sprache wirklich ändern?"
//        default: return "确认切换语言？"
//        }
//    }
//
//    private var confirmText: String {
//        switch selectedLanguage {
//        case "en": return "Confirm"
//        case "de": return "Bestätigen"
//        default: return "确定"
//        }
//    }
//
//    private var cancelText: String {
//        switch selectedLanguage {
//        case "en": return "Cancel"
//        case "de": return "Abbrechen"
//        default: return "取消"
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Button("中文") {
//                selectedLanguage = "zh-Hans"
//                showConfirm = true
//            }
//            Button("English") {
//                selectedLanguage = "en"
//                showConfirm = true
//            }
//            Button("Deutsch") {
//                selectedLanguage = "de"
//                showConfirm = true
//>>>>>>> 0280098 (添加八段锦的翻译)
//            }
//            .listStyle(.insetGrouped) // iOS 原生分组列表风格
//            .navigationTitle(lang.localizedString("language_settings"))
//            .navigationBarTitleDisplayMode(.inline)
//        }
//<<<<<<< HEAD
//    }
//    
//    @ViewBuilder
//    private func languageRow(title: String, code: String, systemIcon: String) -> some View {
//        Button(action: {
//            withAnimation(.easeInOut) {
//                LanguageManager.shared.language = code
//            }
//        }) {
//            HStack {
//                Image(systemName: systemIcon)
//                    .foregroundColor(.accentColor)
//                    .frame(width: 30)
//                Text(title)
//                    .foregroundColor(.primary)
//                Spacer()
//                if LanguageManager.shared.language == code {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.accentColor)
//                        .transition(.scale.combined(with: .opacity))
//                }
//            }
//            .padding(.vertical, 8)
//            .contentShape(Rectangle()) // ⚡ 整行点击
//        }
//        .buttonStyle(PlainButtonStyle())
//=======
//        .font(.title2)
//        .padding()
//        .navigationTitle(lang.localizedString("language_settings"))
//        .navigationBarTitleDisplayMode(.inline)
//        .alert(alertTitle, isPresented: $showConfirm) {
//            Button(cancelText, role: .cancel) {}
//            Button(confirmText) {
//                LanguageManager.shared.language = selectedLanguage
//                dismiss()
//            }
//        }
//>>>>>>> 0280098 (添加八段锦的翻译)
//    }
//}
import SwiftUI

struct LanguageSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var lang = LanguageManager.shared
    
    @State private var showConfirm = false
    @State private var selectedLanguage: String = ""
    
    private var alertTitle: String {
        switch selectedLanguage {
        case "en": return "Confirm language change?"
        case "de": return "Sprache wirklich ändern?"
        default: return "确认切换语言？"
        }
    }

    private var confirmText: String {
        switch selectedLanguage {
        case "en": return "Confirm"
        case "de": return "Bestätigen"
        default: return "确定"
        }
    }

    private var cancelText: String {
        switch selectedLanguage {
        case "en": return "Cancel"
        case "de": return "Abbrechen"
        default: return "取消"
        }
    }
    
    // 页面标题显示当前语言的“语言设置”
    private var pageTitle: String {
        lang.localizedString("language_settings")
    }

    var body: some View {
        VStack(spacing: 20) {
            // 按钮显示为目标语言名称
            Button("中文") {
                selectedLanguage = "zh-Hans"
                showConfirm = true
            }
            Button("English") {
                selectedLanguage = "en"
                showConfirm = true
            }
            Button("Deutsch") {
                selectedLanguage = "de"
                showConfirm = true
            }
        }
        .font(.title2)
        .padding()
        .navigationTitle(pageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showConfirm) {
            Button(cancelText, role: .cancel) {}
            Button(confirmText) {
                LanguageManager.shared.currentLanguage = selectedLanguage
                dismiss()
            }
        }
    }
}
