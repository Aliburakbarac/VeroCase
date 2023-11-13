import Foundation

class TaskManager {
    static let shared = TaskManager()
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "tasks"
    
    private init() {}

    func saveTasks(_ tasks: [Task]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(tasks)
            userDefaults.set(encodedData, forKey: tasksKey)
        } catch {
            print("Error encoding tasks: \(error.localizedDescription)")
        }
    }

    func loadTasks() -> [Task]? {
        if let savedData = userDefaults.data(forKey: tasksKey) {
            do {
                let decoder = JSONDecoder()
                let tasks = try decoder.decode([Task].self, from: savedData)
                return tasks
            } catch {
                print("Error decoding tasks: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
