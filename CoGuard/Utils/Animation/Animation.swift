//
//  Animation.swift
//  CoGuard
//
//  Created by عمرو on 26.05.2023.
//

import UIKit

struct Animation {
    
    static func transform(from fromValue: CGFloat = 1.0, to toValue: CGFloat) -> CABasicAnimation {
        let transformAnimation       = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(fromValue, fromValue, fromValue))
        transformAnimation.toValue   = NSValue(caTransform3D: CATransform3DMakeScale(toValue, toValue, toValue))
        
        return transformAnimation
    }
    static func hide() -> CABasicAnimation {
        let hideAnimation = transform(to: 0)
        return hideAnimation
    }
}
