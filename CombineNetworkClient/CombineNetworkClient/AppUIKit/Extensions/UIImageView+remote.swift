//
//  UIImageView+remove.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import UIKit
import Combine

extension UIImageView {
    fileprivate static var imageLoadingList: [AnyCancellable] = []
    public func loadRemoteImage(path: String) -> AnyPublisher<UIImage?, Never> {
        return ImageService.shared.loadImage(from: path)
            .tryMap{ data -> UIImage? in
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                return image
            }
            .catch { error in
                return Just(nil).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
