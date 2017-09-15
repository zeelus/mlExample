//
//  RealTimeViewController.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 14/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RealTimeViewController: UIViewController {

    let viewModel = RealTimeViewModel()
    
    let camera = CameraCapture()
    var timer: Observable<Int>?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    fileprivate var _analize = false
    let queue = DispatchQueue(label: "imageAnalize")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.camera.delegate = self
        self.setupObservable()
        self.nameLabel.text = nil
    }
    
    private func setupObservable() {
        self.viewModel.imageClassification()
            .map { "\($0.identifier) \(String(format: "%.2f", $0.confidence))" }
            .bind(to: self.nameLabel.rx.text)
            .addDisposableTo(self.disposeBag)
        
        self.timer = Observable<Int>.interval(1, scheduler: SerialDispatchQueueScheduler(queue: self.queue, internalSerialQueueName: "imageAnalize"))
        self.timer?.subscribe(onNext: { [weak self] (_) in
            self?._analize = true
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.camera.stop()
        self.camera.delegate = nil
    }
    
}

extension RealTimeViewController: CameraCaptureDelegate {
    
    func capture(frame: CVImageBuffer) {
        
        if let uiImage = frame.uiImage() {
            self.showFrame(image: uiImage)
        }
        
        
        self.queue.sync {
            if self._analize {
                self._analize = false
                self.viewModel.analize(frame: frame)
            }
        }
        
    }
    
    func showFrame(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = nil
            self.imageView.image = image
        }
    }

}



