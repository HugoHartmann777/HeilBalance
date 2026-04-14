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
    
    init (){
        NotificationManager.shared.requestAuthorization()
        
        NotificationManager.shared.scheduleHabitReminder(
            habitId: "drink_water",
            reminderId: "1716",
            title: "喝水提醒 💧",
            body: "该喝水啦！",
            hour: 17,
            minute: 17
        )
        NotificationManager.shared.scheduleHabitReminder(
            habitId: "sleep",
            reminderId: "1716",
            title: "喝水提醒 💧",
            body: "该喝水啦！",
            hour: 17,
            minute: 18
        )
    }
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
