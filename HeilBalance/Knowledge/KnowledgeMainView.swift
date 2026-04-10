//
//  KnowledgeMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import PDFKit
import WebKit

struct WebPage: Codable, Identifiable {
    var id: String { url }
    let title: String
    let url: String
}

struct PageList: Codable {
    let pages: [WebPage]
}

struct KnowledgeMainView: View {
    @ObservedObject var lang = LanguageManager.shared
    @State private var webPages: [WebPage] = []
    @State private var isLoading: Bool = false
    
    var pdfFiles: [String] {
        guard let resourcePath = Bundle.main.resourcePath else { return [] }
        let fileManager = FileManager.default
        let items = (try? fileManager.contentsOfDirectory(atPath: resourcePath)) ?? []
        return items
            .filter { $0.hasSuffix(".pdf") }
            .map { $0.replacingOccurrences(of: ".pdf", with: "") }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView("加载中...")
                            Spacer()
                        }
                    }
                    
                    Text(lang.localizedString("health_knowledge"))
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
                    ForEach(webPages) { page in
                        KnowledgeSection(
                            title: page.title,
                            pdfName: page.url,
                            isWeb: true
                        )
                    }
                    
                    ForEach(pdfFiles, id: \.self) { pdf in
                        KnowledgeSection(
                            title: pdf,
                            pdfName: pdf
                        )
                    }
                    
                    Spacer()
                    
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                isLoading = true
                loadPages()
            }
            .onChange(of: lang.currentLanguage) { _ in
                isLoading = true
                loadPages()
            }
        }
    }
    func loadPages() {
        
        // 1️⃣ 获取 App 当前语言（优先用户设置，否则使用 App 支持语言）
        let langCode = lang.currentLanguage
        
        // 2️⃣ 选择 JSON 文件
        let fileName: String
        switch langCode {
        case "de":
            fileName = "pages_de.json"
        case "zh-Hans":
            fileName = "pages_zh.json"
        default:
            fileName = "pages_en.json"
        }
        
        // 3️⃣ 拼接 URL
        let baseURL = "https://hugohartmann777.github.io/hugohartmann.github.io/"
        let urlString = baseURL + fileName
        
        guard let url = URL(string: urlString) else { return }
        
        // 4️⃣ 请求 JSON
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            // ❗ 如果失败 → fallback 到英文
            if data == nil && fileName != "pages_en.json" {
                loadFallbackPages(baseURL: baseURL)
                return
            }
            
            guard let data = data else { return }
            
            if let result = try? JSONDecoder().decode(PageList.self, from: data) {
                
                let fixedPages = result.pages.map { page -> WebPage in
                    if page.url.hasPrefix("http") {
                        return page
                    } else {
                        return WebPage(title: page.title, url: baseURL + page.url)
                    }
                }
                
                DispatchQueue.main.async {
                    self.webPages = fixedPages
                    self.isLoading = false
                }
            }
            
        }.resume()
    }
    
    func loadFallbackPages(baseURL: String) {
        
        let fallbackURL = baseURL + "pages_en.json"
        
        guard let url = URL(string: fallbackURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            guard let data = data else { return }
            
            if let result = try? JSONDecoder().decode(PageList.self, from: data) {
                
                let fixedPages = result.pages.map { page -> WebPage in
                    if page.url.hasPrefix("http") {
                        return page
                    } else {
                        return WebPage(title: page.title, url: baseURL + page.url)
                    }
                }
                
                DispatchQueue.main.async {
                    self.webPages = fixedPages
                    self.isLoading = false
                }
            }
            
        }.resume()
    }
}


struct KnowledgeSection: View {
    
    let title: String
    let pdfName: String
    var isWeb: Bool = false
    let titleColor: Color = .primary
    
    var body: some View {
        NavigationLink(destination: destinationView()) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(titleColor)
                
                Text("点击查看详细内容")
                    .font(.body)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        if isWeb, let url = URL(string: pdfName) {
            WebDetailView(url: url, title: title)
        } else {
            PDFDetailView(pdfName: pdfName, title: title)
        }
    }
}

struct PDFDetailView: View {
    
    let pdfName: String
    let title: String
    
    var body: some View {
        PDFKitView(pdfName: pdfName)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebDetailView: View {
    
    let url: URL
    let title: String
    
    var body: some View {
        WebView(url: url)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let pdfName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(false)
        pdfView.displaysPageBreaks = false
        pdfView.pageBreakMargins = .zero
        
        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
    }
}
