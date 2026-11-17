//
//  LoginViewController.swift
//  MyApp
//
//  Created by student-4 on 17.11.2026.
//

// xcode: set sdk=iOS

import UIKit

final class LoginViewController: UIViewController {
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Вход"
        setupFields()
        setupLayout()
    }

    private func setupFields() {
        loginField.placeholder = "Логин"
        loginField.borderStyle = .roundedRect
        loginField.autocapitalizationType = .none
        loginField.autocorrectionType = .no
        loginField.translatesAutoresizingMaskIntoConstraints = false

        passwordField.placeholder = "Пароль"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false

        loginButton.setTitle("Войти", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: loginField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: loginField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func loginTapped() {
        let login = loginField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text ?? ""
        guard let stored = AuthStorage.shared.load(),
              stored.login == login,
              stored.password == password else {
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Неверный логин или пароль",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }
        navigationController?.pushViewController(LoadingViewController(), animated: true)
    }
}
