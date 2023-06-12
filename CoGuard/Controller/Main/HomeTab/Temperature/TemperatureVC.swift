//
//  TemperatureVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

class TemperatureVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var thermometerView: ThermometerView!
    @IBOutlet weak var tempLbl: UILabel!
    
    // MARK: Properties
    private var bodyTemp = "37.0"
    var newCard: ExaminationCard?

    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        tempLbl.text = bodyTemp + " ℃"
        thermometerView.delegate = self
    }
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
        goToAttachmentsScreen()
    }
}

extension TemperatureVC: ThermometerViewDelegate {
    func updateTemp(withValue value: Double) {
        bodyTemp = String(format:"%.1f", (value * 4) + 35)
        tempLbl.text =  "\(bodyTemp) ℃"
        newCard?.details.bodyTemperature = bodyTemp
    }
}

// MARK: Navigations
extension TemperatureVC {
    private func goToAttachmentsScreen(){
        let storyboard = UIStoryboard(name: Storyboard.CardAttachments, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CardAttachmentsVC) as? CardAttachmentsVC {
            viewController.card = newCard
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
