//
//  Untitled.swift
//  GermanWordApp
//
//  Created by J on 5/5/25.
//
import SwiftUI
import Foundation
import Combine

extension View {
    func styleButton() -> some View {
        self
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 200, height: 60)
            .background(Color.accentColor)
            .clipShape(Capsule())
    }
}

enum Tab {
    case diary, progress, challenge, trashBin, settings
}

enum HabitFilter: String, CaseIterable {
    case all = "所有习惯"
    case dawn = "早上"
    case morning = "上午"
    case afternoon = "下午"
    case evening = "晚上"
    case incomplete = "未完成"
    case completed = "已完成"
}

extension DateFormatter {
    static let hourMinute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()
}





// MARK: - 显示单位
enum GoalDisplayUnit: String, CaseIterable {
    case count = "次"
    case volume = "升"
    case distance = "公里"
    case timeSeconds = "秒"
    case timeMinutes = "分钟"
    case timeHours = "小时"
    case timeDays = "天"

    var displayName: String {
        self.rawValue
    }

    var unitType: GoalUnitType {
        switch self {
        case .count:        return .count
        case .volume:       return .volume
        case .distance:     return .distance
        case .timeSeconds:  return .timeSeconds
        case .timeMinutes:  return .timeMinutes
        case .timeHours:    return .timeHours
        case .timeDays:     return .timeDays
        }
    }

    static func fromRaw(_ value: String) -> GoalDisplayUnit? {
        allCases.first(where: { $0.rawValue == value })
    }
}

// MARK: - 存储目标的单位逻辑类型（英文 rawValue）
enum GoalUnitType: String, CaseIterable {
    case count
    case volume
    case distance
    case timeSeconds
    case timeMinutes
    case timeHours
    case timeDays

    var displayUnit: GoalDisplayUnit {
        switch self {
        case .count:        return .count
        case .volume:       return .volume
        case .distance:     return .distance
        case .timeSeconds:  return .timeSeconds
        case .timeMinutes:  return .timeMinutes
        case .timeHours:    return .timeHours
        case .timeDays:     return .timeDays
        }
    }

    var displayName: String {
        displayUnit.displayName
    }
}

// MARK: - 显示频率
enum GoalDisplayFrequency: String, CaseIterable {
    case everyTime = "次"
    case perHour = "小时"
    case perDay = "天"
    case perWeek = "星期"
    case perMonth = "月"

    var displayName: String {
        self.rawValue
    }

    var frequencyType: GoalFrequencyType {
        switch self {
        case .everyTime:    return .everyTime
        case .perHour:      return .perHour
        case .perDay:       return .perDay
        case .perWeek:      return .perWeek
        case .perMonth:     return .perMonth
        }
    }
}

// MARK: - 频率逻辑类型（英文 rawValue）
enum GoalFrequencyType: String, CaseIterable {
    case everyTime
    case perHour
    case perDay
    case perWeek
    case perMonth

    var displayFrequency: GoalDisplayFrequency {
        switch self {
        case .everyTime:    return .everyTime
        case .perHour:      return .perHour
        case .perDay:       return .perDay
        case .perWeek:      return .perWeek
        case .perMonth:     return .perMonth
        }
    }

    var displayName: String {
        displayFrequency.displayName
    }
}

// MARK: - 显示名称函数（传入 rawValue 字符串）
func getUnitDisplayName(for goalUnitRawValue: String) -> String {
    let type = GoalUnitType(rawValue: goalUnitRawValue) ?? .count
    return type.displayName
}

func getFrequencyDisplayName(for goalFrequencyRawValue: String) -> String {
    let type = GoalFrequencyType(rawValue: goalFrequencyRawValue) ?? .everyTime
    return type.displayName
}


//
//// MARK: - 存储“目标”的单位和页面显示的关联
//enum GoalUnitType: Int, CaseIterable {
//    case count = 0       // 次
//    case volume          // 升、毫升
//    case distance        // 公里、米
//    case timeSeconds     // 秒
//    case timeMinutes     // 分钟
//    case timeHours       // 小时
//    case timeDays        // 天
//
//    // 映射到对应的显示单位
//    var displayUnit: GoalDisplayUnit {
//        switch self {
//        case .count:        return .count
//        case .volume:       return .volume
//        case .distance:     return .distance
//        case .timeSeconds:  return .timeSeconds
//        case .timeMinutes:  return .timeMinutes
//        case .timeHours:    return .timeHours
//        case .timeDays:     return .timeDays
//        }
//    }
//}
//
//enum GoalDisplayUnit: String, CaseIterable {
//    case count = "次"
//    case volume = "升"
//    case distance = "公里"
//    case timeSeconds = "秒"
//    case timeMinutes = "分钟"
//    case timeHours = "小时"
//    case timeDays = "天"
//
//    // 显示名称（与 rawValue 相同，保留扩展性）
//    var displayName: String {
//        self.rawValue
//    }
//
//    // 映射到逻辑类型
//    var unitType: GoalUnitType {
//        switch self {
//        case .count:        return .count
//        case .volume:       return .volume
//        case .distance:     return .distance
//        case .timeSeconds:  return .timeSeconds
//        case .timeMinutes:  return .timeMinutes
//        case .timeHours:    return .timeHours
//        case .timeDays:     return .timeDays
//        }
//    }
//}
//
//
//// MARK: - 存储“目标”的单位和页面显示的关联
//enum GoalFrequencyType: Int, CaseIterable {
//    case everyTime = 0 // 每次
//    case perHour       // 每小时
//    case perDay        // 每天
//    case perWeek       // 每周
//    case perMonth      // 每月
//
//    // 映射到对应的显示单位
//    var displayFrequency: GoalDisplayFrequency {
//        switch self {
//        case .everyTime:        return .everyTime
//        case .perHour:          return .perHour
//        case .perDay:           return .perDay
//        case .perWeek:          return .perWeek
//        case .perMonth:         return .perMonth
//        }
//    }
//}
//
//enum GoalDisplayFrequency: String, CaseIterable {
//    case everyTime = "次"
//    case perHour = "小时"
//    case perDay = "天"
//    case perWeek = "星期"
//    case perMonth = "月"
//
//    // 显示名称（与 rawValue 相同，保留扩展性）
//    var displayName: String {
//        self.rawValue
//    }
//
//    // 映射到逻辑类型
//    var frequencyType: GoalFrequencyType {
//        switch self {
//        case .everyTime:        return .everyTime
//        case .perHour:          return .perHour
//        case .perDay:           return .perDay
//        case .perWeek:          return .perWeek
//        case .perMonth:         return .perMonth
//        }
//    }
//}
////// MARK: - 存储“目标”的周期
////enum GoalFrequency {
////    case everyTime     // 每次
////    case perHour       // 每小时
////    case perDay        // 每天
////    case perWeek       // 每周
////    case perMonth      // 每月
////}
//
//extension GoalDisplayUnit {
//    static func fromRaw(_ value: String) -> GoalDisplayUnit? {
//        allCases.first(where: { $0.rawValue == value })
//    }
//}
//
//func getUnitDisplayName(for goalUnitRawValue: Int) -> String {
//    let type = GoalUnitType(rawValue: goalUnitRawValue) ?? .count
//    return type.displayUnit.displayName
//}
//
//func getFrequencyDisplayName(for goalFrequencyRawValue: Int) -> String {
//    let type = GoalFrequencyType(rawValue: goalFrequencyRawValue) ?? .everyTime
//    return type.displayFrequency.displayName
//}
