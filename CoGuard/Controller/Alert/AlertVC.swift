//
//  AlertVC.swift
//  CoGuard
//
//  Created by عمرو on 4.06.2023.
//

import UIKit

protocol AlertVCDelegate {
    func alertBtnPressed(_: Int)
}

enum AlertBtn: Int {
    case yesBtn
    case noBtn
}

class AlertVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var photoIV: RoundedIV!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var yesBtn: RoundedBtn!
    @IBOutlet weak var noBtn: RoundedBtn!
    
    // MARK: Properties
    var delegate: AlertVCDelegate?
    var alertSubtitle: String?
    var isDangerous = false
    var alertTitle: String?
    var hasMultipleOptions = true
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureAlertView()
        addGestureRecognizer()
        
        if isDangerous {switchBtnColors()}
        if !hasMultipleOptions{
            noBtn.isHidden = true
            yesBtn.setTitle("Ok", for: .normal)
        }
    }
    
    private func switchBtnColors(){
        let clr = yesBtn.backgroundColor
        yesBtn.backgroundColor = noBtn.backgroundColor
        noBtn.backgroundColor = clr
    }
    
    private func configureAlertView(){
        titleLbl.text = alertTitle
        subtitleLbl.text = alertSubtitle
    }
    
    private func addGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.isUserInteractionEnabled = true
    }
    
    // MARK: Actions
    @IBAction func btnPressed(_ sender: UIButton) {
        delegate?.alertBtnPressed(sender.tag)
        dismiss(animated: true)
    }
    
    // MARK: Selectors
    @objc func handleTapOnView(){
        dismiss(animated: true)
        delegate?.alertBtnPressed(1)
    }
}
