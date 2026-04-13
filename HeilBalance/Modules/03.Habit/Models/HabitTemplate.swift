////
////  HabitTemplate.swift
////  Habit
////
////  Created by J on 5/21/25.
////
//
//import Foundation
//
//struct PlanTemplate: Codable {
//    var date: String
//    var type: String
//    var rounds: Int
//    var rest_between_rounds: String
//    var completed: Bool
//    var notes: String
//    var exercises: [ExerciseTemplate]
//}
//
//struct ExerciseTemplate: Codable {
//    var name: String
//    var reps: String?
//    var duration: String?
//    var rest: String
//    var done: Bool
//}
//

import SwiftUI
import Combine



struct HabitTemplate: Codable {
    var name: String
    var icon: String
    var goalNumber: Int
    var goalUnit: String
    var goalFrequency: String
    var category: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case icon = "Icon"
        case goalNumber = "GoalNumber"
        case goalUnit = "GoalUnit"
        case goalFrequency = "GoalFrequency"
        case category = "Category"
    }
}


//    var checklist: Bool
//    var repeatDays: String
//    var reminderTime: String
//    var icon: String
