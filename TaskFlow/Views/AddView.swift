//
//  AddView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listViewModel: ListViewModel
    @StateObject private var taskViewModel: TaskViewModel = TaskViewModel()
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State private var showTaskSheet: Bool = false
    @State private var listTitle: String = ""
    @State private var listCategory: String = ""
    
    let categoryIcons = [
        "briefcase.fill",
        "graduationcap.fill",
        "building.2.fill",
        "creditcard.fill",
        "heart.fill",
        "person.fill"
    ]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20, alignment: nil),
        GridItem(.flexible(), spacing: 20, alignment: nil),
        GridItem(.flexible(), spacing: 20, alignment: nil),
    ]
    
    var body: some View {
        List {
            VStack(spacing: 20) {
                addTitle
                addCategories
            }
            .listRowSeparator(.hidden)

            Text("Tasks")
                .font(.title3)
                .fontWeight(.bold)
                .listRowSeparator(.hidden)
            
            if taskViewModel.tasks.isEmpty {
                Text("No tasks added... Make sure too! 😎")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            } else {
                addTasks
            }

            addTaskAndListButtons
                .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .animation(Animation.linear, value: taskViewModel.tasks.isEmpty)
        .alert(isPresented: $showAlert, content: getAlert)
        .sheet(isPresented: $showTaskSheet, content: {SheetView(taskViewModel: taskViewModel)})
        .toolbar {
            // FIXME: ToolbarItem placement .navigationBarTrailing causes preview to crash
            ToolbarItem(placement: .principal) {
                ZStack {
                    Text("Add A New List")
                        .font(.headline)
                        .padding(.trailing, 32)
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                            EditButton()
                        }
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddView(listViewModel: ListViewModel())
        }
    }
}

// MARK: COMPONENTS
extension AddView {
    private var addTitle: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.title3)
                .fontWeight(.bold)
            TextField("My Todo List", text: $listTitle)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
    
    private var addCategories: some View {
        VStack (alignment: .leading) {
            Text("Category")
                .font(.title3)
                .fontWeight(.bold)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(categoryIcons, id: \.self) { icon in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .light ? listCategory == categoryName(icon: icon) ? Color.gray.opacity(0.1) : Color.white : listCategory == categoryName(icon: icon) ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3))
                        .frame(height: 100)
                        .shadow(radius: 5)
                        .overlay(
                            VStack(spacing: 10) {
                                Image(systemName: icon)
                                    .font(.title)
                                    .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                                Text(categoryName(icon: icon))
                                    .font(.body)
                            }
                        )
                        .onTapGesture {
                            listCategory = categoryName(icon: icon)
                        }
                }
            }
            .padding([.top, .bottom], 8)
        }
    }
    
    private var addTasks: some View {
        ForEach(taskViewModel.tasks) { task in
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(colorScheme == .light ? Color.blue : Color.indigo)
                Text(task.title)
                Spacer()
            }
        }
        .onDelete(perform: taskViewModel.deleteTask)
        .onMove(perform: taskViewModel.moveTask)
    }
    
    private var addTaskAndListButtons: some View {
        VStack(spacing: 20) {
            Button {
                showTaskSheet.toggle()
            } label: {
                Text("Add Task")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    .border(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo, width: 3)
                    .cornerRadius(5)
            }
            
            Button {
                if checkList() {
                    listViewModel.addList(title: listTitle, category: listCategory, tasks: taskViewModel.tasks)
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Submit List")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                    .cornerRadius(5)
            }
        }
        .padding(.top, 25)
    }
}

// MARK: FUNCTIONS
extension AddView {
    func categoryName(icon: String) -> String {
        switch icon {
        case "briefcase.fill":
            return "Work"
        case "graduationcap.fill":
            return "School"
        case "building.2.fill":
            return "Community"
        case "creditcard.fill":
            return "Financial"
        case "heart.fill":
            return "Health"
        default:
            return "Personal"
        }
    }
    
    func checkList() -> Bool {
        guard listTitle.count >= 2 else {
            alertTitle = "Hold on"
            alertMessage = "Your todo list title must be more than 2 characters long! 😥 "
            showAlert.toggle()
            return false
        }
        
        guard listCategory.count >= 1 else {
            alertTitle = "Hold on"
            alertMessage = "Your must pick a category for your todo list! 😥 "
            showAlert.toggle()
            return false
        }
        
        guard !taskViewModel.tasks.isEmpty else {
            alertTitle = "Hold on"
            alertMessage = "You must add some tasks to your todo list! 😥 "
            showAlert.toggle()
            return false
        }
        
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle), message: Text(alertMessage))
    }
}
