//
//  MedicalConditionsVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class MedicalConditionsVC: LottieCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var conditionsTableView: UITableView!
    @IBOutlet weak var updateBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var selectedConditions = [String: Bool]() {didSet{conditionsTableView.reloadData()}}
    private var contentSizeObserver: NSKeyValueObservation?
    private var medicalConditions = [MedicalCondition]()
    private var isDoctor = false
    var user: User?

    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        getMedicalConditions()
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
        subtitleLbl.text = isDoctor ? "Patient's medical conditions" : "Please select all of the following if\napply to you"    }
    
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
        conditionsTableView.delegate = self
        conditionsTableView.dataSource = self
        conditionsTableView.isUserInteractionEnabled = false
        conditionsTableView.allowsMultipleSelection = true
        conditionsTableView.register(UINib(nibName: Cell.ConditionCell.name, bundle: nil), forCellReuseIdentifier: Cell.ConditionCell.name)
    }
    
    
    private func observeHeight(){
        contentSizeObserver = conditionsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    private func configureItems(){
        for case let condition in MedicalCondition.allCases {
            selectedConditions[condition.databaseKey] = false
            medicalConditions.append(condition)
        }
    }
    
    // MARK: Actions
    @IBAction func updateBtnPressed(_ sender: Any) {
        update(medicalConditions: selectedConditions)
    }
    
    // MARK: Selectors
    @objc func handleTapOnRight(barBtn: UIBarButtonItem){
        conditionsTableView.isUserInteractionEnabled.toggle()
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
    private func getMedicalConditions(){
        showLoadingAnimation()
        
        UserService.shared.getMedicalConditions(forUserWith: user?.uid) {[weak self] conditions in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let conditions = conditions {
                self.selectedConditions = conditions
            }
        }
    }
    
    private func update(medicalConditions: [String: Bool]){
        showLoadingAnimation()
        
        UserService.shared.updateUser(medicalConditions: medicalConditions) {[weak self] error in
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
extension MedicalConditionsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        medicalConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ConditionCell.reuseIdentifier) as? ConditionCell {
            let condition = medicalConditions[indexPath.row]
            cell.condition = condition
            if selectedConditions[condition.databaseKey] == true {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let condition = medicalConditions[indexPath.row]
        selectedConditions[condition.databaseKey] = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let condition = medicalConditions[indexPath.row]
        selectedConditions[condition.databaseKey] = false
    }
}
