//
//  SegmentedControlExtension.swift
//  Mucize Doktorlar
//
//  Created by عمرو on 22.12.2022.
//

import UIKit

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont(name: AppFont.MontserratBold, size: 14) ?? UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.white) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ] as! [NSAttributedString.Key : Any]
        setTitleTextAttributes(defaultAttributes, for: .normal)
        
    }
    
    func selectedConfiguration(font: UIFont = UIFont(name: AppFont.MontserratBold, size: 14) ?? UIFont.systemFont(ofSize: 14), color: UIColor = UIColor.darkGreen) {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ] as! [NSAttributedString.Key : Any]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
