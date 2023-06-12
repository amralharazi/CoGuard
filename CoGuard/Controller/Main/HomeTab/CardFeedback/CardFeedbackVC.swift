//
//  CardFeedbackVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

protocol CardFeedbackVCDelegae {
    func add(feedback: String, toCardWith id: String)
}

class CardFeedbackVC: UIViewController {

    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var feedbackTextView: RoundedTextView!
    @IBOutlet weak var sendBtn: AdjustableButton!
    
    // MARK: Properties
    var delegate: CardFeedbackVCDelegae?
    var card: ExaminationCard?
    var isDoctor = false
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubiews()
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        if !isDoctor {
            feedbackTextView.isEditable = false
            sendBtn.isHidden = true
            subtitleLbl.text = "Below, you can see doctor's feedback after \nevaluating your card."
        } else {
            subtitleLbl.text = "Write a feedback based on patient's profile, symptoms, and attachments"
        }
        
        if let feedback = card?.details.feedback {
            feedbackTextView.text = feedback
        }
    }
    
    // MARK: Actions
    @IBAction func sendBtnPressed(_ sender: Any) {
        guard let feedback = feedbackTextView.text,
              !feedback.replacingOccurrences(of: " ", with: "").isEmpty else {
            showPopup(message: AlertString.FeedbackType.emptyFeedback.rawValue)
            return
        }
        add(feedback: feedback)
    }
    
    // MARK: Requests
    private func add(feedback: String){
        
        guard let card = card,
              let cardId = card.id,
              let patientId = card.details.patientId else {
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: AlertString.ErrorType.unexpectedError.rawValue)
            return
        }
        
        showLottieAnimation()
        CardService.shared.add(feedback: feedback, toCardWith: cardId, fromPatientWith: patientId) {[weak self] error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                self.showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                                withMessage: error.localizedDescription)
                print(error)
            } else {
                self.delegate?.add(feedback: feedback, toCardWith: cardId)
                showPopup(message: AlertString.FeedbackType.feedbackSent.rawValue){
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
