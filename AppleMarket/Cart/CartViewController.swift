//
//  CartViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    var onLoginTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    var onPlaceAnOrderTapped: (([CartProduct], UserModel) -> Void)?
    
    private let viewModel: CartViewModelProtocol
    private let imageLoader: ImageLoaderProtocol
    
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
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textColor = DesignSystem.Colors.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authenticationView = AuthenticationView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let placeAnOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = DesignSystem.Radius.buttonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: CartViewModelProtocol, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        
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
        setupActions()
        setupTableView()
        
        viewModel.onStateChanged = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.onCartUpdated = { [weak self] in
            guard let self else { return }
            
            tableView.reloadData()
            totalLabel.text = "Итого: \(viewModel.totalPrice) ₽"
        }
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await viewModel.loadCart()
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        navigationItem.title = "Корзина"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(authenticationView)
        view.addSubview(activityIndicator)
        view.addSubview(placeAnOrderButton)
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        
        authenticationView.configure(
            title: "Войдите или зарегистрируйтесь, чтобы просматривать корзину"
        )
    }
    
    private func setupTableView() {
        
        tableView.register(
            CartCell.self,
            forCellReuseIdentifier: CartCell.reuseIdentifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 130
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

            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emptyLabel.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalLabel.trailingAnchor.constraint(equalTo: placeAnOrderButton.trailingAnchor, constant: -16),
            totalLabel.centerYAnchor.constraint(equalTo: placeAnOrderButton.centerYAnchor),
            
            authenticationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            authenticationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            authenticationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            authenticationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeAnOrderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeAnOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            placeAnOrderButton.heightAnchor.constraint(equalToConstant: 50),
            placeAnOrderButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        
        authenticationView.onLoginTapped = { [weak self] in
            self?.onLoginTapped?()
        }
        
        authenticationView.onSignUpTapped = { [weak self] in
            self?.onSignUpTapped?()
        }
        
        placeAnOrderButton.addAction(
            UIAction { [weak self] _ in
                self?.placeAnOrderButtonTapped()
            },
            for: .touchUpInside
        )
    }
    
    private func placeAnOrderButtonTapped() {
        
        guard case .authorized(let user) = viewModel.authState else {
            return
        }
        
        onPlaceAnOrderTapped?(
            viewModel.cartProducts,
            user
        )
    }
    
    // MARK: - Update UI
    
    private func updateUI() {
        
        switch viewModel.authState {
            
        case .loading:
            
            activityIndicator.startAnimating()
            
            authenticationView.isHidden = true
            tableView.isHidden = true
            emptyLabel.isHidden = true
            totalLabel.isHidden = true
            placeAnOrderButton.isHidden = true
            
        case .guest:
            
            activityIndicator.stopAnimating()
            
            authenticationView.isHidden = false
            tableView.isHidden = true
            emptyLabel.isHidden = true
            totalLabel.isHidden = true
            placeAnOrderButton.isHidden = true
            
        case .authorized:
            
            activityIndicator.stopAnimating()
            
            authenticationView.isHidden = true
            
            let isEmpty = viewModel.cartProducts.isEmpty
            
            tableView.isHidden = isEmpty
            emptyLabel.isHidden = !isEmpty
            totalLabel.isHidden = isEmpty
            placeAnOrderButton.isHidden = isEmpty
            
            if !isEmpty {
                tableView.reloadData()
                totalLabel.text = "Итого: \(viewModel.totalPrice) ₽"
            }
        }
    }
    
    private func showDeleteConfirmation(at indexPath: IndexPath) {
        
        guard indexPath.row < viewModel.cartProducts.count else {
            return
        }
        
        let item = viewModel.cartProducts[indexPath.row]
        
        let alert = UIAlertController(
            title: "Удалить товар?",
            message: "Вы действительно хотите удалить «\(item.product.name)» из корзины?",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Удалить",
                style: .destructive
            ) { [weak self] _ in
                
                self?.viewModel.removeItem(at: indexPath.row)
            }
        )
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.cartProducts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartCell.reuseIdentifier,
            for: indexPath
        ) as? CartCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.cartProducts[indexPath.row]
        
        cell.configure(
            with: item,
            imageLoader: imageLoader
        )
        
        cell.onIncreaseTapped = { [weak self] in
            self?.viewModel.increaseQuantity(at: indexPath.row)
        }
        
        cell.onDecreaseTapped = { [weak self] in
            self?.viewModel.decreaseQuantity(at: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completion in
            
            self?.showDeleteConfirmation(at: indexPath)
            
            completion(true)
        }
        
        deleteAction.image = UIImage(
            systemName: "trash"
        )
        
        let configuration = UISwipeActionsConfiguration(
            actions: [deleteAction]
        )
        
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}
