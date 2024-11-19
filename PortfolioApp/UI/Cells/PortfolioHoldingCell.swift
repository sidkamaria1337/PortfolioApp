//
//  PortfolioHoldingCell.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

final class PortfolioHoldingCell: UITableViewCell {
    
    static let reuseIdentifier: String = "PortfolioHoldingCell"
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let symbolAndLTPStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        return stackView
    }()
    
    private let netQtyAndPLStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        return stackView
    }()
    
    private let holdingSymbol: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private lazy var ltpView = HoldingValueView(for: String(localized: "ltpKey"))
    private lazy var netQtyView = HoldingValueView(for: String(localized: "netQtyKey"))
    private lazy var profitLossView = HoldingValueView(for: String(localized: "plKey"))
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupMainStackView()
        setupSymbolAndLTPStackView()
        setupNetQtyAndPLStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with holding: PortfolioHolding) {
        holdingSymbol.text = holding.symbol
        ltpView.setValue(holding.ltpString)
        netQtyView.setValue(holding.netQtyString)
        profitLossView.setValue(holding.totalProfitLossString, textColor: holding.totalProfitLoss < 0 ? .systemRed : .systemGreen)
    }
}

private extension PortfolioHoldingCell {
    func setupContainerView() {
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupMainStackView() {
        mainStackView.addArrangedSubview(symbolAndLTPStackView)
        mainStackView.addArrangedSubview(netQtyAndPLStackView)
    }
    
    func setupSymbolAndLTPStackView() {
        symbolAndLTPStackView.addArrangedSubview(holdingSymbol)
        symbolAndLTPStackView.addArrangedSubview(UIView()) // Spacer
        symbolAndLTPStackView.addArrangedSubview(ltpView)
    }
    
    func setupNetQtyAndPLStackView() {
        netQtyAndPLStackView.addArrangedSubview(netQtyView)
        netQtyAndPLStackView.addArrangedSubview(UIView()) // Spacer
        netQtyAndPLStackView.addArrangedSubview(profitLossView)
    }
}
