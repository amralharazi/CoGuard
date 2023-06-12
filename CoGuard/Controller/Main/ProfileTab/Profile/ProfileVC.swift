//
//  ProfileVC.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var profilePhotoImageView: RoundedIV!
    @IBOutlet weak var medicalConditionsSV: UIStackView!
    @IBOutlet weak var travelInfoSV: UIStackView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var hospitalLbl: UILabel!
    @IBOutlet weak var specialityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var medicalAndTravelInfoStack: UIStackView!
    @IBOutlet weak var editProfileBtn: AdjustableButton!
    @IBOutlet weak var signOutBtn: AdjustableButton!
    @IBOutlet weak var changePasswordBtn: AdjustableButton!
    
    // MARK: Properties
    private var isDoctor = false
    var isBeingChecked = false
    var user: User?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateFields()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureNavBar(preferredLargeTitle: false)
        addGestureRecognizers()
        
        if let _ = user {
            signOutBtn.isHidden = true
            hospitalLbl.isHidden = true
            specialityLbl.isHidden = true
            editProfileBtn.isHidden = true
            changePasswordBtn.isHidden = true
        } else {
            self.user = UniversalFuncs.shared.getCurrentUser()
        }
        
        if isDoctor && !isBeingChecked {
            statusLbl.isHidden = true
            medicalAndTravelInfoStack.isHidden = true
        }
    }
    
    private func populateFields(){
        guard let user = isBeingChecked ? self.user : UniversalFuncs.shared.getCurrentUser() else {return}
        
        nameLbl.text = user.name
        statusLbl.text = user.riskStatus
        hospitalLbl.text = user.hospital
        specialityLbl.text = user.specialty
        
        if let stringUrl = user.profileImage,
           let url = URL(string: stringUrl) {
            profilePhotoImageView.sd_setImage(with: url)
        }
    }
    
    private func addGestureRecognizers(){
        let views = [medicalConditionsSV, travelInfoSV]
        
        for i in views.indices {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
            views[i]?.addGestureRecognizer(tapGesture)
            views[i]?.isUserInteractionEnabled = true
            views[i]?.tag = i
        }
    }
    
    // MARK: Actions
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        goToEditProfileScreen()
    }
    
    @IBAction func signoutBtnPressed(_ sender: Any) {
        singOut()
    }
    
    @IBAction func chnagePasswordBtnPressed(_ sender: Any) {
        goToChangePasswordScreen()
    }
    
    // MARK: Selectors
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        
        if tag == 0 {
            goToMedicalConditionsScreen()
        } else if tag == 1 {
            goToTravelInfoScreen()
        }
    }
    
    // MARK: Requests
    private func singOut(){
        showLottieAnimation()
        AuthService.shared.logout {[weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                self.showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                               withMessage: error.localizedDescription)
                print(error)
            } else {
                UniversalFuncs.shared.resetDefaults()
                goToLoginScreen()
            }
        }
    }
}

// MARK: Navigations
extension ProfileVC {
    private func goToEditProfileScreen(){
        let storyboard = UIStoryboard(name: Storyboard.EditProfile, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.EditProfileVC) as? EditProfileVC {
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToMedicalConditionsScreen(){
        let storyboard = UIStoryboard(name: Storyboard.MedicalConditions, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.MedicalConditionsVC) as? MedicalConditionsVC {
            viewController.user = user
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    private func goToTravelInfoScreen(){
        let storyboard = UIStoryboard(name: Storyboard.TravelInfo, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.TravelInfoVC) as? TravelInfoVC {
            viewController.user = user
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    private func goToChangePasswordScreen(){
        let storyboard = UIStoryboard(name: Storyboard.ChangePassword, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.ChangePasswordVC) as? ChangePasswordVC {
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToLoginScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Login, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.LoginVC) as? LoginVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
