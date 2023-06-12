//
//  DoctorCell.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var photoIV: RoundedIV!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hospitalLbl: UILabel!
    @IBOutlet weak var specialityLbl: UILabel!
    
    // MARK: Properties
    var doctor: User? {didSet{configureCell()}}
    
    // MARK: Helpers
    private func configureCell(){
        guard let doctor = doctor else {return}
        nameLbl.text = doctor.name
        hospitalLbl.text = doctor.hospital
        specialityLbl.text = doctor.specialty
                
        if let stringUrl = doctor.profileImage,
           let url = URL(string: stringUrl) {
            photoIV.sd_setImage(with: url)
        }
    }
}
