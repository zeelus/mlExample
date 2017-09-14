//
//  RecognizerImageViewModel.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 11.09.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import CoreML
import Vision
import RxSwift


class RecognizerImageViewModel {
    
    private let _bestClassification = Variable<VNClassificationObservation?>(nil)
    private let _classificationArray = Variable<[VNClassificationObservation]>([])
    private let _imageVariable = Variable<UIImage?>(nil)

    private var request: VNCoreMLRequest!
    private var handler: VNImageRequestHandler?
    
    private let disposeBag = DisposeBag()
    
    init(image: UIImage) {
        
        self.setupVision()
        self._imageVariable.value = image
        self.setupImageObserver()
        
    }
    
    func getImage() -> Observable<UIImage> {
        return self._imageVariable
            .asObservable()
            .filter { $0 != nil }
            .map{ $0! }
    }
    
    func getBestClassification() -> Observable<VNClassificationObservation> {
        return self._bestClassification.asObservable().filter{ $0 != nil }.map{ $0! }
    }
    
    func getClassificationArray() -> Observable<[VNClassificationObservation]> {
        return self._classificationArray.asObservable()
    }
    
    private func setupVision() {
        
        if let model  = try? VNCoreMLModel(for: Inceptionv3().model) {
            self.request = VNCoreMLRequest(model: model, completionHandler: {[weak self] (request, error) in
                guard let results = request.results as? [VNClassificationObservation]
                    else { print("Classification error \(error.debugDescription)"); return }

                let sortClassification = results.sorted(by: { (lth, rth) -> Bool in
                    return rth.confidence < lth.confidence
                })
                
                self?._bestClassification.value = sortClassification.first
                self?._classificationArray.value = sortClassification

            })
        }
        
    }
    
    private func setupImageObserver() {
        self._imageVariable.asObservable().subscribe(onNext: {[weak self] (image) in
            guard let `self` = self else { return }
            if let image = image, let ciImage = CIImage(image: image){
                self.handler = VNImageRequestHandler(ciImage: ciImage)
                try? self.handler?.perform([self.request])
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(self.disposeBag)
    }

    
}
