//
//  ConditionCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class ConditionCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selectionIV: UIImageView!
    
    // MARK: Properties
    var condition: MedicalCondition? {didSet{configureCell()}}
    
    // MARK: Actions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.1) {
            self.selectionIV.image = UIImage(named: selected ? Asset.filledCircleInEmptyOne: Asset.circle) 
        }
    }
    
    // MARK: Helpers
    private func configureCell(){
        guard let condition = condition else {return}
        nameLbl.text = condition.title
    }
    
}
