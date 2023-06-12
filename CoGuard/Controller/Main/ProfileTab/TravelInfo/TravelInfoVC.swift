//
//  TravelInfoVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class TravelInfoVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var updateBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var userTravelInfo = [String: Bool]() {didSet{infoTableView.reloadData()}}
    private var contentSizeObserver: NSKeyValueObservation?
    private var travelInfo = [TravelInfo]()
    private var isDoctor = false
    var user: User?

    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        getTravelInfo()
        configureSubiews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentSizeObserver = nil
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        addDoneBtn()
        observeHeight()
        configureItems()
        configureTableView()
        updateBtn.isHidden = true
        if !isDoctor {addEditBtn()}
        configureNavBar(backgoundColor: .white, hideShadow: true)
        subtitleLbl.text = isDoctor ? "Patient's recent travel info" : "Please enter your travel info and \nupdate it regularly"
    }
    
    private func addEditBtn(){
        let editBtn = UIBarButtonItem(title: "Edit"  , style: .plain, target: self, action: #selector(handleTapOnRight(barBtn:)))
        editBtn.tintColor = .oliveGreen
        editBtn.tag = 0
        navigationItem.rightBarButtonItem = editBtn
    }
    
    private func addDoneBtn(){
        let doneBtn = UIBarButtonItem(title: "Done"  , style: .done, target: self, action: #selector(handleTapOnleft(barBtn:)))
        doneBtn.tintColor = .oliveGreen
        navigationItem.leftBarButtonItem = doneBtn
    }
    
    private func configureTableView(){
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.isUserInteractionEnabled = false
        infoTableView.register(UINib(nibName: Cell.TravelInfoCell.name, bundle: nil), forCellReuseIdentifier: Cell.TravelInfoCell.name)
    }
    
    private func observeHeight(){
        contentSizeObserver = infoTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    private func configureItems(){
        for case let info in TravelInfo.allCases {
            userTravelInfo[info.databaseKey] = false
            travelInfo.append(info)
        }
    }
    
    // MARK: Actions
    @IBAction func updateBtnPressed(_ sender: Any) {
        update(travelInfo: userTravelInfo)
    }
    
    // MARK: Selectors
    @objc func handleTapOnRight(barBtn: UIBarButtonItem){
        infoTableView.isUserInteractionEnabled.toggle()
        updateBtn.isHidden.toggle()
        
        if barBtn.tag == 0 {
            barBtn.tag = 1
            barBtn.title = "Cancel"
        } else {
            barBtn.tag = 0
            barBtn.title = "Edit"
        }
    }
    
    @objc func handleTapOnleft(barBtn: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    // MARK: Requests
    private func getTravelInfo(){
        showLoadingAnimation()
        
        UserService.shared.getTravelInfo(forUserWith: user?.uid) {[weak self] travelInfo in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let travelInfo = travelInfo {
                self.userTravelInfo = travelInfo
            }
        }
    }
    
    private func update(travelInfo: [String: Bool]){
        showLoadingAnimation()
        
        UserService.shared.updateUser(travelInfo: travelInfo) {[weak self] error in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue  ,
                          withMessage: error.localizedDescription)
            } else {
                showPopup(message: AlertString.FeedbackType.medicalConditionsUpdated.rawValue) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension TravelInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        travelInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.TravelInfoCell.reuseIdentifier) as? TravelInfoCell {
            let info = travelInfo[indexPath.row]
            cell.info = info
            cell.noBtn.isSelected = userTravelInfo[info.databaseKey] == false
            cell.yesBtn.isSelected = userTravelInfo[info.databaseKey] == true
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: TravelInfoCellDelegate
extension TravelInfoVC: TravelInfoCellDelegate {
    func setValue(_ value: Bool, to key: String) {
        userTravelInfo[key] = value
    }
}
