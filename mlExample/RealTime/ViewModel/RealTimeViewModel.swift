//
//  RealTimeViewModel.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 15/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import RxSwift
import Vision

class RealTimeViewModel {
    
    private let _classification = Variable<VNClassificationObservation?>(nil)
    
    private var model: VNCoreMLModel? = nil
    private var request: VNCoreMLRequest? = nil
    private var handler: VNImageRequestHandler? = nil
    
    init() {
        self.model = try? VNCoreMLModel(for: Inceptionv3().model)
        if let model = self.model{
            self.request = VNCoreMLRequest(model: model, completionHandler: {[weak self] (request, error) in
                self?.analize(request: request)
            })
        }
    }
    
    func imageClassification() -> Observable<(identifier: String, confidence: Double)> {
        return self._classification.asDriver()
            .filter{ $0 != nil}
            .map{ $0! }
            .map{
                return ($0.identifier, Double($0.confidence))
            }
            .asObservable()
    }
    
    func analize(frame: CVImageBuffer) {
        if let request = self.request {
            self.handler = VNImageRequestHandler(cvPixelBuffer: frame, options: [:])
            try? self.handler?.perform([request])
        }
    }
    
    private func analize(request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation]
            else { print("Classification error"); return }
        
        let sortClassification = results.sorted(by: { (lth, rth) -> Bool in
            return rth.confidence < lth.confidence
        })
        
        if let firstResult = sortClassification.first {
            self._classification.value = firstResult
        }
        
    }
    
}
