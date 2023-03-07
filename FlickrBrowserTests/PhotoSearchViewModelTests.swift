//
//  PhotoSearchViewModelTests.swift
//  FlickrBrowserTests
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import XCTest
import Combine
@testable import FlickrBrowser

class SearchPhotoUseCaseStub: SearchPhotoUseCase {
    var mockedItems: [PhotoListItem] = []
    
    func execute(searchString: String, page: Int, pageSize: Int) -> AnyPublisher<[FlickrBrowser.PhotoListItem], Error> {
        return CurrentValueSubject(mockedItems).eraseToAnyPublisher()
    }
}

final class PhotoSearchViewModelTests: XCTestCase {

    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<(String, Int), Never>()
    private let loadMore = PassthroughSubject<(String, Int), Never>()
    private var cancellables: [AnyCancellable] = []
    
    func test_search_deliversEmptyListOnEmptyResponse() {
        //Given
        let exp = expectation(description: "Wait for event")
        let useCase = SearchPhotoUseCaseStub()
        useCase.mockedItems = []
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        let sut = PhotoSearchViewModel(searchPhotosUseCase: useCase, coordinator: coordinator)
        let output = sut.transform(search: search.eraseToAnyPublisher(),
                          select: selection.eraseToAnyPublisher(),
                          loadMore: loadMore.eraseToAnyPublisher())
        
        output.sink { _ in
            exp.fulfill()
        }.store(in: &cancellables)
        
        //When
        search.send(("", 0))
        
        wait(for: [exp], timeout: 1.0)
        
        //Then
        XCTAssertEqual(sut.items.count, 0, "Expected to receive no items but got \(sut.items.count) items instead.")
    }

    func test_search_deliversItemsOnNonEmptyResponse() {
        //Given
        let exp = expectation(description: "Wait for event")
        let items = [PhotoListItem(id: "1", title: "t1", thumbnailImageURL: nil, fullImageURL: nil),
                     PhotoListItem(id: "2", title: "t2", thumbnailImageURL: nil, fullImageURL: nil)]
        let useCase = SearchPhotoUseCaseStub()
        useCase.mockedItems = items
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        let sut = PhotoSearchViewModel(searchPhotosUseCase: useCase, coordinator: coordinator)
        let output = sut.transform(search: search.eraseToAnyPublisher(),
                          select: selection.eraseToAnyPublisher(),
                          loadMore: loadMore.eraseToAnyPublisher())
        
        //When
        output.sink { _ in
            exp.fulfill()
        }.store(in: &cancellables)
        
        search.send(("", 0))
        
        wait(for: [exp], timeout: 1.0)
        
        //Then
        XCTAssertEqual(sut.items.count, items.count, "Expected to receive \(items.count) items but got \(sut.items.count) items instead.")
    }
    
    func test_search_deliversSameItemsOnNonEmptyResponseWithDifferentSearchText() {
        //Given
        let exp = expectation(description: "Wait for event")
        let items = [PhotoListItem(id: "1", title: "t1", thumbnailImageURL: nil, fullImageURL: nil),
                     PhotoListItem(id: "2", title: "t2", thumbnailImageURL: nil, fullImageURL: nil)]
        let useCase = SearchPhotoUseCaseStub()
        useCase.mockedItems = items
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        let sut = PhotoSearchViewModel(searchPhotosUseCase: useCase, coordinator: coordinator)
        let output = sut.transform(search: search.eraseToAnyPublisher(),
                          select: selection.eraseToAnyPublisher(),
                          loadMore: loadMore.eraseToAnyPublisher())
        var firstItemCount = 0
        var secondItemCount = 0
        var callCount = 0
        
        //When
        output.sink { [weak self] _ in
            callCount += 1
            if callCount == 1 {
                firstItemCount = sut.items.count
                self?.search.send(("2", 0))
            } else if callCount == 2 {
                secondItemCount = sut.items.count
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        search.send(("1", 0))
        
        wait(for: [exp], timeout: 1.0)
        
        //Then
        XCTAssertEqual(firstItemCount, secondItemCount, "Expected to receive same items, but got different number of items instead.")
    }
    
    func test_search_deliversAppendedItemsOnNonEmptyResponseWithSameSearchText() {
        //Given
        let exp = expectation(description: "Wait for event")
        let items = [PhotoListItem(id: "1", title: "t1", thumbnailImageURL: nil, fullImageURL: nil),
                     PhotoListItem(id: "2", title: "t2", thumbnailImageURL: nil, fullImageURL: nil)]
        let useCase = SearchPhotoUseCaseStub()
        useCase.mockedItems = items
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        let sut = PhotoSearchViewModel(searchPhotosUseCase: useCase, coordinator: coordinator)
        let output = sut.transform(search: search.eraseToAnyPublisher(),
                          select: selection.eraseToAnyPublisher(),
                          loadMore: loadMore.eraseToAnyPublisher())
        var firstItemCount = 0
        var secondItemCount = 0
        var callCount = 0
        
        //When
        output.sink { [weak self] _ in
            callCount += 1
            if callCount == 1 {
                firstItemCount = sut.items.count
                self?.search.send(("1", 0))

            } else if callCount == 2 {
                secondItemCount = sut.items.count
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        search.send(("1", 0))

        wait(for: [exp], timeout: 1.0)
        
        //Then
        XCTAssertEqual(firstItemCount*2, secondItemCount, "Expected to receive same items, but got different number of items instead.")
    }
}
