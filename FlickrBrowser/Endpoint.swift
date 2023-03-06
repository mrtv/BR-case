//
//  Endpoint.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation

class Endpoint {
    let queryItems: [URLQueryItem]
    
    init(queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
    }

    func url(baseURLComponents: BaseURLComponents) -> URL? {
        var components = URLComponents()
        components.scheme = baseURLComponents.scheme
        components.host = baseURLComponents.host
        components.path = baseURLComponents.path
        components.queryItems = queryItems

        return components.url
    }
}
