import UIKit
import AVFoundation

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, HomeViewModelDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private lazy var colorView: UITableView = {
        let view = UITableView()
        return view
    }()
   
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.tintColor = .white
        return searchBar
    }()
    
    private lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.dataSource = self
        colorView.delegate = self
        searchBar.delegate = self
        ApiManager.shared.login()
        navigationItem.titleView = searchBar
        colorView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        applyConstraints()
        viewModel.fetchData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        colorView.refreshControl = refreshControl

        let qrCodeButton = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(scanQRCode))
        qrCodeButton.tintColor = .purple
        navigationItem.rightBarButtonItem = qrCodeButton
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = colorView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = viewModel.filteredTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTasks.count
    }

    private func applyConstraints() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTasks(with: searchText)
    }

    @objc private func refreshData() {
        viewModel.fetchData()
        colorView.refreshControl?.endRefreshing()
    }

    @objc private func scanQRCode() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available.")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func didFetchTasks() {
        DispatchQueue.main.async {
            self.colorView.reloadData()
        }
    }
}
