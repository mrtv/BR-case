//
//  PhotoDetailCoordinator.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation
import UIKit

class PhotoDetailCoordinator: Coordinator {
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var selectedPhoto: PhotoListItem
    
    init(navigationController: UINavigationController,
         selectedPhoto: PhotoListItem) {
        self.navigationController = navigationController
        self.selectedPhoto = selectedPhoto
    }
    
    func start() {
        let photoDetailViewModel = PhotoDetailViewModel(coordinator: self, item: selectedPhoto)
        let photoDetailViewController = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        photoDetailViewController.viewModel = photoDetailViewModel
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}
