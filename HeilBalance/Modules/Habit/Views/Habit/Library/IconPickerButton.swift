//
//  IconPickerButton.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct IconPickerButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                        .background(Color.gray.opacity(0.1).cornerRadius(12))
                )
        }
    }
}
