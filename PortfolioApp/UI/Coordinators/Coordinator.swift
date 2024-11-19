//
//  Coordinator.swift
//  PortfolioApp
//
//  Created by Siddharth Kamaria on 15/11/24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start(animated: Bool)
}
