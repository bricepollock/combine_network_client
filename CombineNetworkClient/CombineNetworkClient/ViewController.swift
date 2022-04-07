//
//  ViewController.swift
//  CombineNetworkClient
//
//  Created by Brice Pollock on 4/6/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private static let imageHeight: CGFloat = 400
    
    private let viewModel = LandingViewModel()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private var loadCancellable: Cancellable?
    private var imageCancellables: [Cancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.constrain.fillSuperview()
        
        self.scrollView.addSubview(self.contentStack)
        self.contentStack.constrain.fillSuperview()
        self.contentStack.constrain.width(to: self.scrollView)
        
        self.contentStack.axis = .vertical
        self.scrollView.backgroundColor = .yellow
        self.contentStack.backgroundColor = .red
        self.view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadCancellable = self.viewModel.dogs().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                Global.logger.error(error)
            case .finished: return
            }
        }, receiveValue: { pathList in
            self.contentStack.removeAll()
            pathList.forEach { path in
                let imageView = UIImageView(image: UIImage(named: "ic_dog_loading"))
                imageView.constrain.height(Self.imageHeight)
                self.contentStack.addArrangedSubview(imageView)
                let cancelable = imageView.loadRemoteImage(path: path).sink { image in
                    guard let image = image else {
                        imageView.image = UIImage(named: "ic_photo_broken")
                        return
                    }
                    imageView.image = image
                }
                self.imageCancellables.append(cancelable)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadCancellable?.cancel()
        self.imageCancellables.forEach { $0.cancel() }
    }
}

