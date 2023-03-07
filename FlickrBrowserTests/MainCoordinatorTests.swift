//
//  MainCoordinatorTests.swift
//  FlickrBrowserTests
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import XCTest
@testable import FlickrBrowser

final class MainCoordinatorTests: XCTestCase {
    func test_init_doesNotCreateViewControllerInHiearchy() {
        let navigationController = UINavigationController()
        let _ = MainCoordinator(navigationController: navigationController)
        
        XCTAssertEqual(navigationController.viewControllers.count, 0,
                       "Expected to have no viewControllers in navigationController, but got \(navigationController.viewControllers.count)")
    }

    func test_start_createsPhotoSearchViewController() {
        let navigationController = UINavigationController()
        let sut = MainCoordinator(navigationController: navigationController)
        
        sut.start()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1,
                       "Expected to have 1 viewController in navigationController, but got \(navigationController.viewControllers.count)")
        XCTAssert(navigationController.viewControllers.first!.isKind(of: PhotoSearchViewController.self),
                  "Expected to have PhotoSearchViewController in hierarchy, but got \(navigationController.viewControllers.first!.self) instead")
    }
}
