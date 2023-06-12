//
//  SymptomCell.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

protocol SymptomCellDelegate {
    func set(rate: Int, for: PatientSymptom)
}

class SymptomCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var symptomLbl: UILabel!
    @IBOutlet weak var severeBtn: AdjustableButton!
    @IBOutlet weak var moderateBtn: AdjustableButton!
    @IBOutlet weak var lowBtn: AdjustableButton!
    @IBOutlet weak var notObservedBtn: AdjustableButton!
    @IBOutlet weak var btnsStackView: UIStackView!
    
    // MARK: Properties
    var patientSymptom: PatientSymptom? {didSet{configureCell()}}
    var delegate: SymptomCellDelegate?
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtns()
    }

    // MARK: Helpers
    private func setupBtns(selectedTag: Int? = nil){
        for (index, elemnt) in btnsStackView.subviews.filter({$0 is UIButton}).reversed().enumerated() {
            (elemnt as? UIButton)?.setTitleColor(.white, for: .normal)
            (elemnt as? UIButton)?.setTitleColor(SymptomRate(rawValue: index)?.selectedColor, for: .selected)
            elemnt.tag = index
            (elemnt as? UIButton)?.isSelected = elemnt.tag == selectedTag
            (elemnt as? AdjustableButton)?.boldText = elemnt.tag == selectedTag
        }
    }
    
    private func configureCell(){
        guard let patientSymptom = patientSymptom else {return}
        symptomLbl.text = patientSymptom.symptom.title
        setupBtns(selectedTag: patientSymptom.rate)
    }
    
    // MARK: Actions
    @IBAction func btnPressed(_ sender: UIButton) {
        for case let btn as AdjustableButton in btnsStackView.subviews {
            btn.isSelected = btn == sender
            btn.boldText = btn == sender
        }
        
        guard let patientSymptom = patientSymptom else {return}
        delegate?.set(rate: sender.tag, for: patientSymptom)
    }    
}
