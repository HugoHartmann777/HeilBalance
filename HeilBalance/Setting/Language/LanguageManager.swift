import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var language: String = UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.current.languageCode ?? "en" {
        didSet {
            UserDefaults.standard.set(language, forKey: "appLanguage")
        }
    }
    
    private var bundle: Bundle? {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            return Bundle(path: path)
        }
        return nil
    }
    
    func localizedString(_ key: String) -> String {
        bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
