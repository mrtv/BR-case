//
//  RemoteClient.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 4.03.2023.
//

import Foundation
import Combine

public class RemoteClient {
    let baseURLComponents: BaseURLComponents
    let session: URLSession
    
    init(baseURLComponents: BaseURLComponents, session: URLSession = .shared) {
        self.baseURLComponents = baseURLComponents
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Swift.Error> {
        let urlRequest = URLRequest(url: endpoint.url(baseURLComponents: baseURLComponents)!)
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { result -> T in
                let value = try decoder.decode(T.self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
