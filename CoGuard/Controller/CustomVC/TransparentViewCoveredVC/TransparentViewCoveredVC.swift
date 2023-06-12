//
//  TransparentViewCoveredVC.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import UIKit

class TransparentViewCoveredVC: UIViewController {

    // MARK: Subviews
    private var transparentView = UIView()
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }

    // MARK: Helpers
    private func configureSubviews(){
        configureTransparentView()
    }
    
    private func configureTransparentView(){
        transparentView = UIView(frame: view.bounds)
        transparentView.backgroundColor = .black.withAlphaComponent(0.6)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(transparentView)
        transparentView.alpha = 0
    }
    
     func hideTransparentView(){
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 0
        }
    }
    
     func showTransparentView(){
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 1
        }
    }
    
    func showAlertScreen(title: String, subtitle: String, isDangerous: Bool = false, hasMultipleOptions: Bool = true){
       let storyboard = UIStoryboard(name: Storyboard.Alert, bundle: nil)
       if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.AlertVC) as? AlertVC {
           viewController.alertTitle = title
           viewController.alertSubtitle = subtitle
           viewController.delegate = self
           viewController.isDangerous = isDangerous
           viewController.hasMultipleOptions = hasMultipleOptions
           viewController.modalPresentationStyle = .overFullScreen
           present(viewController, animated: true)
            showTransparentView()
       }
   }
}

// MARK: AlertVCDelegate
extension TransparentViewCoveredVC: AlertVCDelegate {
    @objc func alertBtnPressed(_ btn: AlertBtn.RawValue) {hideTransparentView()}
}
