//
//  KnowledgeMainView.swift
//  HeilBalance
//
//  Created by Hugo on 24.02.26.
//

import SwiftUI
import PDFKit

struct KnowledgeMainView: View {
    
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
                    
                    Text("养生知识科普")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 30)
                    
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
        }
    }
}


struct KnowledgeSection: View {
    
    let title: String
    let pdfName: String
    
    var body: some View {
        NavigationLink(destination: PDFDetailView(pdfName: pdfName, title: title)) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text("点击查看详细内容")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
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
