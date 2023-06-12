//
//  DoctorListVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

class DoctorListVC: TransparentViewCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var doctorsTableView: UITableView!
    @IBOutlet weak var nextBtn: AdjustableButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var filteredDoctors = [User]() {didSet{doctorsTableView.reloadData()}}
    private var doctors = [User]() {didSet{filteredDoctors = doctors}}
    private var contentSizeObserver: NSKeyValueObservation?
    private var tappedDoctor: User?
    var newCard: ExaminationCard?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubiews()
        fetchDoctors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeHeight()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentSizeObserver = nil
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        configureSearchBar()
        configureTableView()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureTableView(){
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        if #available(iOS 15.0, *) {doctorsTableView.sectionHeaderTopPadding = 0}
        doctorsTableView.register(UINib(nibName: Cell.DoctorCell.name, bundle: nil), forCellReuseIdentifier: Cell.DoctorCell.name)
    }
    
    private func observeHeight(){
        contentSizeObserver = doctorsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    private func configureSearchBar(){
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.textColor = .black
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.searchTextField.setPlaceHolderColor(.gray)
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.rightView?.tintColor = .gray
    }
    
    override func dismissKeyboard(){
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
    }
    
    // MARK: Requests
    private func fetchDoctors(){
        showLottieAnimation()
        
        CardService.shared.fetchAllDoctors {[weak self] doctors in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            self.doctors = doctors
        }
    }
    
    private func uploadCard(){
        guard var newCard = newCard,
              let doctor = tappedDoctor else {return}
        showLottieAnimation()
        
        newCard.details.doctorId = doctor.uid
        newCard.details.doctorName = doctor.name
        newCard.details.hospital = doctor.hospital
        CardService.shared.upload(card: newCard) { [weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
            } else {
                showPopup(message: AlertString.FeedbackType.cardSent.rawValue) {
                    
                    self.goToRecsScreen(card: newCard)
                }
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension DoctorListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.DoctorCell.reuseIdentifier) as? DoctorCell {
            cell.doctor = filteredDoctors[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedDoctor = filteredDoctors[indexPath.row]
        guard let doctor = tappedDoctor else {return}
        showAlertScreen(title: "Permission Required",
                        subtitle: "Do you grant permission to Dr. \(doctor.name) to see your profile, card, and attachments?")
    }
}

// MARK: UISearchBarDelegate
extension DoctorListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredDoctors = doctors
        } else {
            filteredDoctors = doctors.filter {$0.name.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.hospital?.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.specialty?.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
        doctorsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        filteredDoctors = doctors
    }
}

// MARK: AlertVCDelegate
extension DoctorListVC  {
    override func alertBtnPressed(_ tag: Int) {
        hideTransparentView()
        
        guard let btn = AlertBtn(rawValue: tag) else {return}
        if btn == .yesBtn {
            uploadCard()
        }
    }
}

// MARK: Navigations
extension DoctorListVC {
    private func goToRecsScreen(card: ExaminationCard){
        let storyboard = UIStoryboard(name: Storyboard.Recommendations, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.RecommendationsVC) as? RecommendationsVC {
            viewController.card = card
            viewController.isAfterSubmittingCard = true
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
