//
//  PhotoDetailViewModel.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation

class PhotoDetailViewModel {
    var coordinator: Coordinator?
    private var item: PhotoListItem

    init(coordinator: Coordinator, item: PhotoListItem) {
        self.item = item
    }
    
    public var title: String {
        get {
            return item.title
        }
    }
    
    public var imageURL: URL? {
        get {
            return item.fullImageURL
        }
    }
}
