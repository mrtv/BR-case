//
//  Coordinator.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set}
    var childCoordinators: [Coordinator] { get set }
    func start()
}
