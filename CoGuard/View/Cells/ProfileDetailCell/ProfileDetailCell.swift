//
//  ProfileDetailCell.swift
//  CoGuard
//
//  Created by عمرو on 20.05.2023.
//

import UIKit

protocol ProfileDetailCellDelegate {
    func set(value: Any, forDetailWith id: Int)
}

class ProfileDetailCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: RoundedTextField!
    
    // MARK: Properties
    private var options = [String]()
    private var datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    var delegate: ProfileDetailCellDelegate?
    var detail: UserDetailModel? {didSet{configureCell()}}
    
    // MARK: Init
    override func prepareForReuse() {
        super.prepareForReuse()
        resetConfigs()
    }
    
    // MARK: Helpers
    private func configureCell(){
        guard let detail = detail else {return}
        titleLbl.text = detail.userDetail.title
        options = detail.userDetail.options ?? []
        textField.text = detail.value as? String
        
        switch detail.userDetail.dataType {
        case .text:
            configureTextFieldInputText()
        case .date:
            configureTextFieldDatePicker()
        case .picker:
            configureTextFieldPickerView()
        case .email:
            configureTextFieldEmailEntry()
        case .phone:
            configureTextFieldPhoneEntry()
        default:
            return
        }
    }
    
    private func configureTextFieldInputText(){
        textField.keyboardType = .default
        textField.tintColor = self.tintColor
        textField.inputView = nil
    }
    
    func configureTextFieldPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        textField.tintColor = .clear
    }
    
    private func configureTextFieldDatePicker(){
        textField.tintColor = .clear
        textField.inputView = datePicker
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    private func configureTextFieldEmailEntry(){
        textField.keyboardType = .emailAddress
        textField.tintColor = self.tintColor
        textField.inputView = nil
    }
    
    private func configureTextFieldPhoneEntry(){
        textField.keyboardType = .phonePad
        textField.tintColor = self.tintColor
        textField.inputView = nil
        textField.delegate = self
    }
    
    private func resetConfigs(){
        textField.keyboardType = .default
        textField.tintColor = self.tintColor
        textField.inputView = nil
        textField.isSecureTextEntry = false
        textField.text = ""
    }
    
    // MARK: Actions
    @IBAction func textChanged(_ sender: UITextField) {
        guard let id = detail?.id else {return}
        delegate?.set(value: sender.text ?? "", forDetailWith: id)
    }
    
    // MARK: Selectors
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format.dateFormat
        dateFormatter.string(from: sender.date)
        let date = dateFormatter.string(from: sender.date)
        textField?.text = date
        guard let id = detail?.id else {return}
        delegate?.set(value: date, forDetailWith: id)
    }
    
}

// MARK: UITextFieldDelegate
extension ProfileDetailCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.keyboardType == .phonePad,
              let text = textField.text else {return true}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.applyPatternOnNumbers(with: Format.phoneFormat, phone: newString)
        if let id = detail?.id {
            delegate?.set(value: textField.text ?? "", forDetailWith: id)
        }
        return false
    }
}

// MARK:  PickerViewDelegate
extension ProfileDetailCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if textField.isFirstResponder {
            return options.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if textField.isFirstResponder {
            if let option = textField.text, option.isEmpty {
                textField.text = options[0]
                guard let id = detail?.id else {return nil}
                delegate?.set(value: options[0], forDetailWith: id)
            }
            return options[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textField.isFirstResponder {
            textField.text = options[row]
            guard let id = detail?.id else {return}
            delegate?.set(value: options[row], forDetailWith: id)
        }
    }
}

