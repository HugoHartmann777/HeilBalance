import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    // 当前语言
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "appLanguage")
        }
    }

    private init() {
        if let saved = UserDefaults.standard.string(forKey: "appLanguage") {
            currentLanguage = saved
        } else {
            let system = Locale.preferredLanguages.first ?? "en"

            if system.hasPrefix("zh") {
                currentLanguage = "zh-Hans"
            } else if system.hasPrefix("de") {
                currentLanguage = "de"
            } else {
                currentLanguage = "en"
            }
        }
    }

    // 根据当前语言获取 Bundle
    private var bundle: Bundle? {
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            return Bundle(path: path)
        }
        return nil
    }

    // 获取本地化字符串
    func localizedString(_ key: String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
