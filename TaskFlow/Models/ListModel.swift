//
//  ListModel.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import Foundation

struct ListModel: Identifiable, Codable {
    let id: String
    let title: String
    let category: String
    var tasks: [TaskModel]
    var completed: Int {
        tasks.filter {$0.isCompleted}.count
    }
    var progress: Double {
        Double(completed) / Double(tasks.count)
    }
    
    init(id: String = UUID().uuidString, title: String, category: String, tasks: [TaskModel]) {
        self.id = id
        self.title = title
        self.category = category
        self.tasks = tasks
    }
}
