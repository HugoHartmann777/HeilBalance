//
//  TestLoader.swift
//  HeilBalance
//
//  Created by Hugo on 09.03.26.
//

import Foundation

func loadQuestionnaire(from fileName: String) -> Questionnaire? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("Debug: Could not find file \(fileName).json in bundle.")
        return nil
    }
    guard let data = try? Data(contentsOf: url) else {
        print("Debug: Failed to read data from file at URL: \(url).")
        return nil
    }
    do {
        let questionnaire = try JSONDecoder().decode(Questionnaire.self, from: data)
        return questionnaire
    } catch {
        print("Debug: Failed to decode Questionnaire from data with error: \(error).")
        return nil
    }
}
