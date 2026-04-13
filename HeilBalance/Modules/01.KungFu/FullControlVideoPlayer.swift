//
//  FullControlVideoPlayer.swift
//  HeilBalance
//
//  Created by Hugo on 09.04.26.
//

import SwiftUI
import AVKit
import UIKit // 添加这一行


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
