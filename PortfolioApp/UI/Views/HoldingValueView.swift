//
//  HoldingValueView.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

final class HoldingValueView: UIStackView {
    
    private let keyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    init(for keyName: String) {
        super.init(frame: .zero)
        spacing = 4
        alignment = .center
        addArrangedSubview(keyLabel)
        addArrangedSubview(valueLabel)
        keyLabel.text = keyName
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: String, textColor: UIColor = .label) {
        valueLabel.text = value
        valueLabel.textColor = textColor
    }
}
