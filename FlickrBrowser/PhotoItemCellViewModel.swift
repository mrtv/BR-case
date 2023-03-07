//
//  PhotoItemCellViewModel.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import Foundation

class PhotoItemCellViewModel {
    @Published var title: String = ""
    @Published var imageURL: URL?
        
    private let item: PhotoListItem
    
    init(item: PhotoListItem) {
        self.item = item
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        title = item.title
        imageURL = item.thumbnailImageURL
    }
}
