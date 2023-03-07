//
//  PhotoListItem+FlickrPhoto.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation

extension PhotoListItem {
    convenience init(photo: FlickrPhoto) {
        self.init(id: $0.id,
                  title: $0.title,
                  thumbnailImageURL: $0.getImageURL(for: .thumbnail),
                  fullImageURL: $0.getImageURL(for: .full))
    }
}
