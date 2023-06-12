//
//  GlobalStatCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class GlobalStatCell: UICollectionViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: Properties
    var globalStat: GlobalCasesData? {didSet{configureCell()}}

    // MARK: Helpers
    private func configureCell(){
        guard let globalStat = globalStat else {return}
        numberLbl.text = globalStat.value
        titleLbl.text = globalStat.title
    }

}
