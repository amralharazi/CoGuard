//
//  ButtonExtension.swift
//  Mucize Doktorlar
//
//  Created by عمرو on 22.12.2022.
//

import UIKit

extension UIButton {
    func adjustLabelSize(){
        self.titleLabel?.minimumScaleFactor = 0.1
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
    }
}
