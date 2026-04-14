//
//  NotificationManager.swift
//  HeilBalance
//
//  Created by Hugo on 03.04.26.
//

import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("📢 permission = \(granted)")
            
            if let error = error {
                print("❌ error = \(error)")
            }
            
            if granted {
                print("通知权限已允许")
            } else {
                print("通知权限被拒绝")
            }
        }
    }

    //func scheduleHabitReminder(habitId: String, title: String, body: String, hour: Int, minute: Int)
    func scheduleHabitReminder(
        habitId: String,
        reminderId: String,
        title: String,
        body: String,
        hour: Int,
        minute: Int
    ){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "habit_\(habitId)_\(reminderId)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelHabitReminder(habitId: String, reminderId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["habit_\(habitId)_\(reminderId)"]
        )
    }

    func scheduleDailyReminder(hour: Int, minute: Int) {
        scheduleHabitReminder(
            habitId: "daily_exercise_reminder",
            reminderId: "default",
            title: "锻炼提醒 💪",
            body: "该运动啦！",
            hour: hour,
            minute: minute
        )
    }
}
