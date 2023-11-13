//
//  TaskResponse.swift
//  veroTask
//
//  Created by Ali Burak Baraç on 13.11.2023.
//

import Foundation

struct TaskResponse: Decodable {
    let tasks: [Task]
}
