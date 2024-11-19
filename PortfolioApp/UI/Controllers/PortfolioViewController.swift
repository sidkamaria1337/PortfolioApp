//
//  PortfolioViewController.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit
import Combine

final class PortfolioViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private var subscribers: Set<AnyCancellable> = .init()
    private let viewModel: PortfolioViewModel
    
    // MARK: - Views
    
    private let activityIndicator = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        return tableView
    }()
    
    private let portfolioSummaryView: PortfolioSummaryView = {
        let view = PortfolioSummaryView()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: PortfolioViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupTableView()
        setupPortfolioSummaryView()
        setupSafeAreaView()
        setupActivityIndicator()
        setupErrorView()
        setupViewModel()
    }
    
    deinit {
        subscribers.removeAll()
    }
}

// MARK: - View setup
private extension PortfolioViewController {
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupErrorView() {
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupContainerView() {
        view.backgroundColor = UIColor.systemBackground
        title = String(localized: "screenTitle")
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableView.register(PortfolioHoldingCell.self, forCellReuseIdentifier: PortfolioHoldingCell.reuseIdentifier)
    }
    
    func setupPortfolioSummaryView() {
        view.addSubview(portfolioSummaryView)
        NSLayoutConstraint.activate([
            portfolioSummaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioSummaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            portfolioSummaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupSafeAreaView() {
        let safeAreaView = UIView()
        view.addSubview(safeAreaView)
        safeAreaView.backgroundColor = .systemGray6
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - View model setup
private extension PortfolioViewController {
    
    func setupViewModel() {
        activityIndicator.startAnimating()
        setupPortfolioSubscriber()
        setupErrorSubscriber()
        viewModel.fetchPortfolio()
    }
    
    func setupPortfolioSubscriber() {
        viewModel.$portfolio
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.activityIndicator.stopAnimating()
                if case .failure(_) = completion {
                    self.errorView.showError(message: String(localized: "unableToFetchPortfolio"))
                    self.errorView.isHidden = false
                }
            } receiveValue: { [weak self] holdings in
                guard let self else { return }
                if !holdings.isEmpty {
                    self.tableView.reloadData()
                    self.portfolioSummaryView.configure(
                        currentValue: viewModel.currentValue,
                        totalInvestment: viewModel.totalInvestment,
                        todaysProfitLoss: viewModel.todaysProfitLoss,
                        totalProfitLoss: viewModel.totalProfitLoss
                    )
                    self.tableView.isHidden = false
                    self.portfolioSummaryView.isHidden = false
                    self.errorView.isHidden = true
                    self.activityIndicator.isHidden = true
                }
            }
            .store(in: &subscribers)
    }
    
    func setupErrorSubscriber() {
        viewModel.$errorMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                self.activityIndicator.stopAnimating()
                self.errorView.showError(message: errorMessage ?? String(localized: "unableToFetchPortfolio"))
                self.errorView.isHidden = false
                self.tableView.isHidden = true
                self.portfolioSummaryView.isHidden = true
            }
            .store(in: &subscribers)
    }
}

// MARK: - Table view protocols
extension PortfolioViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.portfolio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioHoldingCell.reuseIdentifier, for: indexPath) as? PortfolioHoldingCell, let holding = viewModel.holding(at: indexPath.row) else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(with: holding)
        return cell
    }
}

