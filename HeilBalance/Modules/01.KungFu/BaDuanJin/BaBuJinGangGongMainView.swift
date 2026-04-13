//
//  BaBuJinGangGongMainView.swift
//  HeilBalance
//
//  Created by Hugo on 09.04.26.
//

import SwiftUI
import AVKit

struct BaBuJinGangGongMainView: View {
    
    @ObservedObject var lang = LanguageManager.shared
    // 将 sections 改为计算属性，支持 lang 本地化
    private var sections: [BaBuJinGangGongSection] {
        [
            BaBuJinGangGongSection(title: lang.localizedString("第一式"), subtitle: lang.localizedString("八部金刚功第一式"), videoName: "bdj1"),
            BaBuJinGangGongSection(title: lang.localizedString("第二式"), subtitle: lang.localizedString("八部金刚功第二式"), videoName: "bdj2"),
            BaBuJinGangGongSection(title: lang.localizedString("第三式"), subtitle: lang.localizedString("八部金刚功第三式"), videoName: "bdj3"),
            BaBuJinGangGongSection(title: lang.localizedString("第四式"), subtitle: lang.localizedString("八部金刚功第四式"), videoName: "bdj4"),
            BaBuJinGangGongSection(title: lang.localizedString("第五式"), subtitle: lang.localizedString("八部金刚功第五式"), videoName: "bdj5"),
            BaBuJinGangGongSection(title: lang.localizedString("第六式"), subtitle: lang.localizedString("八部金刚功第六式"), videoName: "bdj6"),
            BaBuJinGangGongSection(title: lang.localizedString("第七式"), subtitle: lang.localizedString("八部金刚功第七式"), videoName: "bdj7"),
            BaBuJinGangGongSection(title: lang.localizedString("第八式"), subtitle: lang.localizedString("八部金刚功第八式"), videoName: "bdj8")
        ]
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                //Text(lang.localizedString("BaduanjinTitle"))
                Text(lang.localizedString("八部金刚功 · 八式教学"))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(lang.localizedString("BaDuanJinDescription"))
                        .font(.body)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.orange, Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineSpacing(6)
                    
                    Text(lang.localizedString("功法免责声明"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .bold()
                }
                .padding(.top, 20)
                
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sections) { section in
                        NavigationLink {
                            BaBuJinGangGongDetailView(section: section)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(section.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(
                                LinearGradient(
                                    colors: [Color.brown.opacity(0.15), Color.orange.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("八部金刚功")
    }
}

struct BaBuJinGangGongSection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let videoName: String
}

struct BaBuJinGangGongDetailView: View {
    
    let section: BaBuJinGangGongSection
    @State private var player: AVPlayer?
    
    @ObservedObject var lang = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            
            if let player {
                FullControlVideoPlayer(player: player)
                    .frame(height: 250)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .font(.title2)
                    .bold()
                
                Text(section.subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                
                Spacer()
                    .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                
                Text(lang.localizedString("动作说明"))
                    .bold()                     // 加粗
                    .foregroundColor(.red)      // 改变颜色
                
                if section.videoName == "bdj1" {
                    Text(lang.localizedString("八部金刚功第一式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第一式：身体感知"))
                    
                } else if section.videoName == "bdj2" {
                    Text(lang.localizedString("八部金刚功第二式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第二式：身体感知"))
                    
                } else if section.videoName == "bdj3" {
                    Text(lang.localizedString("八部金刚功第三式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第三式：身体感知"))
                    
                } else if section.videoName == "bdj4" {
                    Text(lang.localizedString("八部金刚功第四式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第四式：身体感知"))
                    
                } else if section.videoName == "bdj5" {
                    Text(lang.localizedString("八部金刚功第五式：动作说明"))
                    
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第五式：身体感知"))
                    
                } else if section.videoName == "bdj6" {
                    Text(lang.localizedString("八部金刚功第六式：动作说明"))
                    
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第六式：身体感知"))
                    
                } else if section.videoName == "bdj7" {
                    Text(lang.localizedString("八部金刚功第七式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第七式：身体感知"))
                    
                } else if section.videoName == "bdj8" {
                    Text(lang.localizedString("八部金刚功第八式：动作说明"))
                    Spacer()
                        .frame(minHeight: 5, maxHeight: 10) // 控制高度范围
                    Text(lang.localizedString("身体感知"))
                        .bold()                     // 加粗
                        .foregroundColor(.red)      // 改变颜色
                    Text(lang.localizedString("八部金刚功第八式：身体感知"))
                }
                
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            if let url = Bundle.main.url(forResource: section.videoName, withExtension: "mp4") {
                player = AVPlayer(url: url)
                player?.play()
            }
        }
        .navigationTitle(section.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
