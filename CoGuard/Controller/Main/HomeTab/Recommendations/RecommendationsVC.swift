//
//  RecommendationsVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

class RecommendationsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var probabilityLbl: UILabel!
    @IBOutlet weak var recommendationsTextView: RoundedTextView!
    
    // MARK: Properties
    private var attributedString = NSMutableAttributedString()
    var isAfterSubmittingCard = false
    var card: ExaminationCard?
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureRecsView()
        configureProbabilityString()
        
        if isAfterSubmittingCard{
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    private func configureRecsView(){
        if let score = card?.details.scoreBasedCase,
           let scoreCase = ScoreBasedRecs(rawValue: score){
                        
            for i in 0..<scoreCase.recs.count {
                let sugNumber  = i + 1
                let attrs = [NSAttributedString.Key.font : UIFont(name: AppFont.MontserratSemiBold, size: 14)]
                let attributedStr = NSMutableAttributedString(string:String(sugNumber)+". ", attributes: attrs as [NSAttributedString.Key : Any])
                
                let normalText = scoreCase.recs[i] + "\n\n"
                let attr = [NSAttributedString.Key.font : UIFont(name: AppFont.MontserratMedium, size: 14)]
                let normalString = NSMutableAttributedString(string: normalText, attributes: attr as [NSAttributedString.Key : Any])
                
                attributedStr.append(normalString)
                attributedString.append(attributedStr)
            }
            
            recommendationsTextView.attributedText =  attributedString
        }
    }
    
    private func configureProbabilityString(){
        if let probability = card?.details.probability {
            probabilityLbl.text = "Probability | \(probability)%"
        }
    }
    
    // MARK: Actions
    @IBAction func doneBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }    
}
