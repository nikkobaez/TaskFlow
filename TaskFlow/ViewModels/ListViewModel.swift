//
//  ListViewModel.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var lists: [ListModel] = [
        ListModel(
            title: "My first todo list",
            category: "Personal",
            tasks: [
                TaskModel(title: "Create an account", isCompleted: true),
                TaskModel(title: "Create my first task", isCompleted: true),
                TaskModel(title: "Add more todo lists!", isCompleted: false)
            ]
        )
    ] {
        didSet {
             saveLists()
             updateTasks()
        }
    }
    
    let listsKey: String = "lists_key"
    var totalNumberOfTasks: Int = 1
    var numberOfWorkTasks: Int = 0
    var numberOfSchoolTasks: Int = 0
    var numberOfCommunityTasks: Int = 0
    var numberOfFinancialTasks: Int = 0
    var numberOfHealthTasks: Int = 0
    var numberOfPersonalTasks: Int = 1
    
    init() {
        getLists()
    }
    
    func getLists() {
        guard
            let listData = UserDefaults.standard.data(forKey: listsKey),
            let decodedSavedLists = try? JSONDecoder().decode([ListModel].self, from: listData)
        else {
            return
        }
        self.lists = decodedSavedLists
    }
    
    func saveLists() {
        guard
            let encodedSavedLists = try? JSONEncoder().encode(lists)
        else {
            return
        }
        UserDefaults.standard.set(encodedSavedLists, forKey: listsKey)
    }
    
    func addList(title: String, category: String, tasks: [TaskModel]) {
        let newList = ListModel(title: title, category: category, tasks: tasks)
        lists.append(newList)
    }
    
    func deleteList(indexSet: IndexSet) {
        lists.remove(atOffsets: indexSet)
    }
    
    func moveList(from: IndexSet, to: Int) {
        lists.move(fromOffsets: from, toOffset: to)
    }
    
    func updateTaskIsCompleted(list: ListModel, task: TaskModel) {
        guard
            let listIndex = lists.firstIndex(where: {$0.id == list.id}),
            let taskIndex = lists[listIndex].tasks.firstIndex(where: {$0.id == task.id})
        else {
            return
        }
        lists[listIndex].tasks[taskIndex] = task.updateIsCompleted()
    }
    
    func updateTasks() {
        totalNumberOfTasks = 0
        numberOfWorkTasks = 0
        numberOfSchoolTasks = 0
        numberOfCommunityTasks = 0
        numberOfFinancialTasks = 0
        numberOfHealthTasks = 0
        numberOfPersonalTasks = 0
        
        for list in lists {
            switch list.category {
            case "Work":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfWorkTasks+=1
                    }
                }
            case "School":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfSchoolTasks+=1
                    }
                }
            case "Community":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfCommunityTasks+=1
                    }
                }
            case "Financial":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfFinancialTasks+=1
                    }
                }
            case "Health":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfHealthTasks+=1
                    }
                }
            case "Personal":
                for task in list.tasks {
                    if !task.isCompleted {
                        numberOfPersonalTasks+=1
                    }
                }
            default:
                break
            }
            
            for task in list.tasks {
                if !task.isCompleted {
                    totalNumberOfTasks+=1
                }
            }
        }
    }
}
