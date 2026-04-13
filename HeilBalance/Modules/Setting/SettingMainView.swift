import SwiftUI

struct TermsView: View {
    var body: some View {
        Text("这里是使用条款页面")
    }
}

struct SettingMainView: View {
    
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                // 使用条款
                NavigationLink(destination: TermsView()) {
                    Label(lang.localizedString("使用条款"), systemImage: "doc.text")
                }
                
                // 语言设置
                NavigationLink(destination: LanguageSettingsView()) {
                    Label(lang.localizedString("语言设置"), systemImage: "globe")
                }
                
                // 在 X 上关注我们
                Button(action: {
                    if let url = URL(string: "https://twitter.com/HeilBalance") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label(lang.localizedString("在 X 上关注我们"), systemImage: "person.crop.circle.badge.plus")
                }
            }
            .navigationTitle(lang.localizedString("设置"))
        }
    }
}
