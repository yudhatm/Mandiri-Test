//
//  Coordinator.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

