//
//  EditProfileVC.swift
//  CoGuard
//
//  Created by عمرو on 20.05.2023.
//

import UIKit

class EditProfileVC: TransparentViewCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var profilePhotoIV: RoundedIV!
    @IBOutlet weak var detailsTableView: UITableView!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private let imagePicker = UIImagePickerController()
    private var userDetails = [UserDetailModel]()
    private var profilePhotoImage: UIImage?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureItems()
        configureTableView()
        configureImagePicker()
        addGestureRecognizers()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureItems(){
        guard let user = UniversalFuncs.shared.getCurrentUser(),
              let details = user.dict else {return}
        print(user)
        for case let item in ProfileDetail.allCases {
            if (item == ProfileDetail.hospital ||
                item == ProfileDetail.specialty) && !user.isDoctor {continue}
            userDetails.append(UserDetailModel(userDetail: item, value: details[item.title.lowercased()]))
        }
        
        if let stringUrl = user.profileImage,
           let url = URL(string: stringUrl) {
            profilePhotoIV.sd_setImage(with: url)
        }
        
        updateTableViewHeight()
    }
    
    private func configureTableView(){
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: Cell.ProfileDetailCell.name, bundle: nil), forCellReuseIdentifier: Cell.ProfileDetailCell.name)
    }
    
    private func updateTableViewHeight(){
        if let height = view.window?.windowScene?.screen.bounds.height {
            detailsTableView.rowHeight = height * 0.05
            tableViewHeight.constant = (height * 0.05) * CGFloat(userDetails.count)
        } else {
            detailsTableView.rowHeight = 50
            tableViewHeight.constant = 50.0 * CGFloat(userDetails.count)
        }
    }
    
    private func addGestureRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        profilePhotoIV.addGestureRecognizer(tapGesture)
        profilePhotoIV.isUserInteractionEnabled = true
        profilePhotoIV.tag = 0
    }
    
    private func configureImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func showImagePicker(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera" , style: .default, handler: { action in
            
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        })
        
        let gallery = UIAlertAction(title: "Gallery" , style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel" , style: .cancel, handler: { action in
            
        })
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    private func getUserDetails() -> [String: Any]? {
        var details = [String: Any]()
        for detail in userDetails {
            if detail.value == nil {
                showPopup(message: "Please don't leave \(detail.userDetail.title.lowercased()) field empty.")
                return nil
            } else {
                details[detail.userDetail.title.lowercased()] = detail.value
            }
        }
        return details
    }
    
    // MARK: Actions
    @IBAction func changePhotoBtnPressed(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        if let _ = profilePhotoImage {
            updateProfilePhoto()
        } else if let details = getUserDetails() {
            updateUserWith(details)
        }
    }
    
    @IBAction func deleteAccountBtnPressed(_ sender: Any) {
        showAlertScreen(title: AlertString.FeedbackType.attention.rawValue,
                        subtitle: AlertString.FeedbackType.wantToDeleteAccount.rawValue,
                        isDangerous: true)
    }
    
    // MARK: Selectors
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        
        if tag == 0 {
            showImagePicker()
        }
    }
    
    // MARK: Requests
    private func updateProfilePhoto(){
        guard let image = profilePhotoImage,
              let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        showLottieAnimation()
        
        UserService.shared.uploadPhoto(data: imageData) {[weak self] url, error in
            guard let self = self else {return}
            
            if let error = error {
                hideLottieAnimation()
                showAlert(withTitle: AlertString.ErrorType.title.rawValue ,
                          withMessage: error.localizedDescription)
                
                return
            }
            
            if var details = getUserDetails() {
                details["profileImage"] = url?.absoluteString
                updateUserWith(details)
            }
        }
    }
    
    private func updateUserWith(_ details: [String: Any]){
        showLottieAnimation()
        
        UserService.shared.updateUser(details: details) {[weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue ,
                          withMessage: error.localizedDescription)
                
                return
            } else {
                showPopup(message: AlertString.FeedbackType.profileUpdated.rawValue ) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func deleteUser(){
        showLottieAnimation()
        
        AuthService.shared.deleteAccount {[weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                print(error)
            } else {
                self.goToLoginScreen()
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension EditProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ProfileDetailCell.reuseIdentifier) as? ProfileDetailCell {
            cell.detail = userDetails[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: AuthFieldCellDelegate
extension EditProfileVC: ProfileDetailCellDelegate {
    func set(value: Any, forDetailWith id: Int) {
        if let index = userDetails.firstIndex(where: {$0.id == id}) {
            userDetails[index].value = value
        }
    }
}

// MARK:  UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        profilePhotoIV.image = image
        profilePhotoImage = image
        dismiss(animated: true, completion: nil)
    }
}

// MARK: AlertVCDelegate
extension EditProfileVC {
    override func alertBtnPressed(_ tag: Int) {
        hideTransparentView()
        
        guard let btn = AlertBtn(rawValue: tag) else {return}
        switch btn {
        case .yesBtn:
            deleteUser()
        case .noBtn:
            break
        }
    }
}

// MARK: Navigations
extension EditProfileVC {
    private func goToLoginScreen(){
        UniversalFuncs.shared.resetDefaults()
        let storyboard = UIStoryboard(name: Storyboard.Login, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.LoginVC) as? LoginVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
