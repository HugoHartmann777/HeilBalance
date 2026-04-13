
import SwiftUI

struct KeyboardWarmUpView: View {
    @State private var dummyText = ""
    @FocusState private var isDummyFocused: Bool

    var body: some View {
        TextField("", text: $dummyText)
            .focused($isDummyFocused)
            .opacity(0) // 不可见
            .disabled(true) // 不响应输入
            .onAppear {
                // 轻轻激活一下焦点，让系统提前加载键盘
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isDummyFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isDummyFocused = false
                    }
                }
            }
    }
}
