//
//  ImageService.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import Combine

class ImageService {
    public static let shared = ImageService()
    
    private let network: NetworkService
    
    private init(network: NetworkService = NetworkService.shared) {
        self.network = network
    }
    
    func loadImage(from path: String) -> AnyPublisher<Data, URLError> {
        guard let url = URL(string: path) else {
            return Fail(outputType: Data.self, failure: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
