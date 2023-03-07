//
//  PhotoSearchViewModel.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation
import Combine

class PhotoSearchViewModel {
    enum Section { case photos }

    @Published private(set) var items: [PhotoListItem] = []
    private let searchPhotosUseCase: SearchPhotoUseCase
    private var cancellables: [AnyCancellable] = []
    private var coordinator: MainCoordinator
    
    init(searchPhotosUseCase: SearchPhotoUseCase,
         coordinator: MainCoordinator) {
        self.searchPhotosUseCase = searchPhotosUseCase
        self.coordinator = coordinator
    }
    
    func transform(search: AnyPublisher<String, Never>,
                   select: AnyPublisher<Int, Never>) -> AnyPublisher<[PhotoListItem], Never>{
        //search
        let output = search
            .receive(on: RunLoop.main)
            .map { text in
                self.searchPhotosUseCase.execute(searchString: text).replaceError(with: [])
            }.switchToLatest()
        
        output.sink { _ in }
            receiveValue: { [weak self] photoListItems in
                self?.items = photoListItems
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
    
//    func transform() -> AnyPublisher<Void, Never> {
//
//    }
}
