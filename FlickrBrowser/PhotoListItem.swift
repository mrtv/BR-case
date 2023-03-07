//
//  PhotoListItem.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import Foundation

struct PhotoListItem: Hashable {
    let uuid = UUID() // Workaround for duplicate items on FlickrAPI pagination
    let id: String
    let title: String
    let thumbnailImageURL: URL?
    let fullImageURL: URL?
}
