import UIKit

final class LoadingViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить ещё раз", for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupNavigationBar()
        setupLayout()
        loadData()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(activityIndicator)
        view.addSubview(statusLabel)
        view.addSubview(errorLabel)
        view.addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadData() {
        showLoading()
        Task {
            do {
                let result = try await ProductsService.shared.fetchAll()
                await MainActor.run {
                    let products = ProductsViewController(orange: result.orange, green: result.green)
                    navigationController?.setViewControllers([products], animated: true)
                }
            } catch {
                await MainActor.run {
                    showError("Не удалось загрузить данные.\nПроверьте интернет и попробуйте ещё раз.")
                }
            }
        }
    }

    private func showLoading() {
        activityIndicator.startAnimating()
        statusLabel.isHidden = false
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func showError(_ message: String) {
        activityIndicator.stopAnimating()
        statusLabel.isHidden = true
        errorLabel.text = message
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }

    @objc private func retryTapped() {
        loadData()
    }

    @objc private func logoutTapped() {
        AppWindow.logout()
    }
}
