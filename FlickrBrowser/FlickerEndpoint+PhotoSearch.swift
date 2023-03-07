//
//  FlickerEndpoint+PhotoSearch.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 5.03.2023.
//

import Foundation

extension FlickrEndpoint {
    static func search(query: String, pageSize: Int = 25, page: Int = 0) -> FlickrEndpoint {
        return FlickrEndpoint(
            method: "flickr.photos.search",
            queryItems: [
                URLQueryItem(name: "text", value: query),
                URLQueryItem(name: "per_page", value: "\(pageSize)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }
}
