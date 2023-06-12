//
//  TextFieldExtension.swift
//
//
//  Created by عمرو on 13.04.2022.
//

import UIKit

extension UITextField{
    
    func setPlaceHolderColor(_ color: UIColor){
        guard let placeholder = self.placeholder else {return}
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func addPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addImageToTheRight(_ image: UIImage){
        self.clipsToBounds = true
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .clear
        imageView.contentMode = .scaleAspectFit
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height*0.8, height: self.frame.height*0.8))
        imageContainerView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.height*0.4, height: self.frame.height*0.4)
        imageView.center = imageContainerView.center
        imageContainerView.backgroundColor = self.backgroundColor
        self.rightViewMode = .always
        self.rightView = imageContainerView
    }
    
    
    func addImageToTheLeft(_ image: UIImage){
        self.clipsToBounds = true
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width*0.08, height: self.frame.width*0.08))
        imageContainerView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: imageContainerView.frame.width*0.8, height: imageContainerView.frame.width*0.8)
        imageView.center = imageContainerView.center
        imageContainerView.backgroundColor = self.backgroundColor
        self.leftViewMode = .always
        self.leftView = imageContainerView
    }
    
    func applyPatternOnNumbers(with pattern: String, phone: String) {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in pattern where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        text = result
    }
}
