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
        }, receiveValue: { [weak self] pathList in
            guard let self = self else { return }
            
            // clean up existing dog cancelables
            self.imageCancellables.removeAll()
            
            // add image views for each dog image url
            self.contentStack.removeAll()
            pathList.forEach { path in
                let imageView = UIImageView(image: UIImage(named: "ic_dog_loading"))
                imageView.constrain.height(Self.imageHeight)
                self.contentStack.addArrangedSubview(imageView)
                let cancelable = imageView.loadRemoteImage(path: path).sink { [weak imageView] image in
                    guard let imageView = imageView else { return }
                    guard let image = image else {
                        imageView.image = UIImage(named: "ic_photo_broken")
                        return
                    }
                    imageView.image = image
                }
                
                // keep request alive by stashing the cancelable
                self.imageCancellables.append(cancelable)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadCancellable = nil
        self.imageCancellables.removeAll()
    }
}

