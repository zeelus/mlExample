//
//  GetImageViewController.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 11/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit

class GetImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getCameraImage(_ sender: Any) {
        self.showImagePicher(with: .camera)
    }
    
    @IBAction func getRollImage(_ sender: Any) {
        self.showImagePicher(with: .photoLibrary)
    }
    
    @IBAction func getRealTime(_ sender: Any) {
        let vc  = StoryboardManager.getRealTime()
        self.show(vc, sender: self)
    }
    
    private func showImagePicher(with type:  UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.isEditing = false
        picker.delegate = self
        self.show(picker, sender: self)
    }
}

extension GetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let catchedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let viewModel = RecognizerImageViewModel(image: catchedImage)
            let viewController = StoryboardManager.getRecognizerImageViewController(viewModel: viewModel)
            self.navigationController?.show(viewController, sender: self)
        }
        
        picker.dismiss(animated: false, completion: nil)
    }
}
