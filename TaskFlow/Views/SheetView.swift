//
//  SheetView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskViewModel: TaskViewModel
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State private var taskTitle: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            sheetHeader
            sheetTitle
            addTaskButton
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert, content: getAlert)
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(taskViewModel: TaskViewModel())
    }
}

// MARK: COMPONENTS
extension SheetView {
    private var sheetHeader: some View {
        ZStack {
            Text("Add A New Task")
                .font(.headline)
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                        .font(.title2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom)
    }
    
    private var sheetTitle: some View {
        Group {
            Text("Title")
                .font(.title3)
                .fontWeight(.bold)
            TextField("My Task", text: $taskTitle)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.vertical, 8)
        }
    }
    
    private var addTaskButton: some View {
        Button {
            if checkTask() {
                addTask(title: taskTitle)
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("Submit Task")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                .cornerRadius(5.0)
        }
    }
}

// MARK: FUNCTIONS
extension SheetView {
    func addTask(title: String) {
        taskViewModel.addTask(title: title)
    }
    
    func checkTask() -> Bool {
        guard taskTitle.count >= 2 else {
            alertTitle = "Hold on"
            alertMessage = "Your task title must be more than 2 characters long! 😥 "
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle), message: Text(alertMessage))
    }
}
