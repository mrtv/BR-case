//
//  FlickrEndPoint.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 5.03.2023.
//

import Foundation

class FlickrEndpoint: Endpoint {
    let apiKey: String
    let format: String
    let noJSONCallback: String
    let method: String
    
    convenience init(method: String, queryItems: [URLQueryItem]) {
        self.init(queryItems: queryItems,
                  apiKey: "1508443e49213ff84d566777dc211f2a",
                  format: "json",
                  noJSONCallback: "1",
                  method: method)
    }
    
    internal init(queryItems: [URLQueryItem] = [],
                  apiKey: String,
                  format: String,
                  noJSONCallback: String,
                  method: String) {
        self.apiKey = apiKey
        self.format = format
        self.noJSONCallback = noJSONCallback
        self.method = method
        
        super.init(queryItems: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "nojsoncallback", value: noJSONCallback),
            URLQueryItem(name: "method", value: method)
        ] + queryItems
        )
    }
}
