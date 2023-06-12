//
//  ViewController.swift
//  CoGuard
//
//  Created by عمرو on 16.05.2023.
//

import UIKit

class SignupVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var photoIV: RoundedIV!
    @IBOutlet weak var userTypeSC: UISegmentedControl!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var signupBtn: AdjustableButton!
    @IBOutlet weak var haveAccountBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private let imagePicker = UIImagePickerController()
    private var userDetails = [UserDetailModel]()
    private var ProfilePhotoImage: UIImage?
    private var hasAppeared = false
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasAppeared {
            detailsTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasAppeared = true
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureItems()
        configureTermsBtn()
        configureTableView()
        configureImagePicker()
        updateTableViewHeight()
        addGestureRecognizers()
        configureSegmentedCntrl()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureItems(){
        userDetails.removeAll()
        
        for case let item in RegistertionDetail.allCases {
            if (item == RegistertionDetail.hospital ||
                item == RegistertionDetail.speciality)
                && userTypeSC.selectedSegmentIndex == 0 {
                continue
            } else {
                userDetails.append(UserDetailModel(userDetail: item))
            }
        }
        
        updateTableViewHeight()
    }
    
    private func configureSegmentedCntrl(){
        userTypeSC.defaultConfiguration()
        userTypeSC.selectedConfiguration()
    }
    
    private func configureTableView(){
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: Cell.AuthFieldCell.name, bundle: nil), forCellReuseIdentifier: Cell.AuthFieldCell.name)
    }
    
    private func updateTableViewHeight(){
        let totalItems = RegistertionDetail.allCases.count
            detailsTableView.rowHeight = 50
            tableViewHeight.constant = 50.0 * CGFloat((userTypeSC.selectedSegmentIndex == 0 ? totalItems - 2 : totalItems))
    }
    
    private func addGestureRecognizers(){
        let tappableViews = [photoIV, termsLbl]
        
        for i in tappableViews.indices {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
            tappableViews[i]?.addGestureRecognizer(tapGesture)
            tappableViews[i]?.isUserInteractionEnabled = true
            tappableViews[i]?.tag = i
        }
    }
    
    private func configureImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func configureTermsBtn(){
        termsBtn.setImage(UIImage(named: Asset.circle), for: .normal)
        termsBtn.setImage(UIImage(named: Asset.checkmarkInCircle), for: .selected)
        termsBtn.isSelected = false
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
                showPopup(message: "Please don't leave \(detail.userDetail.title.lowercased()) empty.")
                return nil
            } else {
                details[detail.userDetail.title.lowercased()] = detail.value
            }
        }
        return details
    }
    
    // MARK: Actions
    @IBAction func changeUserType(_ sender: UISegmentedControl) {
        configureItems()
        detailsTableView.reloadData()
    }
    
    @IBAction func toggleAcceptTermsBtn(_ sender: UIButton) {
        termsBtn.isSelected.toggle()
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        guard let pp = ProfilePhotoImage,
              let ppData = pp.jpegData(compressionQuality: 0.2) else {
            showPopup(message: AlertString.ErrorType.noProfilePhoto.rawValue )
            return}
        
        
        guard let details = getUserDetails(),
              let password = details["password"] as? String else { return }
        
        var user = User(dictionary: details)
        user.isDoctor = userTypeSC.selectedSegmentIndex ==  1
        let credentials = AuthCredentials(email: user.email, password: password)
        
        guard termsBtn.isSelected else {
            showPopup(message: AlertString.ErrorType.termsNotAccepted.rawValue )
            return
        }
        
        register(user: user, with: credentials, profilePhotoData: ppData)
    }
    
    @IBAction func haveAccountBtnPressed(_ sender: Any) {
        goToLoginScreen()
    }
    
    // MARK: Selectors
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        
        if tag == 0 {
            showImagePicker()
        } else if tag == 1 {
            if let url = URL(string: "https://cogurad.github.io/Consent/") {
                showWebScreenWith(url: url)
            }
        }
    }
    
    // MARK: Requests
    private func register(user: User, with credentials: AuthCredentials, profilePhotoData: Data) {
        showLoadingAnimation()
        AuthService.shared.register(user: user, with: credentials, profilePhotoData: profilePhotoData) {[weak self] error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue , withMessage: error.localizedDescription)
            } else {
                self.goToVerifyEmailScreen(credentials: credentials)
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension SignupVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.AuthFieldCell.reuseIdentifier) as? AuthFieldCell {
            cell.delegate = self
            cell.detail = userDetails[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: AuthFieldCellDelegate
extension SignupVC: AuthFieldCellDelegate {
    func set(value: Any, forDetailWith id: Int) {
        if let index = userDetails.firstIndex(where: {$0.id == id}) {
            userDetails[index].value = value
        }
    }
}

// MARK:  UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        photoIV.image = image
        ProfilePhotoImage = image
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Navigations
extension SignupVC {
    private func goToLoginScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Login, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.LoginVC) as? LoginVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    private func goToVerifyEmailScreen(credentials: AuthCredentials){
        let storyboard = UIStoryboard(name: Storyboard.VerifyEmail, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.VerifyEmailVC) as? VerifyEmailVC {
            viewController.credentials = credentials
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}


