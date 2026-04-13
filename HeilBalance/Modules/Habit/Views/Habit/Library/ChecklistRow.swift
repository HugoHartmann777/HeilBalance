//
//  ChecklistView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct ChecklistView: View {
    @Binding var checklist: String
    
    var body: some View {
        Form {
            Section(header: Text("检查清单内容")) {
                TextField("例如：喝水，冥想，运动", text: $checklist)
            }
        }
        .navigationTitle("检查清单")
    }
}

struct ChecklistRow: View {
    @Binding var checklist: String

    var body: some View {
        NavigationLink(destination: ChecklistView(checklist: $checklist)) {
            HStack {
                Image(systemName: "list.bullet").foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text("检查清单")
                    Text(checklist.isEmpty ? "无" : checklist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
