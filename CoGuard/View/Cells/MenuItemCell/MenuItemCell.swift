//
//  MenuItemCell.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: Properties
    var item: MenuItem? {didSet{configureCell()}}
    
    // MARK: Helpers
    private func configureCell(){
        guard let item = item else {return}
        iconImageView.image = item.img
        titleLbl.text = item.title
    }
    
}
