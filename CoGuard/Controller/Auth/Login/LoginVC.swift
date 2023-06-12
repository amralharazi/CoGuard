//
//  LoginVC.swift
//  CoGuard
//
//  Created by عمرو on 18.05.2023.
//

import UIKit

class LoginVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    
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
    
    private func getPassword() -> String? {
        if let password = passwordTextField.text,
           !password.isEmpty {
            return password
        } else {
            showPopup(message: AlertString.ErrorType.emptyPassword.rawValue)
            return nil
        }
    }
    
    // MARK: Actions
    @IBAction func loginBtnPressed(_ sender: Any) {
        if let email = getEmail(),
           let password = getPassword() {
            let credentails = AuthCredentials(email: email, password: password)
            loginUser(with: credentails)
        }
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        goToResetPasswordScreen()
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        goToSignupScreen()
    }
    
    // MARK: Requests
    private func loginUser(with credentials: AuthCredentials) {
        showLoadingAnimation()
        
        AuthService.shared.loginUser(with: credentials) {[weak self] user, error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if user == nil && error == nil {
                self.goToVerifyEmailScreen(credentials: credentials)
                return
            }
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            }
            
            if let user = user {
                UniversalFuncs.shared.storeDataOf(user: user)
                if user.hasCompletedProfile {
                    self.goToDashboardScreen()
                } else {
                    self.goToCompleteProfileScreen()
                }
            }
        }
    }
}

// MARK: Navigations
extension LoginVC {
    private func goToVerifyEmailScreen(credentials: AuthCredentials){
        let storyboard = UIStoryboard(name: Storyboard.VerifyEmail, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.VerifyEmailVC) as? VerifyEmailVC {
            viewController.credentials = credentials
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    private func goToSignupScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Signup, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.SignupVC) as? SignupVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    private func goToResetPasswordScreen(){
        let storyboard = UIStoryboard(name: Storyboard.ResetPassword, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.ResetPasswordVC) as? ResetPasswordVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    private func goToDashboardScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Dashboard, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.DashboardVC) as? DashboardVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    private func goToCompleteProfileScreen(){
        let storyboard = UIStoryboard(name: Storyboard.CompleteProfile, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CompleteProfileVC) as? CompleteProfileVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
