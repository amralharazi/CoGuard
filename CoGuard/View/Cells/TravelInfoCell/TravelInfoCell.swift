//
//  TravelInfoCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

protocol TravelInfoCellDelegate {
    func setValue(_: Bool, to key: String)
}

class TravelInfoCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    // MARK: Properties
    private var btns = [UIButton]()
    var delegate: TravelInfoCellDelegate?
    var info: TravelInfo? {didSet{configureCell()}}
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    // MARK: Helpers
    private func setupCell(){
        btns = [yesBtn, noBtn]
        
        for btn in btns {
            btn.setImage(UIImage(named: Asset.circle), for: .normal)
            btn.setImage(UIImage(named: Asset.filledCircleInEmptyOne), for: .selected)
            btn.isSelected = false
        }
    }
    
    private func configureCell(){
        guard let info = info else {return}
        titleLbl.text = info.title
    }
    
    // MARK: Actions
    @IBAction func btnPressed(_ sender: UIButton) {
        guard !sender.isSelected,
              let key = info?.databaseKey else {return}
        delegate?.setValue(sender == yesBtn ? true : false, to: key)
        
        for btn in btns {
            btn.isSelected = btn == sender ? true : false
        }
    }
}
