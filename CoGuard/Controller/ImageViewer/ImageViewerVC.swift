//
//  ImageViewerVC.swift
//  CoGuard
//
//  Created by عمرو on 10.06.2023.
//

import UIKit

class ImageViewerVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var photoIV: UIImageView!
    
    // MARK: Properties
    var url: URL?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        if let url = url {setImage(with: url)}
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer(){
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage))
        photoIV.addGestureRecognizer(gestureRecognizer)
        photoIV.isUserInteractionEnabled = true
    }
    
    private func setImage(with url: URL){
        showLottieAnimation()
        photoIV.sd_setImage(with: url) {[weak self] _, _, _, _ in
            guard let self = self else {return}
            self.hideLottieAnimation()
        }
    }
    
    // MARK: Selectors
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer){
        sender.view?.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
}
