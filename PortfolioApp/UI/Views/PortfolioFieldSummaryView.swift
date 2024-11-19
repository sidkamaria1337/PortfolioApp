//
//  PortfolioFieldSummaryView.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

final class PortfolioFieldSummaryView: UIStackView {
        
    private let fieldNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .firstBaseline
        return stackView
    }()
    
    private let fieldNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private let chevronImage: UIImageView = {
        let symbolConfig = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        let symbol = UIImage(systemName: "chevron.up", withConfiguration: symbolConfig)
        let imageView = UIImageView(image: symbol)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    init(for fieldName: String, showDropwdown: Bool = false) {
        super.init(frame: .zero)
        distribution = .equalSpacing
        addArrangedSubview(fieldNameStackView)
        addArrangedSubview(valueLabel)
        fieldNameStackView.addArrangedSubview(fieldNameLabel)
        fieldNameLabel.text = fieldName
        if showDropwdown {
            fieldNameStackView.addArrangedSubview(chevronImage)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleChevron() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.chevronImage.transform = self.chevronImage.transform.rotated(by: .pi)
        }
    }
    
    func setValue(_ value: String, textColor: UIColor = .label) {
        valueLabel.text = value
        valueLabel.textColor = textColor
    }
}
