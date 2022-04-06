//
//  DogService.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import Combine

struct DogService {    
    private let network: NetworkService
    
    init(network: NetworkService = NetworkService.shared) {
        self.network = network
    }
    
    public func getDogs(number: Int) -> AnyPublisher<[String], Error> {
        let publishers = Array(repeating: 0, count: number).map {_ in
            return getRandomDog()
        }
        
        return Publishers.ZipMany(publishers).eraseToAnyPublisher()
    }
    
    private func getRandomDog() -> AnyPublisher<String, Error> {
        let path = "https://dog.ceo/api/breeds/image/random"
        guard let url = URL(string: path) else {
            return Fail(outputType: String.self, failure: URLError(.badURL)).eraseToAnyPublisher()
        }
        return network.get(type: DogResponse.self, url: url)
            .map(\.message)
            .eraseToAnyPublisher()
    }
}
