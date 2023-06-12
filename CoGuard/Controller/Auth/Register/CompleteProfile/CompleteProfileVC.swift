//
//  CompleteProfileVC.swift
//  CoGuard
//
//  Created by عمرو on 25.05.2023.
//

import UIKit

class CompleteProfileVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var userDetails = [UserDetailModel]()
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureItems()
        configureTableView()
        updateTableViewHeight()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureItems(){
        for case let item in CompleteProfileDetail.allCases {
            userDetails.append(UserDetailModel(userDetail: item))
        }
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.AuthFieldCell.name, bundle: nil), forCellReuseIdentifier: Cell.AuthFieldCell.name)
    }
    
    private func updateTableViewHeight(){
            tableView.rowHeight = 50
            tableViewHeight.constant = 50.0 * CGFloat(userDetails.count)
    }
    
    private func getUserDetails() -> [String: Any]? {
        var details = [String: Any]()
        for detail in userDetails {
            if detail.value == nil {
                showPopup(message: "Please don't leave \(detail.userDetail.title.lowercased()) field empty.")
                return nil
            } else {
                details[(detail.userDetail as! CompleteProfileDetail).databaseKey] = detail.value
            }
        }
        return details
    }
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
        guard let details = getUserDetails() else {return}
        completeProfileWith(details: details)
    }
    
    // MARK: Requests
    private func completeProfileWith(details: [String: Any]) {
        showLoadingAnimation()
        
        UserService.shared.updateUser(details: details) {[weak self] error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue, withMessage: error.localizedDescription)
            } else {
                UserService.shared.listenToUserChanges()
                TokenService.shared.getKey()
                self.goToDashboardScreen()
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension CompleteProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.AuthFieldCell.reuseIdentifier) as? AuthFieldCell {
            cell.detail = userDetails[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: AuthFieldCellDelegate
extension CompleteProfileVC: AuthFieldCellDelegate {
    func set(value: Any, forDetailWith id: Int) {
        if let index = userDetails.firstIndex(where: {$0.id == id}) {
            userDetails[index].value = value
        }
    }
}

// MARK: Navigations
extension CompleteProfileVC {
    private func goToDashboardScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Dashboard, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.DashboardVC) as? DashboardVC {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
