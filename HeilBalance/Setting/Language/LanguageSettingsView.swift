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
        .onChange(of: lang.currentLanguage) { _ in
            // 当语言变化时强制刷新页面标题
        }
        .alert(alertTitle, isPresented: $showConfirm) {
            Button(cancelText, role: .cancel) {}
            Button(confirmText) {
                lang.currentLanguage = selectedLanguage
                dismiss()
            }
        }
    }
}
