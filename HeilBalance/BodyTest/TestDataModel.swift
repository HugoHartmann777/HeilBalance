//
//  TestDataModel.swift
//  HeilBalance
//
//  Created by Hugo on 09.03.26.
//

import Foundation

//struct Questionnaire: Codable {
//    let title: String
//    let questions: [Question]
//    let types: [String] = []  // 默认空数组
//}
//
//struct Questionnaire {
//    let title: String
//    let questions: [Question]
//    let types: [BodyType]
//}


struct Questionnaire: Codable {
    let title: String
    let questions: [Question]
    let types: [BodyType]
}

struct Question: Codable, Identifiable {
    let id: Int
    let text: String
    let type: String
    let options: [Option]?
}

struct Option: Codable {
    let text: String
    let score: Int?
}
