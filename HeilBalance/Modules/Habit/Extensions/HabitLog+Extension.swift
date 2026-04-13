import Foundation
import Combine
import SwiftUI

extension HabitLog {
    /// 打卡类型枚举，对应 Core Data 中的 Int16 类型 type 字段
    enum LogType: Int16 {
        case none = 0        // 未打卡
        case completed = 1   // 已完成
        case skipped = 2     // 已跳过
    }

    /// 将 Core Data 的 Int16 type 转成枚举，默认是 .none
    var typeEnum: LogType {
        return LogType(rawValue: self.type) ?? .none
    }
    
    /// 是否已完成
    var isCompleted: Bool {
        return typeEnum == .completed
    }

    /// 是否已跳过
    var isSkipped: Bool {
        return typeEnum == .skipped
    }
}
