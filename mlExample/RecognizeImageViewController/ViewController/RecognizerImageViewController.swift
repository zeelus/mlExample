//
//  RecognizerImageViewController.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 11.09.2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RecognizerImageViewController: UIViewController {

    var viewModel: RecognizerImageViewModel!
    
    
    @IBOutlet weak var clasificationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupObservable()
    }
    
    func setupObservable() {
        
        self.viewModel.getBestClassification()
            .map { "\($0.identifier)"}
            .bind(to: self.clasificationLabel.rx.text)
            .addDisposableTo(self.disposeBag)
        
        self.viewModel.getImage()
            .bind(to: self.imageView.rx.image)
            .addDisposableTo(self.disposeBag)
        
    }

}
