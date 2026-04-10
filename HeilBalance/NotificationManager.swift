//
//  NotificationManager.swift
//  HeilBalance
//
//  Created by Hugo on 03.04.26.
//

import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    func scheduleDailyReminder(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "锻炼提醒 💪"
        content.body = "该运动啦！"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily_exercise_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
