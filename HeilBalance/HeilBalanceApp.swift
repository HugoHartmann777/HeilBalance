//
//  HeilBalanceApp.swift
//  HeilBalance
//
//  Created by Hugo on 23.02.26.
//

import SwiftUI



enum AppLanguage: String {
    case system       // 跟随系统
    case zh_Hans      // 中文
    case en           // 英文
}

@main
struct HeilBalanceApp: App {
    
    @AppStorage("AppLanguage") private var storedLanguage: String = AppLanguage.system.rawValue
    
    private var appLocale: Locale {
        if storedLanguage == AppLanguage.system.rawValue {
            return .autoupdatingCurrent
        } else {
            return Locale(identifier: storedLanguage)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, appLocale)
        }
    }
}
