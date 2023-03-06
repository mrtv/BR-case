//
//  FlickrPhoto.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 5.03.2023.
//

import Foundation

class FlickrPhoto: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum FlickrPhotoCodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
    
    required init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: FlickrPhotoCodingKeys.self)
        
        self.id = try root.decode(String.self, forKey: .id)
        self.owner = try root.decode(String.self, forKey: .owner)
        self.secret = try root.decode(String.self, forKey: .secret)
        self.server = try root.decode(String.self, forKey: .server)
        self.farm = try root.decode(Int.self, forKey: .farm)
        self.title = try root.decode(String.self, forKey: .title)
        self.isPublic = try root.decode(Int.self, forKey: .isPublic)
        self.isFriend = try root.decode(Int.self, forKey: .isFriend)
        self.isFamily = try root.decode(Int.self, forKey: .isFamily)
    }
}
