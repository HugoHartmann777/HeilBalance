//
//  AppDelegate.swift
//  HeilBalance
//
//  Created by Hugo on 03.04.26.
//


import UserNotifications

func scheduleDailyWorkoutReminder() {
    let center = UNUserNotificationCenter.current()
    
    // 1. 请求权限
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("允许通知")
        }
    }
    
    // 2. 通知内容
    let content = UNMutableNotificationContent()
    content.title = "锻炼时间 💪"
    content.body = "现在是10点，该去锻炼啦！"
    content.sound = .default
    
    // 3. 设置时间（每天10:00）
    var dateComponents = DateComponents()
    dateComponents.hour = 11
    dateComponents.minute = 10
    
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: true
    )
    
    // 4. 创建请求
    let request = UNNotificationRequest(
        identifier: "daily_workout",
        content: content,
        trigger: trigger
    )
    
    // 添加通知
    center.add(request)
}
