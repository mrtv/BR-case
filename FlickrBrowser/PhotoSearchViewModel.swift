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

    init(searchPhotosUseCase: SearchPhotoUseCase) {
        self.searchPhotosUseCase = searchPhotosUseCase
    }
    
    func transform(search: AnyPublisher<String, Never>) -> AnyPublisher<[PhotoListItem], Never>{
        let output = search
            .receive(on: RunLoop.main)
            .map { text in
                self.searchPhotosUseCase.execute(searchString: text).replaceError(with: [])
            }.switchToLatest()
        
        output.sink { _ in }
            receiveValue: { [weak self] photoListItems in
                self?.items = photoListItems
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
