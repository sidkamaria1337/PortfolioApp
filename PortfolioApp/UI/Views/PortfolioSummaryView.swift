//
//  PortfolioSummaryView.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

final class PortfolioSummaryView: UIView {
    
    private var isExpanded: Bool = false
    private var heightConstraint: NSLayoutConstraint?
    private let collapsedHeight: CGFloat = 48
    private let expandedHeight: CGFloat = 182
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var expandingSummaryView = UIView()
    
    private let expandingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var overallSummaryView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrCollapseView)))
        return view
    }()
        
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }()
    
    private lazy var profitLossSummaryView = PortfolioFieldSummaryView(for: String(localized: "profitLossKey"), showDropwdown: true)
    private lazy var currentValueSummaryView = PortfolioFieldSummaryView(for: String(localized: "currentValueKey"))
    private lazy var totalInvestmentSummaryView = PortfolioFieldSummaryView(for: String(localized: "totalInvestmentKey"))
    private lazy var todaysProfitLossSummaryView = PortfolioFieldSummaryView(for: String(localized: "todaysProfitLossKey"))
    
    init() {
        super.init(frame: .zero)
        setupContainerView()
        setupOverallSummaryView()
        setupExpandingStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(currentValue: Double, totalInvestment: Double, todaysProfitLoss: Double, totalProfitLoss: Double) {
        currentValueSummaryView.setValue(Utility.formattedAmount(currentValue))
        totalInvestmentSummaryView.setValue(Utility.formattedAmount(totalInvestment))
        todaysProfitLossSummaryView.setValue(Utility.formattedAmount(todaysProfitLoss), textColor: todaysProfitLoss < 0 ? .systemRed : .systemGreen)
        profitLossSummaryView.setValue(Utility.formattedAmount(totalProfitLoss), textColor: totalProfitLoss < 0 ? .systemRed : .systemGreen)
    }
}

private extension PortfolioSummaryView {
    
    func setupContainerView() {
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray4.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(expandingSummaryView)
        mainStackView.addArrangedSubview(overallSummaryView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        self.heightConstraint = mainStackView.heightAnchor.constraint(equalToConstant: collapsedHeight)
        self.heightConstraint?.isActive = true
    }
    
    func setupOverallSummaryView() {
        overallSummaryView.addSubview(profitLossSummaryView)
        profitLossSummaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profitLossSummaryView.topAnchor.constraint(equalTo: overallSummaryView.topAnchor, constant: 12),
            profitLossSummaryView.leadingAnchor.constraint(equalTo: overallSummaryView.leadingAnchor, constant: 20),
            profitLossSummaryView.bottomAnchor.constraint(equalTo: overallSummaryView.bottomAnchor, constant: -12),
            profitLossSummaryView.trailingAnchor.constraint(equalTo: overallSummaryView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupExpandingStackView() {
        expandingSummaryView.addSubview(expandingStackView)
        expandingSummaryView.isHidden = true
        expandingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandingStackView.leadingAnchor.constraint(equalTo: expandingSummaryView.leadingAnchor, constant: 20),
            expandingStackView.bottomAnchor.constraint(equalTo: expandingSummaryView.bottomAnchor),
            expandingStackView.trailingAnchor.constraint(equalTo: expandingSummaryView.trailingAnchor, constant: -20)
        ])
        expandingStackView.addArrangedSubview(currentValueSummaryView)
        expandingStackView.addArrangedSubview(totalInvestmentSummaryView)
        expandingStackView.addArrangedSubview(todaysProfitLossSummaryView)
        expandingStackView.addArrangedSubview(divider)
    }
    
    @objc func expandOrCollapseView() {
        isExpanded.toggle()
        profitLossSummaryView.toggleChevron()
        heightConstraint?.constant = isExpanded ? expandedHeight : collapsedHeight
        UIView.animate(withDuration: 0.2) { [weak self] in
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self else { return }
                self.mainStackView.layoutIfNeeded()
                self.expandingSummaryView.isHidden = !isExpanded
            }
        }
    }
}
