//
//  SettingsViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: SettingsViewModelProtocol
    private var selectedAvatar: Avatar
    
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
    
    private let avatarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Аватар"
        label.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите имя"
        textField.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "Сохранить",
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
    
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        self.selectedAvatar = viewModel.userAvatar
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
        bindViewModel()
        configure()
    }
    
    private func setupUI() {
        navigationItem.title = "Настройки"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        view.addSubview(avatarTitleLabel)
        view.addSubview(avatarImageView)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            headerView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            
            logoImageView.centerXAnchor.constraint(
                equalTo: headerView.centerXAnchor
            ),
            logoImageView.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            logoImageView.heightAnchor.constraint(
                equalToConstant: 64
            ),
            
            avatarTitleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            avatarTitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            avatarTitleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            
            avatarImageView.topAnchor.constraint(
                equalTo: avatarTitleLabel.bottomAnchor,
                constant: 16
            ),
            avatarImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: 90
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: 90
            ),
            
            nameTitleLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 32
            ),
            nameTitleLabel.leadingAnchor.constraint(
                equalTo: avatarTitleLabel.leadingAnchor
            ),
            nameTitleLabel.trailingAnchor.constraint(
                equalTo: avatarTitleLabel.trailingAnchor
            ),
            
            nameTextField.topAnchor.constraint(
                equalTo: nameTitleLabel.bottomAnchor,
                constant: 12
            ),
            nameTextField.leadingAnchor.constraint(
                equalTo: avatarTitleLabel.leadingAnchor
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: avatarTitleLabel.trailingAnchor
            ),
            nameTextField.heightAnchor.constraint(
                equalToConstant: 50
            ),

            saveButton.leadingAnchor.constraint(
                equalTo: avatarTitleLabel.leadingAnchor
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: avatarTitleLabel.trailingAnchor
            ),
            saveButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            saveButton.heightAnchor.constraint(
                equalToConstant: 50
            )
        ])
    }
    
    private func setupActions() {
        
        saveButton.addAction(
            UIAction { [weak self] _ in
                self?.saveButtonTapped()
            },
            for: .touchUpInside
        )
        
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(selectAvatar)
            )
        
        avatarImageView.addGestureRecognizer(tap)
    }
    
    private func bindViewModel() {
        
        viewModel.onProfileUpdated = { [weak self] in
            self?.navigationController?.popViewController(
                animated: true
            )
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    private func configure() {
        nameTextField.text = viewModel.userName
        avatarImageView.image = selectedAvatar.image
    }
    
    private func saveButtonTapped() {
        
        guard let name = nameTextField.text else {
            return
        }
        
        viewModel.updateProfile(
            name: name,
            avatar: selectedAvatar
        )
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
    
    @objc private func selectAvatar() {
        let vc = AvatarViewController { [weak self] avatar in
            self?.selectedAvatar = avatar
            self?.avatarImageView.image = avatar.image
        }
        
        present(vc, animated: true)
    }
}
