//
//  HospitalsVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit
import CoreLocation

class HospitalsVC: LottieCoveredVC {

    // MARK: Subviews
    @IBOutlet weak var hospitalsTableView: UITableView!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var hospitals = [NearbyHospital]() {didSet{hospitalsTableView.reloadData()}}
    private var contentSizeObserver: NSKeyValueObservation?
    private var expnadedCellIndexPath: IndexPath?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        fetchHospitals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        observeHeight()
        configureTableView()
    }
    
    private func configureTableView(){
        hospitalsTableView.delegate = self
        hospitalsTableView.dataSource = self
        hospitalsTableView.register(UINib(nibName: Cell.HospitalCell.name, bundle: nil), forCellReuseIdentifier: Cell.HospitalCell.name)
    }
    
    private func observeHeight(){
        contentSizeObserver = hospitalsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    // MARK: Requests
    private func fetchHospitals(){
        showLoadingAnimation()
        
        HospitalService.shared.fetchNearbyHospitals {[weak self] hospitals in
            guard let self = self else {return}
            self.hideLoadingAnimation()
            
            if let hospitals = hospitals {
                self.hospitals = hospitals
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension HospitalsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.HospitalCell.reuseIdentifier) as? HospitalCell {
            cell.isExpanded = expnadedCellIndexPath == indexPath
            cell.hospital = hospitals[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let expnadedCellIndexPath = expnadedCellIndexPath,
           expnadedCellIndexPath == indexPath {
            self.expnadedCellIndexPath = nil
            tableView.reloadRows(at: [indexPath], with: .fade)
        } else if let previousExpnadedCellIndexPath = expnadedCellIndexPath {
            expnadedCellIndexPath = indexPath
            tableView.reloadRows(at: [previousExpnadedCellIndexPath, indexPath], with: .fade)
        } else {
            expnadedCellIndexPath = indexPath
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: HospitalCellDelegate
extension HospitalsVC: HospitalCellDelegate {
    func show(hospital: String, at location: CLLocation) {
        if let nameAllowedURL = hospital.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "maps://?q=\(nameAllowedURL)&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else {
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: AlertString.ErrorType.locationCantBeShown.rawValue)
        }
    }
}
