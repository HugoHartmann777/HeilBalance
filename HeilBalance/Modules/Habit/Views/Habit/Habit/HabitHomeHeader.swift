import SwiftUI

struct HabitHomeHeader: View {
    @Binding var showingNewHabitSheet: Bool
    @Binding var showingTrashHabitSheet: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // 显示日期和星期
                Text(HabitStorage.getFormattedDate())
                    .font(.title)
                    .foregroundColor(.black)
            }
            Spacer()
            Button(action: {
                showingTrashHabitSheet = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
            Button(action: {
                showingNewHabitSheet = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
