//
//  RoundedTextField.swift
//  Etikit
//
//  Created by عمرو on 25.01.2023.
//
import UIKit

@IBDesignable
class RoundedTextField: UITextField {
    
    @IBInspectable var rightImage: UIImage? = nil {didSet{setRightImage()}}
    @IBInspectable var leftImage: UIImage? = nil {didSet{setLeftImage()}}
    @IBInspectable var radius: CGFloat = 10 {didSet{setRadius()}}
    
    @IBInspectable var isBordered: Bool = false {didSet{setupBorder()}}
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var borderWidth: CGFloat = 1
    
    @IBInspectable var placeholderColor: UIColor = .white {didSet{setPlaceHolderColor(placeholderColor)}}
    override var placeholder: String? {didSet{setPlaceHolderColor(.white)}}
    
    // MARK:  Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK:  Helpers
    func setup() {
        borderStyle = .none
        font = UIFont(name: AppFont.MontserratRegular, size: 14)
        autocorrectionType = .no
        minimumFontSize = 10
        spellCheckingType = .no
        clipsToBounds = false
        addPadding()
    }
    
    func setLeftImage(){
        if let image = leftImage {
            addImageToTheLeft(image)
        }
    }
    
    func setRightImage(){
        if let image = rightImage {
            addImageToTheRight(image)
        }
    }
    
    func setRadius(){
        layer.cornerRadius = radius
    }
    
    private func setupBorder(){
        guard isBordered else {return}
        addBoder(with: borderColor, width: borderWidth)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(replace(_:withText:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) { return false }
        return super.canPerformAction(action, withSender: sender)
    }
}
