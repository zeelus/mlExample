//
//  CVImageBuffer+UIImage.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 14/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

extension CVImageBuffer {
    
    func uiImage() -> UIImage? {
        let ciImage = CIImage(cvImageBuffer: self)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
            return nil
    }
    
}
