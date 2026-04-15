import SwiftUI
import CoreData

struct HabitMainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HabitMainViewModel
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [],
        predicate: nil
    ) var categorys: FetchedResults<Category>
    
    
    @State private var showingNewHabitSheet = false
    @State private var showingTrashHabitSheet = false
    @State private var selectedFilter: HabitFilter = .all
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitMainViewModel(context: context))
    }
    
    var body: some View {
        VStack(spacing: 0) {

            HabitHomeHeader(showingNewHabitSheet: $showingNewHabitSheet,
                            showingTrashHabitSheet: $showingTrashHabitSheet)

            HabitTabBar(selectedFilter: $selectedFilter)
   
            HabitListView()
            
            Spacer()
            Divider()
            
            //HabitHistoryView()
        }
        .sheet(isPresented: $showingNewHabitSheet) {
            CreateHabitView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct HabitTabBar: View {
    @Binding var selectedFilter: HabitFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(HabitFilter.allCases, id: \ .self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(selectedFilter == filter ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedFilter == filter ? .white : .black)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
        }
    }
}
