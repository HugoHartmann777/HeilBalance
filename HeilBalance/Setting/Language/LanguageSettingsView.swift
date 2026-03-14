import SwiftUI

//struct SettingMainView: View {
//    @ObservedObject var lang = LanguageManager.shared
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                NavigationLink(destination: TermsView()) {
//                    Label(lang.localizedString("terms"), systemImage: "doc.text")
//                }
//                
//                NavigationLink(destination: LanguageSettingsView()) {
//                    Label(lang.localizedString("language_settings"), systemImage: "globe")
//                }
//                
//                Button(action: {
//                    if let url = URL(string: "https://twitter.com/HeilBalance") {
//                        UIApplication.shared.open(url)
//                    }
//                }) {
//                    Label(lang.localizedString("follow_us"), systemImage: "person.crop.circle.badge.plus")
//                }
//            }
//            .navigationTitle(lang.localizedString("settings"))
//        }
//    }
//}


struct TermsView: View {
    @ObservedObject var lang = LanguageManager.shared
    var body: some View {
        Text(lang.localizedString("terms_content"))
            .padding()
            .navigationTitle(lang.localizedString("terms"))
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct LanguageSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("中文") {
                LanguageManager.shared.language = "zh-Hans"
            }
            Button("English") {
                LanguageManager.shared.language = "en"
            }
            Button("Deutsch") {
                LanguageManager.shared.language = "de"
            }
        }
        .font(.title2)
        .padding()
        .navigationTitle(LanguageManager.shared.localizedString("language_settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
