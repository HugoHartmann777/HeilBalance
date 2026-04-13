import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var lang = LanguageManager.shared
    @State private var selectedTab = 2
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab 内容
            ZStack {
                switch selectedTab {
                case 0: KungFuMainView()    // 功夫
                case 1: XianXianMainView()
                case 2: HabitMainView(context: HabitPersistenceController.shared.container.viewContext)
                        .environment(\.managedObjectContext, HabitPersistenceController.shared.container.viewContext)
                case 3: TimerMainView()     // 计时器
                case 4: SettingMainView()
                default: HomeView()
                }
            }
            Divider()
            // TabBar
            HStack {
                tabItem(index: 0, icon: "figure.mind.and.body", titleKey: "功夫")
                tabItem(index: 1, icon: "heart.text.square", titleKey: "计时")
                tabItem(index: 2, icon: "leaf", titleKey: "时光留痕")
                tabItem(index: 3, icon: "book.closed", titleKey: "先贤")
                tabItem(index: 4, icon: "gearshape", titleKey: "设置")
            }
            .padding(.vertical, 20)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func tabItem(index: Int, icon: String, titleKey: String) -> some View {
        Button(action: { selectedTab = index }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(lang.localizedString(titleKey))
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
