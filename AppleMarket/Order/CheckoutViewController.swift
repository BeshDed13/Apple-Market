//
//  CheckoutViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 13.08.2026.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
    // MARK: - Properties
    
    var onOrderCreated: (() -> Void)?
    
    private let viewModel: CheckoutViewModelProtocol
    
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
    
    private let contactTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Контактные данные"
        label.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Магазин для получения"
        label.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "Оформить заказ",
            for: .normal
        )
        button.setTitleColor(
            .white,
            for: .normal
        )
        button.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = DesignSystem.Radius.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: CheckoutViewModelProtocol) {
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
        setupActions()
        bindViewModel()
        
        nameLabel.text = viewModel.userName
        emailLabel.text = viewModel.userEmail
        
        updateCheckoutButton()
        
        viewModel.loadStores()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        navigationItem.title = "Оформление заказа"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        view.addSubview(contactTitleLabel)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameLabel)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailLabel)
        
        view.addSubview(storeTitleLabel)
        view.addSubview(tableView)
        view.addSubview(checkoutButton)
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
            
            contactTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contactTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contactTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTitleLabel.topAnchor.constraint(equalTo: contactTitleLabel.bottomAnchor, constant: 16),
            nameTitleLabel.leadingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contactTitleLabel.trailingAnchor),
            
            emailTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            emailTitleLabel.leadingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: contactTitleLabel.trailingAnchor),
            
            storeTitleLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 28),
            storeTitleLabel.leadingAnchor.constraint(equalTo: contactTitleLabel.leadingAnchor),
            storeTitleLabel.trailingAnchor.constraint(equalTo: contactTitleLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: storeTitleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -16),
                    
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Setup TableView
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            StoreCell.self,
            forCellReuseIdentifier: StoreCell.identifier
        )
        
        tableView.rowHeight = 70
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        
        checkoutButton.addAction(
            UIAction { [weak self] _ in
                self?.checkoutButtonTapped()
            },
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        
        viewModel.onStoresUpdated = { [weak self] in
            
            self?.tableView.reloadData()
            self?.updateCheckoutButton()
        }
        
        viewModel.onStoreSelected = { [weak self] in
            
            self?.tableView.reloadData()
            self?.updateCheckoutButton()
        }
        
        viewModel.onOrderCreated = { [weak self] in
            self?.onOrderCreated?()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    private func updateCheckoutButton() {
        
        let hasSelectedStore = viewModel.selectedStore != nil
        
        checkoutButton.isEnabled = hasSelectedStore
        checkoutButton.alpha = hasSelectedStore ? 1.0 : 0.5
    }
    
    private func checkoutButtonTapped() {
        
        guard viewModel.selectedStore != nil else {
            return
        }
        
        checkoutButton.isEnabled = false
        viewModel.createOrder()
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
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CheckoutViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.stores.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StoreCell.identifier,
            for: indexPath
        ) as? StoreCell else {
            return UITableViewCell()
        }
        
        let store = viewModel.stores[indexPath.row]
        
        cell.configure(
            with: store,
            isSelected: viewModel.selectedStore?.id == store.id
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CheckoutViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        viewModel.selectStore(at: indexPath.row)
    }
}
