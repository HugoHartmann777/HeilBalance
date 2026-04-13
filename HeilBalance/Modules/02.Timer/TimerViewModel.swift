//
//  TimerViewModel.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import AVKit
import Combine
import AudioToolbox

final class TimerViewModel: ObservableObject {
    enum TimerMode: String, CaseIterable {
        case stopwatch
        case countdown
    }
    
    @Published var mode: TimerMode = .stopwatch
    @Published var elapsedTime: Double = 0
    @Published var remainingTime: Double = 60
    @Published var countdownHours: Int = 0
    @Published var countdownMinutes: Int = 0
    @Published var countdownSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var hasFinished: Bool = false
    
    var startDate: Date?
    var endDate: Date?
    
    func updateRemainingTimeFromPicker() {
        remainingTime = Double(countdownHours * 3600 + countdownMinutes * 60 + countdownSeconds)
    }
    
    func displayTime(_ t: Double) -> (Int, Int, Int) {
        let safe = max(0, t)
        let hours = Int(safe) / 3600
        let minutes = (Int(safe) % 3600) / 60
        let seconds = Int(safe) % 60
        return (hours, minutes, seconds)
    }
    
    func startStopToggle() {
        if isRunning {
            if mode == .stopwatch {
                elapsedTime = Date().timeIntervalSince(startDate ?? Date())
            } else {
                remainingTime = max(0, endDate?.timeIntervalSinceNow ?? 0)
            }
            isRunning = false
            hasFinished = false
        } else {
            if mode == .stopwatch {
                startDate = Date().addingTimeInterval(-elapsedTime)
            } else {
                endDate = Date().addingTimeInterval(remainingTime)            }
            isRunning = true
            hasFinished = false
        }
    }
    
    func tick() {
        guard isRunning else { return }
        
        if mode == .stopwatch {
            elapsedTime = Date().timeIntervalSince(startDate ?? Date())
        } else {
            remainingTime = max(0, endDate?.timeIntervalSinceNow ?? 0)
            
            if remainingTime <= 0 && isRunning && !hasFinished {
                hasFinished = true
                isRunning = false
                
                AudioServicesPlaySystemSound(1007)
            }
        }
    }
}
