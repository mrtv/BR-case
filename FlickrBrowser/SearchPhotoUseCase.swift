//
//  SearchPhotoUseCase.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation
import Combine

protocol SearchPhotoUseCase {
    func execute(searchString: String, page: Int, pageSize: Int) -> AnyPublisher<[PhotoListItem], Error>
}

class DefaultSearchPhotoUseCase: SearchPhotoUseCase {
    let client: RemoteClient

    internal init(client: RemoteClient) {
        self.client = client
    }
    
    func execute(searchString: String, page: Int = 0, pageSize: Int = 25) -> AnyPublisher<[PhotoListItem], Error> {
        let endpoint = FlickrEndpoint.search(query: searchString, pageSize: pageSize, page: page)
        let result: AnyPublisher<FlickrSearchPhotosResponse, Swift.Error> = client.request(endpoint)
        return result.map { response in
            response.photos.map {
                PhotoListItem(photo: $0)
            }
        }.eraseToAnyPublisher()
    }
}
