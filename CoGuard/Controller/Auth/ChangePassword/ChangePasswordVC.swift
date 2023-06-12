//
//  ChangePasswordVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var currentPasswordTextField: RoundedTextField!
    @IBOutlet weak var newPasswordTextField: RoundedTextField!
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        hideKeyboardWhenTappedAround()
    }
    
    private func getEmail() -> String? {
        if let email = emailTextField.text,
           !email.isEmpty {
            
            if Validator.shared.isValidEmail(email) {
                return email
            } else {
                showPopup(message: AlertString.ErrorType.invalidEmail.rawValue)
            }
        } else {
            showPopup(message: AlertString.ErrorType.emptyEmail.rawValue)
        }
        return nil
    }
    
    private func getCurrentPassword() -> String? {
        if let password = currentPasswordTextField.text,
           !password.isEmpty {
            return password
        } else {
            showPopup(message: AlertString.ErrorType.emptyPassword.rawValue)
            return nil
        }
    }
    
    private func getNewPassword() -> String? {
        if let password = newPasswordTextField.text,
           !password.isEmpty {
            return password
        } else {
            showPopup(message: AlertString.ErrorType.emptyNewPassword.rawValue)
            return nil
        }
    }
    
    // MARK: Actions
    @IBAction func updateBtnPressed(_ sender: Any) {
        if let email = getEmail(),
           let password = getCurrentPassword(),
           let newPassword = getNewPassword(){
            change(password: password, for: email, to: newPassword)
        }
    }
    
    // MARK: Requests
    private func change(password: String, for email: String, to newPassword: String){
        showLottieAnimation()
        
        AuthService.shared.change(password: password, for: email, to: newPassword) {[weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            } else {
                showPopup(message: AlertString.FeedbackType.passwordChanged.rawValue) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }    
}
