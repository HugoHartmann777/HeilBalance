//
//  EditHabitView.swift
//  MindZen
//
//  Created by J on 5/17/25.
//

import SwiftUI

struct EditHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var habit: Habit
    
    var body: some View {
        NavigationView {
            HabitFormView(habit: habit, isEditing: true, context: viewContext)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
