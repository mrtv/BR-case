//
//  RemoteClient.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 4.03.2023.
//

import Foundation
import Combine

public class RemoteClient {
    let baseURL: URL
    let session: URLSession
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Swift.Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                let value = try decoder.decode(T.self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
