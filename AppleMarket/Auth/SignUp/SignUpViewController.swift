//
//  SignUpViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    var onSignUpSuccess: (() -> Void)?
    
    private let viewModel: SignUpViewModelProtocol
    
    private var selectedAvatar: Avatar?
    
    private let nameTextField = CustomTextField()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let signUpButton = SignUpButton()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.crop.circle")
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
    
    init(viewModel: SignUpViewModelProtocol) {
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
        
        viewModel.didSignUpSuccessfully = { [weak self] in
            self?.onSignUpSuccess?()
        }
    }
    
    private func setupUI() {
        navigationItem.title = "Зарегистрироваться"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(avatarImageView)
        view.addSubview(signUpButton)
        view.addSubview(agreementLabel)
        
        nameTextField.placeholder = "Имя"
        emailTextField.placeholder = "Почта"
        passwordTextField.placeholder = "Пароль"
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -16),
            
            agreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            agreementLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 24),
        ])
    }
    
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
            showAlert(message: "Заполните все поля и выберите аватарку")
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }

}
