//
//  ProfileViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 24.06.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    
    private let authenticationView = AuthenticationView()
    
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var onLoginTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        updateUI()
        
        viewModel.onStateChanged = { [weak self] in
            self?.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            await viewModel.loadProfile()
        }
    }
    
    private func setupUI () {
        navigationItem.title = "Профиль"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(authenticationView)
        view.addSubview(nameLabel)
        view.addSubview(activityIndicator)
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.configure(
            title: "Войдите или зарегистрируйтесь, чтобы создать личный кабинет"
        )
    }
    
    private func updateUI() {

        switch viewModel.authState {
            
        case .loading:
            authenticationView.isHidden = true
            nameLabel.isHidden = true
            activityIndicator.startAnimating()

        case .guest:
            activityIndicator.stopAnimating()
            authenticationView.isHidden = false
            nameLabel.isHidden = true

        case .authorized(let user):
            activityIndicator.stopAnimating()
            authenticationView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = "Привет, \(user.name)"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            authenticationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            authenticationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            authenticationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            authenticationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    private func setupActions() {
        authenticationView.onLoginTapped = { [weak self] in
            self?.onLoginTapped?()

        }
        authenticationView.onSignUpTapped = { [weak self] in
            self?.onSignUpTapped?()
        }
    }
}
