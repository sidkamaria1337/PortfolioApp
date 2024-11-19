//
//  ErrorView.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 18/11/24.
//

import UIKit

final class ErrorView: UIStackView {
    
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        alignment = .center
        addArrangedSubview(iconView)
        addArrangedSubview(messageLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showError(message: String) {
        messageLabel.text = message
    }
}

