//
//  ThermometerView.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

protocol ThermometerViewDelegate {
    func updateTemp(withValue value: Double)
}

class ThermometerView: UIView {
    
    let bodyLayer = CAShapeLayer()
    let levelLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    var delegate: ThermometerViewDelegate?
    
    var level: CGFloat = 0.5 {
        didSet {
            DispatchQueue.main.async {
                self.levelLayer.strokeEnd = self.level
            }
            self.delegate?.updateTemp(withValue: self.level)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        setupBodyLayer()
        setupLevelLayer()
        setupMaskLayer()
    }
    
    private func setupBodyLayer() {
        
        let lineWidth = bounds.width/3
        let width = bounds.width - lineWidth*1.5
        let height = bounds.height - lineWidth
        
        layer.addSublayer(bodyLayer)
        
        let bodyPath = UIBezierPath(ovalIn: CGRect(x: lineWidth/2, y: height - width, width: width, height: width))
        bodyPath.move(to: CGPoint(x: width/2 + lineWidth/2, y: height - width))
        bodyPath.addLine(to: CGPoint(x: width/2 + lineWidth/2, y: 36))
        bodyLayer.path = bodyPath.cgPath
        bodyLayer.strokeColor = UIColor.black.cgColor
        bodyLayer.fillColor = UIColor.white.cgColor
        bodyLayer.lineWidth = width/3
        bodyLayer.lineCap = .round
        
        bodyLayer.shadowColor = UIColor.black.cgColor
        bodyLayer.shadowOpacity = 0.2
        bodyLayer.shadowOffset = CGSize(width: 0, height: 3)
        bodyLayer.shadowRadius = 5
        bodyLayer.shouldRasterize = true
        bodyLayer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupLevelLayer() {
        
        layer.addSublayer(levelLayer)
        
        let levelPath = UIBezierPath()
        levelPath.move(to: CGPoint(x: bounds.midX, y: bounds.height))
        levelPath.addLine(to: CGPoint(x: bounds.midX, y: 30))
        levelLayer.path = levelPath.cgPath
        levelLayer.strokeColor = UIColor.red.cgColor
        levelLayer.lineWidth = bounds.width
        levelLayer.strokeEnd = level
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(pan)
    }
    
    private func setupMaskLayer() {
        maskLayer.path = bodyLayer.path
        maskLayer.strokeColor = bodyLayer.strokeColor
        maskLayer.lineWidth = bodyLayer.lineWidth - 4
        maskLayer.lineCap = bodyLayer.lineCap
        maskLayer.fillColor = nil
        levelLayer.mask = maskLayer
    }
    
    @objc private func didPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let percent = translation.y/bounds.height
        level = max(0, min(1, levelLayer.strokeEnd - percent))
        recognizer.setTranslation(.zero, in: self)
    }
}

