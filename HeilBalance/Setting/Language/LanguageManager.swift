//import SwiftUI
//import Combine
//
//class LanguageManager: ObservableObject {
//    static let shared = LanguageManager()
//    
//    private init() {
//        if let saved = UserDefaults.standard.string(forKey: "appLanguage") {
//            language = saved
//        } else {
//            let system = Locale.preferredLanguages.first ?? "en"
//
//            if system.hasPrefix("zh") {
//                language = "zh-Hans"
//            } else if system.hasPrefix("de") {
//                language = "de"
//            } else {
//                language = "en"
//            }
//        }
//    }
//    
//    @Published var language: String {
//        didSet {
//            UserDefaults.standard.set(language, forKey: "appLanguage")
//        }
//    }
//    
//    private var bundle: Bundle? {
//        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
//            return Bundle(path: path)
//        }
//        return nil
//    }
//    
//    func localizedString(_ key: String) -> String {
//        bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
//    }
//}


import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String = "zh" // 默认中文
    
    func localizedString(_ key: String) -> String {
        // 返回对应语言的翻译
        switch currentLanguage {
        case "en":
            return englishDict[key] ?? key
        default:
            return chineseDict[key] ?? key
        }
    }
    
    private let englishDict: [String: String] = [
        "使用条款": "Terms of Use",
        "语言设置": "Language Settings",
        "在 X 上关注我们": "Follow us on X",
        "设置": "Settings"
    ]
    
    private let chineseDict: [String: String] = [
        "使用条款": "使用条款",
        "语言设置": "语言设置",
        "在 X 上关注我们": "在 X 上关注我们",
        "设置": "设置"
    ]
}
