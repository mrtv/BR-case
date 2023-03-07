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
    func start()
}

/// Composition root
class MainCoordinator: Coordinator {
    private let storyboard = UIStoryboard(name: "Main", bundle: .main)
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let baseURLComponents = BaseURLComponents(scheme: "https",
                                                  host: "www.flickr.com",
                                                  path: "/services/rest/")
        let client = RemoteClient(baseURLComponents: baseURLComponents)
        let searchPhotoUseCase = DefaultSearchPhotoUseCase(client: client)
        let photoSearchViewModel = PhotoSearchViewModel(searchPhotosUseCase: searchPhotoUseCase)
        let photoSearchViewController = storyboard.instantiateViewController(withIdentifier: "PhotoSearchViewController") as! PhotoSearchViewController
        photoSearchViewController.viewModel = photoSearchViewModel
        navigationController.pushViewController(photoSearchViewController, animated: false)
    }
}
