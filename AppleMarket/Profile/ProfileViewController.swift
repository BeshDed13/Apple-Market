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
    private let profileHeaderView = ProfileHeaderView()
    private let profileMenuView = ProfileMenuView()
    
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var logoutBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
        style: .plain,
        target: self,
        action: #selector(logoutTapped)
    )
    
    private lazy var notificationsBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "bell"),
        style: .plain,
        target: self,
        action: #selector(notificationsTapped)
    )
    
    var onLoginTapped: (() -> Void)?
    var onSignUpTapped: (() -> Void)?
    var onOrdersTapped: ((UserModel) -> Void)?
    var onSettingsTapped: (() -> Void)?
    var onSupportTapped: (() -> Void)?
    var onNotificationsTapped: ((UserModel) -> Void)?
    
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
        
        viewModel.onStateChanged = { [weak self] in
            self?.updateUI()
        }
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadProfile()
    }
    
    private func setupUI() {
        navigationItem.title = "Профиль"
        
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(profileHeaderView)
        view.addSubview(authenticationView)
        view.addSubview(activityIndicator)
        view.addSubview(headerView)
        view.addSubview(profileMenuView)

        profileMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(logoImageView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.configure(
            title: "Войдите или зарегистрируйтесь, чтобы создать личный кабинет"
        )
    }
    
    private func updateUI() {

        switch viewModel.authState {
            
        case .loading:
            authenticationView.isHidden = true
            profileHeaderView.isHidden = true
            profileMenuView.isHidden = true
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
            activityIndicator.startAnimating()

        case .guest:
            activityIndicator.stopAnimating()
            profileHeaderView.isHidden = true
            profileMenuView.isHidden = true
            authenticationView.isHidden = false
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil

        case .authorized(let user):
            activityIndicator.stopAnimating()
            profileHeaderView.isHidden = false
            profileMenuView.isHidden = false
            authenticationView.isHidden = true
            navigationItem.rightBarButtonItem = logoutBarButtonItem
            navigationItem.leftBarButtonItem = notificationsBarButtonItem
            
            profileHeaderView.configure(avatarId: user.avatar.rawValue, name: user.name)
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
            
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 100),
            
            profileMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            profileMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            profileMenuView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 32),
            profileMenuView.heightAnchor.constraint(equalToConstant: 300),
            
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
        
        profileMenuView.onSettingsTapped = { [weak self] in
            self?.onSettingsTapped?()
        }
        
        profileMenuView.onOrdersTapped = { [weak self] in
            
            guard let self,
                  case .authorized(let user) = self.viewModel.authState else {
                return
            }
            
            self.onOrdersTapped?(user)
        }
        
        profileMenuView.onSupportTapped = { [weak self] in
            self?.onSupportTapped?()
        }
    }
    
    @objc
    private func logoutTapped() {
        let alert = UIAlertController(
            title: "Выйти из аккаунта?",
            message: "Вы действительно хотите выйти?",
            preferredStyle: .alert
        )
        
        let logoutAction = UIAlertAction(
            title: "Выйти",
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.logout()
        }
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func notificationsTapped() {
        
        guard case .authorized(let user) = viewModel.authState else {
            return
        }
        
        onNotificationsTapped?(user)
    }
}
