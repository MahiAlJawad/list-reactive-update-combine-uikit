//
//  ViewController.swift
//  list reactive update combine-uikit
//
//  Created by Mahi Al Jawad on 21/4/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    @IBOutlet private weak var tableView: UITableView!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationItems()
        setupTableView()
        setupDataObservations()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "Reactive List Update"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(.init(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
    }
    
    private func setupDataObservations() {
        viewModel.uiEventPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] uiEvent in
                guard let self else { return }
                switch uiEvent {
                case .reload: tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configure(viewModel.items[indexPath.row])
        return cell
    }
}

