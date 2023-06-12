//
//  CountryStatCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class CountryStatCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var confirmedLbl: UILabel!
    @IBOutlet weak var recoveredLbl: UILabel!
    @IBOutlet weak var deathsLbl: UILabel!
    
    // MARK: Properties
    var countryStats: RegionStats? {didSet{configureCell()}}
    
    // MARK: Helpers
    private func configureCell(){
        guard let countryStats = countryStats else {return}
        countryLbl.text = countryStats.country
        
        if let total = countryStats.cases?.total {
            confirmedLbl.text = "\(total.formatNumber())"
        }
        
        if let recoveredCases = countryStats.cases?.recovered {
            recoveredLbl.text = "\(recoveredCases.formatNumber())"
        }
        
        if let deaths = countryStats.deaths?.total {
            deathsLbl.text = "\(deaths.formatNumber())"
        }
    }
}
