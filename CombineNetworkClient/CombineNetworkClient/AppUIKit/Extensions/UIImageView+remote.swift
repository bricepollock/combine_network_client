//
//  UIImageView+remove.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import UIKit

extension UIImageView {
    public func loadRemoteImage(path: String) {
        // TODO: Implement image service / caching
        self.image = UIImage(named: "ic_photo_broken")
    }
}
