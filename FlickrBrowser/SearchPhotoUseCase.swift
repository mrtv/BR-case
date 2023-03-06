//
//  SearchPhotoUseCase.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation
import Combine

protocol SearchPhotoUseCase {
    func execute(searchString: String) -> AnyPublisher<[PhotoListItem], Error>
}

class DefaultSearchPhotoUseCase: SearchPhotoUseCase {
    let client: RemoteClient

    internal init(client: RemoteClient) {
        self.client = client
    }
    
    func execute(searchString: String) -> AnyPublisher<[PhotoListItem], Error> {
        let endpoint = FlickrEndpoint.search(query: searchString)
        let result: AnyPublisher<FlickrSearchPhotosResponse, Swift.Error> = client.request(endpoint)
        return result.map { response in
            response.photos.map {
                PhotoListItem(id: $0.id, title: $0.title)
            }
        }.eraseToAnyPublisher()
    }
}
