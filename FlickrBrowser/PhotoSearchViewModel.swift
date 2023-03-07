//
//  PhotoSearchViewModel.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation
import Combine

class SearchResult {
    var searchText = ""
    var currentPage = 0
    var pageSize = 25
    var hasMore = false
}

class PhotoSearchViewModel {
    enum Section { case photos }

    @Published private(set) var items: [PhotoListItem] = []

    private let searchPhotosUseCase: SearchPhotoUseCase
    private var cancellables: [AnyCancellable] = []
    private var coordinator: MainCoordinator
    private var searchResult: SearchResult
    
    init(searchPhotosUseCase: SearchPhotoUseCase,
         coordinator: MainCoordinator) {
        self.searchPhotosUseCase = searchPhotosUseCase
        self.coordinator = coordinator
        self.searchResult = SearchResult()
    }
    
    func transform(search: AnyPublisher<(String, Int), Never>,
                   select: AnyPublisher<Int, Never>,
                   loadMore: AnyPublisher<(String, Int), Never>) -> AnyPublisher<[PhotoListItem], Never> {
        //search
        let output = Publishers.Merge(search, loadMore.filter({ text, index in
            let shouldLoad = index + self.searchResult.pageSize/2 > (self.searchResult.currentPage + 1) * self.searchResult.pageSize
            if shouldLoad {
                self.searchResult.currentPage += 1
            }
            return shouldLoad
        }))
            .receive(on: RunLoop.main)
            .map { text, index in
                if text != self.searchResult.searchText {
                    self.searchResult = SearchResult()
                    self.searchResult.currentPage = 0
                    self.items.removeAll()
                }
                
                self.searchResult.searchText = text
                return self.searchPhotosUseCase.execute(searchString: text, page: self.searchResult.currentPage, pageSize: self.searchResult.pageSize).replaceError(with: [])
            }.switchToLatest()

        
        output.sink { _ in }
            receiveValue: { [weak self] photoListItems in
                guard let self = self else { return }
                self.items += photoListItems
            }.store(in: &cancellables)

        //select
        select.sink { [weak self] selectedIndex in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.coordinator.showDetail(selectedPhoto: self.items[selectedIndex])
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
