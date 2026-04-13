//
//  TouchdownView.swift
//  German
//
//  Created by Hugo on 28.08.25.
//

import SwiftUI
import Combine

struct TapDetectingView: UIViewRepresentable {
    var doubleTapAction: () -> Void
    var touchDownAction: () -> Void
    
    func makeUIView(context: Context) -> TouchDetectingUIView {
        let view = TouchDetectingUIView()
        view.backgroundColor = .clear
        view.touchDownCallback = {
            context.coordinator.handleTouchDown()
        }
        
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2

        view.addGestureRecognizer(doubleTap)
        
        return view
    }
    
    func updateUIView(_ uiView: TouchDetectingUIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: TapDetectingView
        
        init(_ parent: TapDetectingView) {
            self.parent = parent
        }
        
        @objc func handleDoubleTap() {
            print("UIKit双击触发")
            parent.doubleTapAction()
        }
        
        func handleTouchDown() {
            print("UIKit touchDown 触发")
            parent.touchDownAction()
        }
    }
}

class TouchDetectingUIView: UIView {
    var touchDownCallback: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchDownCallback?()
    }
}
