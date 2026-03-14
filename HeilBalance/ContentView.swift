import SwiftUI

struct ContentView: View {
    @ObservedObject var lang = LanguageManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab 内容
            ZStack {
                switch selectedTab {
                case 0: KungFuMainView()    // 功夫，八段锦等
                case 1: BodyTestMainView()  // 体质测试
                case 2: HealthyLivingMainView()
                case 3: KnowledgeMainView() // 中医知识
                case 4: SettingMainView()
                default: HomeView()
                }
            }
            Divider()
            // TabBar
            HStack {
                tabItem(index: 0, icon: "figure.mind.and.body", title: lang.localizedString("养生功夫"))
                tabItem(index: 1, icon: "heart.text.square", title: lang.localizedString("体质测试"))
                tabItem(index: 2, icon: "leaf", title: lang.localizedString("生活方式"))
                tabItem(index: 3, icon: "book.closed", title: lang.localizedString("养生知识"))
                tabItem(index: 4, icon: "gearshape", title: lang.localizedString("设置"))
            }
            .padding(.vertical, 20)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func tabItem(index: Int, icon: String, title: String) -> some View {
        Button(action: { selectedTab = index }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == index ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}



struct HomeView: View {
    @ObservedObject var lang = LanguageManager.shared
    var body: some View {
        VStack {
            Spacer() // 可选，如果想居中
            Text(lang.localizedString("home"))
                .font(.largeTitle)
            Spacer() // 可选
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct CheckView: View {
    @ObservedObject var lang = LanguageManager.shared
    var body: some View {
        VStack {
            Spacer()
            Text(lang.localizedString("check"))
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

//struct LifeView: View {
//    @ObservedObject var lang = LanguageManager.shared
//    var body: some View {
//        VStack {
//            Spacer()
//            Text(lang.localizedString("life"))
//                .font(.largeTitle)
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemBackground))
//    }
//}

struct KnowledgeView: View {
    @ObservedObject var lang = LanguageManager.shared
    var body: some View {
        VStack {
            Spacer()
            Text(lang.localizedString("knowledge"))
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
