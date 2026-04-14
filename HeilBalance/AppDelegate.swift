//
//  AppDelegate.swift
//  HeilBalance
//
//  Created by Hugo on 03.04.26.
//


import UserNotifications

func scheduleDailyWorkoutReminder(note: String, hours: Int, mins: Int) {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("允许通知")
        }
    }
    
    let content = UNMutableNotificationContent()
    content.title = "锻炼时间 💪"
    content.body = note
    content.sound = .default
    
    var dateComponents = DateComponents()
    dateComponents.hour = hours
    dateComponents.minute = mins
    
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: true
    )
    
    let request = UNNotificationRequest(
        identifier: "daily_workout",
        content: content,
        trigger: trigger
    )
    
    center.add(request)
}
