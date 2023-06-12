//
//  BarChart.swift
//  BarChart
//
//  Created by Amr AlHarazi on 7.08.2021.
//

import UIKit
import Foundation

class BarChart: UIView {
    var dataPoints: [DataPoint] = []
    
    func setup(data: [DataPoint], total: Float) {
        layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        dataPoints = data
        plot(dataPoints: data, total: total)
    }
    
    private func plot(dataPoints: [DataPoint], total: Float) {
        let values = dataPoints.map { $0.value }
        let space = bounds.width * 0.05
        let allSpace = CGFloat(values.count - 1) * space
        let lineWidth = (bounds.width - allSpace) / CGFloat(values.count)
        for (outerIndex, value) in values.enumerated() {
            
            guard let max = values.max() else { return }
            let percent = 100 / CGFloat(max / value)
            
            let lineHeight = bounds.height * 0.75 * ((percent > 0 ? percent : 2) / 100)
            
            let traveled = lineWidth * CGFloat(outerIndex) + space * CGFloat(outerIndex)
            
            let startPathRect = CGRect(x: traveled, y: bounds.height*0.75, width: lineWidth, height: 0)
            let startPath = UIBezierPath(roundedRect: startPathRect, cornerRadius: 2)
            
            let endPathRect = CGRect(x: traveled, y: bounds.height*0.75 - lineHeight, width: lineWidth, height: lineHeight)
            let endPath = UIBezierPath(roundedRect: endPathRect, cornerRadius: 2)
            
          
            let lineLayer = CAShapeLayer()
            lineLayer.path = startPath.cgPath
            lineLayer.fillColor = dataPoints[outerIndex].color.cgColor
            layer.addSublayer(lineLayer)
            lineLayer.animatePath(endPath: endPath.cgPath, duration: 0.7)
            
            lineLayer.shadowRadius = 5
            lineLayer.shadowOpacity = 0.2
            lineLayer.shadowOffset = .zero
            lineLayer.shouldRasterize = true
            lineLayer.shadowColor = UIColor.black.cgColor
            lineLayer.rasterizationScale = window?.screen.scale ?? 1.0
            
            let percentageTextLayer = CATextLayer()
            percentageTextLayer.fontSize = 12
            percentageTextLayer.truncationMode = .none
            percentageTextLayer.alignmentMode = .center
            percentageTextLayer.contentsScale = window?.screen.scale ?? 1.0
            percentageTextLayer.font = UIFont(name: AppFont.MontserratSemiBold, size: 12)
            percentageTextLayer.frame = CGRect(x: traveled+lineWidth*0.1, y: bounds.height*0.65, width: lineWidth*0.8, height: lineWidth*0.8)
            percentageTextLayer.string = "\(String(format: "%.1f", (dataPoints[outerIndex].value/total)*100.0))%"
            layer.addSublayer(percentageTextLayer)
            
            let label = UILabel()
            label.numberOfLines = 2
            label.minimumScaleFactor = 0.5
            label.textAlignment = .center
            label.lineBreakMode = .byClipping
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name: AppFont.MontserratMedium, size: 10)
            label.frame = CGRect(x: traveled, y:  bounds.height * 0.75, width: lineWidth, height: bounds.height * 0.2)
            label.text = dataPoints[outerIndex].label as? String
            self.addSubview(label)
        }
    }
}

extension BarChart {
    
    struct DataPoint: Equatable {
        var label: Any?
        var value: Float
        var color: UIColor = .blue
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.value == rhs.value
        }
    }
}
