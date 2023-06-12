//
//  TabBarVC.swift
//  CoGuard
//
//  Created by عمرو on 29.05.2023.
//

import UIKit
import Lottie

class DashboardVC: UITabBarController {
    
    // MARK:  Properties
    var animationView = LottieAnimationView()
    var transparentView = UIView()

    // MARK:  Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimationView()
    }
    
    // MARK:  Helpers
    private func setupAnimationView(){
        animationView.animation = LottieAnimation.named(LoadingAnimation.virus)
        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        transparentView.frame = self.view.bounds
        transparentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    func showLoadingAnimation(){
        guard !view.subviews.contains(transparentView) else {return}
        animationView.play()
        view.addSubview(transparentView)
        view.addSubview(animationView)
    }
    
    func hideLoadingAnimation(){
        animationView.stop()
        animationView.removeFromSuperview()
        transparentView.removeFromSuperview()
    }
}
