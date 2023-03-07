//
//  PhotoDetailCoordinatorTests.swift
//  FlickrBrowserTests
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import XCTest
@testable import FlickrBrowser

final class PhotoDetailCoordinatorTests: XCTestCase {
    func test_init_doesNotCreateViewControllerInHiearchy() {
        let navigationController = UINavigationController()
        let selectedPhoto = PhotoListItem(id: "1", title: "some title", thumbnailImageURL: nil, fullImageURL: nil)
        let _ = PhotoDetailCoordinator(navigationController: navigationController, selectedPhoto: selectedPhoto)
        
        XCTAssertEqual(navigationController.viewControllers.count, 0,
                       "Expected to have no viewControllers in navigationController, but got \(navigationController.viewControllers.count)")
    }

    func test_start_createsPhotoDetailViewController() {
        let navigationController = UINavigationController()
        let selectedPhoto = PhotoListItem(id: "1", title: "some title", thumbnailImageURL: nil, fullImageURL: nil)
        let sut = PhotoDetailCoordinator(navigationController: navigationController, selectedPhoto: selectedPhoto)
        
        sut.start()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1,
                       "Expected to have 1 viewController in navigationController, but got \(navigationController.viewControllers.count)")
        XCTAssert(navigationController.viewControllers.first!.isKind(of: PhotoDetailViewController.self),
                  "Expected to have PhotoDetailViewController in hierarchy, but got \(navigationController.viewControllers.first!.self) instead")
    }
}
