
import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Binding var isPresented: Bool
    
    let icons = ["questionmark.circle", "star.fill", "flame.fill", "bolt.fill", "heart.fill", "book.fill", "leaf.fill", "moon.fill", "sun.max.fill", "figure.walk", "drop.fill", "bicycle", "graduationcap.fill"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(icons, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                            isPresented = false
                        }) {
                            Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedIcon == icon ? Color.blue : Color.clear, lineWidth: 2)
                                        .background(Color.gray.opacity(0.1).cornerRadius(10))
                                )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("选择图标")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
