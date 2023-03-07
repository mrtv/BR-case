//
//  PhotoListItem+FlickrPhoto.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation

extension PhotoListItem {
    init(photo: FlickrPhoto) {
        self.init(id: photo.id,
                  title: photo.title,
                  thumbnailImageURL: photo.getImageURL(for: .thumbnail),
                  fullImageURL: photo.getImageURL(for: .full))
    }
}
