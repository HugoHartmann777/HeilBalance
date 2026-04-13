//
//  BodyTestMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI

struct TestMenuCard<Destination: View>: View {
    
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
                    .foregroundColor(.brown)
                    .frame(width: 40)
                
                Text(title)
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
