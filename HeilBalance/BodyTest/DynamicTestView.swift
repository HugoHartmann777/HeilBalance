import SwiftUI

struct DynamicTestView: View {
    let questionnaire: Questionnaire
    let types: [BodyType] // 假设传入体质类型数组
    @State private var answers: [Int: Int] = [:] // questionId: selectedOptionScore
    @State private var resultName: String? = nil // 测试结果名称
    @State private var resultDescription: String? = nil // 测试结果描述
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(questionnaire.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                
                ForEach(questionnaire.questions) { question in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(question.text)
                            .font(.headline)
                        
                        if let options = question.options {
                            ForEach(options.indices, id: \.self) { index in
                                Button(action: {
                                    if let score = options[index].score {
                                        answers[question.id] = score
                                    }
                                }) {
                                    HStack {
                                        Text(options[index].text)
                                        Spacer()
                                        if answers[question.id] == options[index].score {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
                
                Button("提交") {
                    calculateResult()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                // 显示测试结果
                if let name = resultName, let description = resultDescription {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("您的体质类型：\(name)")
                            .font(.title2)
                            .bold()
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.top)
                }


                if let name = resultName {
                    let products = getProducts(for: name)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("推荐商品")
                            .font(.headline)

                        ForEach(products) { product in
                            HStack {
                                Image(product.imageName)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)

                                VStack(alignment: .leading) {
                                    Text(product.title)
                                        .font(.subheadline)
                                    Link("在 Amazon 查看", destination: URL(string: product.url)!)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
    }
    
    func calculateResult() {
        // 根据 answers 和每个问题的 type 累加分数
        var scoreDict: [String: Int] = [:] // type id -> 总分
        
        for question in questionnaire.questions {
            if let score = answers[question.id] {
                let typeId = question.type
                scoreDict[typeId, default: 0] += score
            }
        }
        
        // 找出分数最高的体质类型
        if let maxTypeId = scoreDict.max(by: { $0.value < $1.value })?.key {
            if let matchedType = types.first(where: { $0.id == maxTypeId }) {
                resultName = matchedType.name
                resultDescription = matchedType.description
            } else {
                resultName = "未知体质类型"
                resultDescription = ""
            }
        }
    }
    }

    // MARK: - 商品推荐
    func getProducts(for type: String) -> [Product] {
        switch type {
        case "气虚":
            return [
                Product(title: "补气养生茶", url: "https://www.amazon.com", imageName: "tea"),
                Product(title: "人参补品", url: "https://www.amazon.com", imageName: "ginseng")
            ]
        case "湿热":
            return [
                Product(title: "祛湿茶", url: "https://www.amazon.com", imageName: "tea2"),
                Product(title: "清热饮品", url: "https://www.amazon.com", imageName: "drink")
            ]
        default:
            return [
                Product(title: "健康养生书籍", url: "https://www.amazon.com", imageName: "book")
            ]
        }
    }

struct BodyType: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
}

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    let imageName: String
}
