//
//  StackView+removeAll.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import Foundation
import UIKit

extension UIStackView {
    public func removeAll() {
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
