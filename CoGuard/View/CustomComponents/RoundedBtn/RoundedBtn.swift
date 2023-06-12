//
//  RoundedBtn.swift
//  Planlama
//
//  Created by عمرو on 9.02.2023.
//

import Foundation

import UIKit

@IBDesignable
class RoundedBtn: UIButton {
    
    @IBInspectable public var isCircle: Bool = false
    @IBInspectable public var radius: Double = 10.0
        
    @IBInspectable var isBordered: Bool = false {didSet{setupBorder()}}
    @IBInspectable var borderColor: UIColor = .lightGray {didSet{setupBorder()}}
    @IBInspectable var borderWidth: CGFloat = 1 {didSet{setupBorder()}}

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = isCircle ? (frame.height/2.0) : radius
    }
    
    // MARK: Helpers
    private func setupButton(){
        titleLabel?.font = UIFont(name: AppFont.MontserratMedium, size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func setupBorder(){
        guard isBordered else {return}
        addBoder(with: borderColor, width: borderWidth)
    }
}
