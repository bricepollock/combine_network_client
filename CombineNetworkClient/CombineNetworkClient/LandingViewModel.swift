//
//  LandingViewModel.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import Combine

struct LandingViewModel {
    private static let numDogs = 10
    
    private let service = DogService()
    
    func dogs() -> AnyPublisher<[String], Error> {
        return service.getDogs(number: Self.numDogs)
            .receive(on: DispatchQueue.main) // Ensure the UI gets all its data on main thread
            .eraseToAnyPublisher()
    }
}
