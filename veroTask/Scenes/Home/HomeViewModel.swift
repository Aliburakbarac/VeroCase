import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchTasks()
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

    var tasks: [Task] = []
    var filteredTasks: [Task] = []

    func fetchData() {
        ApiManager.shared.fetchData { [weak self] tasks in
            guard let self = self else { return }

            if let tasks = tasks {
                self.tasks = tasks
                self.filteredTasks = tasks
                self.delegate?.didFetchTasks()

                TaskManager.shared.saveTasks(tasks)
            } else {
                if let localTasks = TaskManager.shared.loadTasks() {
                    self.tasks = localTasks
                    self.filteredTasks = localTasks
                    self.delegate?.didFetchTasks()
                }
            }
        }
    }

    func filterTasks(with searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                return task.title.localizedCaseInsensitiveContains(searchText) ||
                    task.description.localizedCaseInsensitiveContains(searchText) ||
                    task.task.localizedCaseInsensitiveContains(searchText)
            }
        }
        delegate?.didFetchTasks()
    }
}
