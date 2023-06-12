//
//  HospitalCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit
import CoreLocation

protocol HospitalCellDelegate {
    func show(hospital: String, at: CLLocation)
}

class HospitalCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var photoIV: RoundedIV!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var confirmedLbl: UILabel!
    @IBOutlet weak var currentLbl: UILabel!
    @IBOutlet weak var criticalLbl: UILabel!
    @IBOutlet weak var recoveredLbl: UILabel!
    @IBOutlet weak var deathsLbl: UILabel!
    @IBOutlet weak var bottomSV: UIStackView!
    
    // MARK: Properties
    var delegate: HospitalCellDelegate?
    var isExpanded = false {didSet{toggleExpandCellCell()}}
    var hospital: NearbyHospital? {didSet{configureCell()}}
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleExpandCellCell()
    }
    
    // MARK: Helpers
    private func toggleExpandCellCell(){
        bottomSV.isHidden = !isExpanded
    }
    
    private func configureCell(){
        guard let hospital = hospital else {return}
        nameLbl.text = hospital.name
        cityLbl.text = hospital.city
        confirmedLbl.text = "\(hospital.totalCases)"
        currentLbl.text = "\(hospital.currentCases)"
        criticalLbl.text = "\(hospital.criticalCases)"
        recoveredLbl.text = "\(hospital.recovered)"
        deathsLbl.text = "\(hospital.deaths)"
        photoIV.sd_setImage(with: hospital.image)
    }
    
    // MARK: Actions    
    @IBAction func LocationBtnPressed(_ sender: Any) {
        guard let hospital = hospital else {return}
        delegate?.show(hospital: hospital.name, at: hospital.location)
    }
    
}
