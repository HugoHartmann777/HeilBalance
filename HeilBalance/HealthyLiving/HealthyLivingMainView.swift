import SwiftUI
import WebKit

// WebView 组件
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct DaKaMainView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Text("健康生活")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    KungFuCard(title: "四季养生", systemImage: "figure.mind.and.body") {
                        HealthyDemo(title: "四季养生", content: "四季养生的建议：春天养肝，夏天养心，秋天养肺，冬天养肾。")
                    }
                    
                    KungFuCard(title: "日常饮食", systemImage: "figure.cooldown") {
                        HealthyDemo(title: "日常饮食", content: "推荐每天摄入五蔬果，少油少盐，保持均衡饮食。")
                    }
                    
                    KungFuCard(title: "生活方式", systemImage: "figure.walk") {
                        HealthyDemo(title: "生活方式", content: "坚持运动，戒烟限酒，保持良好作息。")
                    }
                    
                    KungFuCard(title: "健康睡眠", systemImage: "figure.strengthtraining.traditional") {
                        HealthyDemo(title: "健康睡眠", content: "保证每天7-8小时睡眠，睡前避免蓝光刺激。")
                    }
                    
                    KungFuCard(title: "情绪管理", systemImage: "figure.strengthtraining.traditional") {
                        HealthyDemo(title: "情绪管理", content: "学会放松和调节情绪，减少压力和焦虑。")
                    }
                    
                    KungFuCard(title: "打坐冥想", systemImage: "figure.strengthtraining.traditional") {
                        HealthyDemo(title: "打坐冥想", content: "每天冥想10-20分钟，有助于身心平衡。")
                    }
                    
                    KungFuCard(title: "呼吸方式", systemImage: "figure.strengthtraining.traditional") {
                        HealthyDemo(title: "呼吸方式", content: "练习腹式呼吸，帮助放松和提高肺活量。")
                    }
                    
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct HealthyDemo: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                Text(content)
                    .font(.body)
                    .lineSpacing(6)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(title)
    }
}
