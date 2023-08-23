//
//  ListView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var listViewModel: ListViewModel
    var list: ListModel
    
    var body: some View {
        List {
            ForEach(list.tasks) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(task.isCompleted ? Color.green : Color.red)
                        .font(.title3)
                    Text(task.title)
                        .font(.title3)
                }
                .onTapGesture {
                    listViewModel.updateTaskIsCompleted(list: list, task: task)
                }
                .animation(Animation.linear, value: task.isCompleted)
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(list.title)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(
            listViewModel: ListViewModel(),
            list: ListModel(
                title: "My first todo list",
                category: "Personal",
                tasks: [
                    TaskModel(title: "Create an account", isCompleted: true),
                    TaskModel(title: "Create my first task", isCompleted: true),
                    TaskModel(title: "Add more todo lists!", isCompleted: false),
                ]
            )
        )
    }
}
