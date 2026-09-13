//
//  NotificationsViewControlller.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class NotificationsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: NotificationsViewModelProtocol
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleMarketLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомлений пока нет"
        label.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    
    init(viewModel: NotificationsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupTableView()
        bindViewModel()
        
        viewModel.loadNotifications()
    }
    
    private func setupUI() {
        
        navigationItem.title = "Уведомления"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
        tableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
        
        tableView.rowHeight = 80
    }
    
    private func bindViewModel() {
        
        viewModel.onNotificationsUpdated = { [weak self] in
            
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    private func updateEmptyState() {
        
        let isEmpty = viewModel.notifications.isEmpty
        
        tableView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
    
    private func showError(_ error: Error) {
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "ОК",
                style: .default
            )
        )
        
        present(
            alert,
            animated: true
        )
    }
}

extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        viewModel.notifications.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }
        
        let notification = viewModel.notifications[indexPath.row]
        
        cell.configure(
            with: notification
        )
        
        return cell
    }
}
