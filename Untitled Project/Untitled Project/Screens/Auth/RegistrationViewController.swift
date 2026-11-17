//
//  RegistrationViewController.swift
//  MyApp
//
//  Created by student-4 on 17.11.2026.
//

import UIKit

final class RegistrationViewController: UIViewController {
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let registrationButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Регистрация"
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

        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(registrationButton)

        NSLayoutConstraint.activate([
            loginField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 12),
            passwordField.leadingAnchor.constraint(equalTo: loginField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: loginField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            registrationButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func registerTapped() {
        let login = loginField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordField.text ?? ""
        guard !login.isEmpty, !password.isEmpty else {
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Введите логин и пароль",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }
        AuthStorage.shared.save(login: login, password: password)
        navigationController?.pushViewController(LoadingViewController(), animated: true)
    }
}
