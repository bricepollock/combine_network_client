//
//  NetworkService.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//
// Inspired by: https://gist.github.com/zafarivaev/c9ffa6e47b302795fa3413fb5901b72e

import Foundation
import Combine

protocol NetworkServiceInterface: AnyObject {
    func get<T>(type: T.Type, url: URL, headers: [String: String]) -> AnyPublisher<T, Error> where T: Decodable
    func get<T>(type: T.Type, url: URL) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkService: NetworkServiceInterface {
    public  static let shared = NetworkService()
    
    private init() { }
    
    public func get<T: Decodable>(type: T.Type, url: URL) -> AnyPublisher<T, Error> {
        return get(type: type, url: url, headers: [:])
    }
    
    public func get<T: Decodable>(type: T.Type, url: URL, headers: [String: String] ) -> AnyPublisher<T, Error> {
        
        var urlRequest = URLRequest(url: url)
        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
