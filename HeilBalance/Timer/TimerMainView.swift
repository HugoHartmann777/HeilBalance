//
//  TimerMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import AVKit
import Combine
import AudioToolbox


struct TimerMainView: View {
    @StateObject private var vm = TimerViewModel()
    @State private var showSettings: Bool = false
    
    @ObservedObject var lang = LanguageManager.shared
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 18, weight: .semibold)],
            for: .normal
        )
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                VStack(spacing: 24) {
                    // Timer Mode Picker
                    Picker("Mode", selection: $vm.mode) {
                        Text("计时器").tag(TimerViewModel.TimerMode.stopwatch)
                            .font(.system(size: 70))
                        Text("倒计时").tag(TimerViewModel.TimerMode.countdown)
                            .font(.system(size: 70))
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.large)
                    .font(.system(size: 64, weight: .semibold))
                    .onChange(of: vm.mode) { newMode in
                        if newMode == .countdown {
                            vm.updateRemainingTimeFromPicker()
                        }
                    }
                    
                    Spacer()
                    
                    // Timer Display
                    let time = vm.mode == .stopwatch ? vm.elapsedTime : vm.remainingTime
                    let (hours, minutes, seconds) = vm.displayTime(time)
                    
                    Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                        .font(.system(
                            size: min(UIScreen.main.bounds.height * 0.28,
                                      UIScreen.main.bounds.width * 0.65),
                            weight: .bold
                        ))
                        .monospacedDigit()
                        .fontWidth(.compressed)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                    // Controls
                    HStack(spacing: 16) {
                        Button(vm.isRunning ? "暂停" : "开始") {
                            vm.startStopToggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: 30, weight: .semibold))
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        
                        Button("重置") {
                            vm.isRunning = false
                            vm.elapsedTime = 0
                            
                            // 🔥 关键：不改 picker，只重新计算
                            vm.updateRemainingTimeFromPicker()
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .font(.system(size: 30, weight: .semibold))
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        
                        Button(lang.localizedString("设置")) {
                            showSettings.toggle()
                        }
                        .buttonStyle(.bordered)
                        .tint(vm.mode == .stopwatch ? .gray : .black)
                        .font(.system(size: 30, weight: .semibold))
                        .controlSize(.large)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .disabled(vm.mode == .stopwatch)
                        .opacity(vm.mode == .stopwatch ? 0.4 : 1.0)
                    }
                    
                    // Settings button moved to toolbar
                    
                    Spacer()
                    VStack {
                        VStack(spacing: 10) {
                            Image(vm.mode == .stopwatch ? "dazuoxiongmao" : "zhamabu")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                                .allowsHitTesting(false)
                        }
                    }
                    .background(Color.green.opacity(0.3))
                    .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                        vm.tick()
                    }
                }
                .padding()
            }
            .background(Color.green.opacity(0.3))
            .sheet(isPresented: $showSettings) {
                VStack(spacing: 20) {
                    Text(lang.localizedString("设置时间"))
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Picker(lang.localizedString("小时"), selection: $vm.countdownHours) {
                            ForEach(0..<24) { i in
                                Text("\(i) 小时").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 110)
                        
                        Picker("分钟", selection: $vm.countdownMinutes) {
                            ForEach(0..<60) { i in
                                Text("\(i) 分").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 110)
                        
                        Picker("秒", selection: $vm.countdownSeconds) {
                            ForEach(0..<60) { i in
                                Text("\(i) 秒").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 110)
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: vm.countdownHours) { _ in
                        vm.updateRemainingTimeFromPicker()
                    }
                    .onChange(of: vm.countdownMinutes) { _ in
                        vm.updateRemainingTimeFromPicker()
                    }
                    .onChange(of: vm.countdownSeconds) { _ in
                        vm.updateRemainingTimeFromPicker()
                    }
                    
                    Button("完成") {
                        vm.updateRemainingTimeFromPicker()
                        showSettings = false
                        print("完成")
                        print(vm.countdownHours)
                        print(vm.countdownMinutes)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                vm.tick()
            }
        }
    }
}
