//
//  ExaminationCardCell.swift
//  CoGuard
//
//  Created by عمرو on 23.05.2023.
//

import UIKit

protocol ExaminationCardCellDelegate {
    func respondTo(cardAction: CardAction, for: ExaminationCard)
}

enum CardAction: Int {
    case symptoms
    case attachments
    case feedback
}

class ExaminationCardCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var hospitalLbl: UILabel!
    @IBOutlet weak var probabilityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var btnsStackView: UIStackView!
    @IBOutlet weak var feedbackBtn: AdjustableButton!
    
    // MARK: Properties
    var delegate: ExaminationCardCellDelegate?
    var card: ExaminationCard? {didSet{configureCell()}}
    var isDoctor = false
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtns()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedbackBtn.backgroundClr = .oliveGreen
    }
    
    // MARK: Helpers
    private func setupBtns(){
        for (index, elemnt) in btnsStackView.subviews.filter({$0 is UIButton}).enumerated() {
            elemnt.tag = index
        }
    }
    
    private func configureCell(){
        guard let card = card else {return}
        if let date = card.details.date {
            dateLbl.text = "\(date.toDate())"
        }
        if isDoctor {
            userTypeLbl.text = "Patient"
            userNameLbl.text = card.details.patientName
        } else {
            userTypeLbl.text = "Doctor"
            userNameLbl.text = card.details.doctorName
        }
        
        hospitalLbl.text = card.details.hospital
        probabilityLbl.text = "\((card.details.probability) ?? "")%"
        tempLbl.text = "\(card.details.bodyTemperature ?? "") ℃"
        if card.details.feedback  == nil {
            feedbackBtn.backgroundClr = .lightGray
        }
    }

    // MARK: Actions
    @IBAction func btnPressed(_ sender: UIButton) {
        guard let cardAction = CardAction(rawValue: sender.tag),
        let card = card else {return}
        delegate?.respondTo(cardAction: cardAction, for: card)
    }
}
