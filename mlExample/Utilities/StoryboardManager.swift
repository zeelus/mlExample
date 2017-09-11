//
//  StoryboardManager.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 11.09.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import UIKit

struct StoryboardManager {
    
    static func getRecognizerImageViewController(viewModel: RecognizerImageViewModel) -> RecognizerImageViewController {
        let storyboard = UIStoryboard(name: "RecognizerImage", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! RecognizerImageViewController
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    static func getGetImage() -> UIViewController {
        return UIStoryboard(name: "GetImage", bundle: nil).instantiateInitialViewController()!
    }
}
