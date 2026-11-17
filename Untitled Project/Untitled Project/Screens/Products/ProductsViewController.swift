//
//  ProductsViewController.swift
//  MyApp
//
//  Created by student-4 on 17.11.2026.
//

import UIKit

final class ProductsViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)

    private let orangeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 210)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.18)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let greenTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .singleLine
        tv.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.08)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var allOrangeProducts: [Product]
    private var filteredOrangeProducts: [Product]
    private var greenProducts: [Product]
    private var isSortedAscending = true

    init(orange: [Product], green: [Product]) {
        allOrangeProducts = orange
        filteredOrangeProducts = orange
        greenProducts = green
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupDelegates()
        loadSortDirection()
        applySort()
        orangeCollectionView.reloadData()
        greenTableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderSize()
    }

    private func setupNavigationBar() {
        title = "Продукты"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        navigationItem.rightBarButtonItems = [logoutButton, sortButton]
    }

    private func setupUI() {
        view.addSubview(greenTableView)
        NSLayoutConstraint.activate([
            greenTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            greenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 246))
        header.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.18)
        header.addSubview(orangeCollectionView)
        NSLayoutConstraint.activate([
            orangeCollectionView.topAnchor.constraint(equalTo: header.topAnchor),
            orangeCollectionView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            orangeCollectionView.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            orangeCollectionView.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        greenTableView.tableHeaderView = header
    }

    private func updateHeaderSize() {
        guard let header = greenTableView.tableHeaderView else { return }
        let width = greenTableView.bounds.width
        guard header.frame.width != width else { return }
        header.frame.size.width = width
        greenTableView.tableHeaderView = header
    }

    private func setupDelegates() {
        orangeCollectionView.dataSource = self
        orangeCollectionView.delegate = self
        orangeCollectionView.register(OrangeProductCell.self, forCellWithReuseIdentifier: OrangeProductCell.reuseID)

        greenTableView.dataSource = self
        greenTableView.delegate = self
        greenTableView.register(GreenProductCell.self, forCellReuseIdentifier: GreenProductCell.reuseID)
        greenTableView.rowHeight = 94
    }

    @objc private func sortTapped() {
        isSortedAscending.toggle()
        UserDefaults.standard.set(isSortedAscending, forKey: AuthStorage.sortAscendingKey)
        applySort()
        greenTableView.reloadData()
    }

    @objc private func logoutTapped() {
        AppWindow.logout()
    }

    private func applySort() {
        greenProducts.sort {
            isSortedAscending ? $0.price < $1.price : $0.price > $1.price
        }
    }

    private func loadSortDirection() {
        if UserDefaults.standard.object(forKey: AuthStorage.sortAscendingKey) != nil {
            isSortedAscending = UserDefaults.standard.bool(forKey: AuthStorage.sortAscendingKey)
        }
    }
}

extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredOrangeProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OrangeProductCell.reuseID,
            for: indexPath
        ) as? OrangeProductCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: filteredOrangeProducts[indexPath.item])
        return cell
    }
}

extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        greenProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GreenProductCell.reuseID,
            for: indexPath
        ) as? GreenProductCell else {
            return UITableViewCell()
        }
        cell.configure(with: greenProducts[indexPath.row])
        return cell
    }
}

extension ProductsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), !text.isEmpty else {
            filteredOrangeProducts = allOrangeProducts
            orangeCollectionView.reloadData()
            return
        }
        filteredOrangeProducts = allOrangeProducts.filter {
            $0.title.lowercased().contains(text) ||
            $0.category.lowercased().contains(text)
        }
        orangeCollectionView.reloadData()
    }
}
