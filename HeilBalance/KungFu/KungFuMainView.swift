//
//  KungFuMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//


import SwiftUI
import AVKit

struct KungFuMainView: View {
    @ObservedObject var lang = LanguageManager.shared
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text(lang.localizedString("传统养生功法"))
                        .font(.system(size: 34, weight: .semibold, design: .serif))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    KungFuCard(title: lang.localizedString("八段锦"), systemImage: "figure.cooldown") {
                        BaDuanJinView()
                    }
                    
                    KungFuCard(title: lang.localizedString("引导术"), systemImage: "figure.mind.and.body") {
                        YinDaoView()
                    }
                    
                    KungFuCard(title: lang.localizedString("太极拳"), systemImage: "figure.walk") {
                        TaiJiView()
                    }
                    
                    KungFuCard(title: lang.localizedString("八卦掌"), systemImage: "figure.strengthtraining.traditional") {
                        BaGuaView()
                    }
                    
                    Spacer()
                }
                .padding()
                
                
                Spacer()
            }
            .background(Color(red: 0.97, green: 0.96, blue: 0.92))
        }
    }
}

struct KungFuCard<Destination: View>: View {
    
    let title: String
    let systemImage: String
    let destination: Destination
    
    init(title: String,
         systemImage: String,
         @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
                    .frame(width: 40)
                
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.red)
            }
            .padding()
            .background(Color(red: 0.99, green: 0.98, blue: 0.95))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct YinDaoView: View {
    var body: some View {
        Text("引导术内容页")
            .navigationTitle("引导术")
    }
}

struct TaiJiView: View {
    var body: some View {
        Text("太极拳内容页")
            .navigationTitle("太极拳")
    }
}

struct BaGuaView: View {
    var body: some View {
        Text("八卦掌内容页")
            .navigationTitle("八卦掌")
    }
}

struct TestVideoView: View {
    var body: some View {
        if let url = Bundle.main.url(forResource: "bdj1", withExtension: "mp4") {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 250)
                .cornerRadius(16)
                .padding()
        } else {
            Text("视频加载失败")
                .foregroundColor(.red)
                .padding()
        }
    }
}
