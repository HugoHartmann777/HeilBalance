//
//  BaDuanJinMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import AVKit

struct BaDuanJinView: View {
    
    private let sections: [BaDuanJinSection] = [
        BaDuanJinSection(title: "第一式", subtitle: "双手托天理三焦", videoName: "bdj1"),
        BaDuanJinSection(title: "第二式", subtitle: "左右开弓似射雕", videoName: "bdj2"),
        BaDuanJinSection(title: "第三式", subtitle: "调理脾胃须单举", videoName: "bdj3"),
        BaDuanJinSection(title: "第四式", subtitle: "五劳七伤往后瞧", videoName: "bdj4"),
        BaDuanJinSection(title: "第五式", subtitle: "摇头摆尾去心火", videoName: "bdj5"),
        BaDuanJinSection(title: "第六式", subtitle: "两手攀足固肾腰", videoName: "bdj6"),
        BaDuanJinSection(title: "第七式", subtitle: "攒拳怒目增气力", videoName: "bdj7"),
        BaDuanJinSection(title: "第八式", subtitle: "背后七颠百病消", videoName: "bdj8")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("八段锦 · 八式教学")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(sections) { section in
                        NavigationLink {
                            BaDuanJinDetailView(section: section)
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
        .navigationTitle("八段锦")
    }
}

struct BaDuanJinSection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let videoName: String
}

struct BaDuanJinDetailView: View {
    
    let section: BaDuanJinSection
    @State private var player: AVPlayer?
    
    var body: some View {
        VStack(spacing: 16) {
            
            if let player {
//                VideoPlayer(player: player)
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


struct FullControlVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.entersFullScreenWhenPlaybackBegins = false
        controller.exitsFullScreenWhenPlaybackEnds = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // nothing
    }
}
