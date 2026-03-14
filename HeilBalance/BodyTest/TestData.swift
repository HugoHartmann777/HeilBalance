//
//  TestData.swift
//  HeilBalance
//
//  Created by Hugo on 09.03.26.
//

import SwiftUI

struct TestData: Codable {
    struct ConstitutionType: Codable {   // ✅ 原来叫 Type，改成 ConstitutionType
        let id: String
        let name: String
        let description: String
    }
    struct Question: Codable, Identifiable {
        let id = UUID()
        let text: String
        let type: String
    }
    
    let title: String
    let types: [ConstitutionType]   // 注意这里也要改
    let questions: [Question]
}
