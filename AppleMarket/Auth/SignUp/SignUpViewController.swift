//
//  SignUpViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    var onSignUpSuccess: (() -> Void)?
    
    private let viewModel: SignUpViewModelProtocol
    
    private var selectedAvatar: Avatar?
    private let nameTextField = CustomTextField()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let signUpButton = SignUpButton()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.circle")
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажимая кнопку \"Завершить регистрацию\", вы соглашаетесь с условиями использования и политикой конфиденциальности"
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Init
    
    init(viewModel: SignUpViewModelProtocol) {
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
        setupActions()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel.didSignUpSuccessfully = { [weak self] in
            self?.onSignUpSuccess?()
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        navigationItem.title = "Зарегистрироваться"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(signUpButton)
        contentView.addSubview(agreementLabel)
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        nameTextField.placeholder = "Имя"
        nameTextField.keyboardType = .default
        nameTextField.textContentType = .name
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .next
        
        emailTextField.placeholder = "Почта"
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.returnKeyType = .next
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .newPassword
        passwordTextField.returnKeyType = .done
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            agreementLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 24),
            agreementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            agreementLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            agreementLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        signUpButton.addTarget(
            self,
            action: #selector(signUpTapped),
            for: .touchUpInside
        )
        
        avatarImageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(selectAvatar)
        )

        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc private func signUpTapped() {
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let avatar = selectedAvatar
        else {
            showAlert(message: "Заполните все поля и выберите аватара")
            return
        }


        let request = SignUpRequest(
            name: name,
            email: email,
            password: password,
            avatar: avatar
        )
        viewModel.signUp(request: request)
    }
    
    @objc private func selectAvatar() {
        let vc = AvatarViewController { [weak self] avatar in
            self?.selectedAvatar = avatar
            self?.avatarImageView.image = avatar.image
        }
        
        present(vc, animated: true)
    }
    
    // MARK: - Alert
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
            
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            
        default:
            break
        }
        
        return true
    }
}
