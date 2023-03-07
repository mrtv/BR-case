//
//  MainCoordinator.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set}
    var childCoordinators: [Coordinator] { get set }
    func start()
}

/// Composition root
class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let baseURLComponents = BaseURLComponents(scheme: "https",
                                                  host: "www.flickr.com",
                                                  path: "/services/rest/")
        let client = RemoteClient(baseURLComponents: baseURLComponents)
        let searchPhotoUseCase = DefaultSearchPhotoUseCase(client: client)
        let photoSearchViewModel = PhotoSearchViewModel(searchPhotosUseCase: searchPhotoUseCase, coordinator: self)
        let photoSearchViewController = storyboard.instantiateViewController(withIdentifier: "PhotoSearchViewController") as! PhotoSearchViewController
        photoSearchViewController.viewModel = photoSearchViewModel
        navigationController.pushViewController(photoSearchViewController, animated: false)
    }
    
    func showDetail(selectedPhoto: PhotoListItem) {
        let childCoordinator = PhotoDetailCoordinator(navigationController: self.navigationController, selectedPhoto: selectedPhoto)
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let photoDetailViewController = fromViewController as? PhotoDetailViewController {
            childDidFinish(photoDetailViewController.viewModel.coordinator)
        }
    }
}
