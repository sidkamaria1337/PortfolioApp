//
//  MainCoordinator.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let portfolioVC = PortfolioViewController()
        portfolioVC.coordinator = self
        navigationController.pushViewController(portfolioVC, animated: animated)
    }
}
