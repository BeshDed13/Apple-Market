//
//  SupportViewController.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 12.08.2026.
//

import UIKit

final class SupportViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: SupportViewModelProtocol
    
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
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите сообщение..."
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 20
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 14, height: 1)
        )
        textField.leftViewMode = .always
        textField.rightView = UIView(
            frame: CGRect(x: 0, y: 0, width: 14, height: 1)
        )
        textField.rightViewMode = .always
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "arrow.up.circle.fill"),
            for: .normal
        )
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: SupportViewModelProtocol) {
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
        
        viewModel.loadMessages()
    }
    
    private func setupUI() {
        navigationItem.title = "Поддержка"
        view.backgroundColor = DesignSystem.Colors.primary
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        
        inputContainerView.addSubview(messageTextField)
        inputContainerView.addSubview(sendButton)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // MARK: - Header
            
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
            
            // MARK: - Table
            
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: inputContainerView.topAnchor
            ),
            
            // MARK: - Input
            
            inputContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 12
            ),
            inputContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -12
            ),
            inputContainerView.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor,
                constant: -8
            ),
            inputContainerView.heightAnchor.constraint(
                equalToConstant: 50
            ),
            
            messageTextField.leadingAnchor.constraint(
                equalTo: inputContainerView.leadingAnchor
            ),
            messageTextField.topAnchor.constraint(
                equalTo: inputContainerView.topAnchor
            ),
            messageTextField.bottomAnchor.constraint(
                equalTo: inputContainerView.bottomAnchor
            ),
            messageTextField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: -8
            ),
            
            sendButton.trailingAnchor.constraint(
                equalTo: inputContainerView.trailingAnchor
            ),
            sendButton.centerYAnchor.constraint(
                equalTo: inputContainerView.centerYAnchor
            ),
            sendButton.widthAnchor.constraint(
                equalToConstant: 42
            ),
            sendButton.heightAnchor.constraint(
                equalToConstant: 42
            )
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SupportMessageCell.self,
            forCellReuseIdentifier: SupportMessageCell.identifier
        )
    }
    
    private func setupActions() {
        sendButton.addTarget(
            self,
            action: #selector(sendButtonTapped),
            for: .touchUpInside
        )
        
        messageTextField.delegate = self
    }
    
    private func bindViewModel() {
        
        viewModel.onMessagesUpdated = { [weak self] in
            guard let self else {
                return
            }
            
            self.tableView.reloadData()
            self.scrollToBottom()
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }
    
    @objc
    private func sendButtonTapped() {
        sendMessage()
    }
    
    private func sendMessage() {
        
        guard let text = messageTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }
        
        messageTextField.text = nil
        
        viewModel.sendMessage(text: text)
    }
    
    private func scrollToBottom() {
        
        guard !viewModel.messages.isEmpty else {
            return
        }
        
        let indexPath = IndexPath(
            row: viewModel.messages.count - 1,
            section: 0
        )
        
        tableView.scrollToRow(
            at: indexPath,
            at: .bottom,
            animated: true
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
}
extension SupportViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.messages.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SupportMessageCell.identifier,
            for: indexPath
        ) as? SupportMessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(
            with: viewModel.messages[indexPath.row]
        )
        
        return cell
    }
}
extension SupportViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}
extension SupportViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        
        sendMessage()
        return true
    }
}
