//
//  UIViewEx.swift
//  Mucize Doktorlar
//
//  Created by عمرو on 29.11.2022.
//

import UIKit

extension UIView {    
    func addBoder(with color: UIColor = .lightGray, cornerRadius: CGFloat = DrawingConstants.radiusTen, width: CGFloat = 1){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        (self as? UITextField)?.addPadding()
    }
}
