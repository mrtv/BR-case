//
//  FlickrSearchPhotosResponse.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 5.03.2023.
//

import Foundation

class FlickrSearchPhotosResponse: Decodable {
    let photos: [FlickrPhoto]
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let stat: String
    
    enum FlickrPhotoCodingKeys: String, CodingKey {
        case photos = "photo"
        case page
        case pages
        case perPage = "perpage"
        case total
        case stat
    }
    
    enum FlickrPhotoResponseContainerKeys: String, CodingKey {
        case photos
        case stat
    }
    
    required init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: FlickrPhotoResponseContainerKeys.self)
        let p = try root.nestedContainer(keyedBy: FlickrPhotoCodingKeys.self, forKey: .photos)
        
        self.photos = try p.decode([FlickrPhoto].self, forKey: .photos)
        self.page = try p.decode(Int.self, forKey: .page)
        self.pages = try p.decode(Int.self, forKey: .pages)
        self.perPage = try p.decode(Int.self, forKey: .perPage)
        self.total = try p.decode(Int.self, forKey: .total)
        self.stat = try root.decode(String.self, forKey: .stat)
    }
}
