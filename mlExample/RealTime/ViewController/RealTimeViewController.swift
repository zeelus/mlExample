//
//  RealTimeViewController.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 14/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class RealTimeViewController: UIViewController {

    let camera = CameraCapture()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.camera.delegate = self
    }

}

extension RealTimeViewController: CameraCaptureDelegate {
    
    func capture(frame: CVImageBuffer) {
        
        if let uiImage = frame.uiImage() {
            self.showFrame(image: uiImage)
        }
        
    }
    
    func showFrame(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = nil
            self.imageView.image = image
        }
    }

}

