//
//  MostObservedSymptomsVC.swift
//  CoGuard
//
//  Created by عمرو on 26.05.2023.
//

import UIKit

class MostObservedSymptomsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var barChartView: BarChart!
    
    // MARK: Properties
    private var totalCases = 0
    private var uniqueColors = [UIColor.systemBlue, UIColor.orange, UIColor.systemPink, UIColor.darkGray, UIColor.systemPurple]
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMostObservedSymptoms()
    }
    
    // MARK: Helpers
    private func generateDataPoints(from symptoms: [String: Int]) {
        let data = Array(symptoms.sorted(by: {$0.value > $1.value}).prefix(5)).map({BarChart.DataPoint(label: $0.key.camelCaseToWords().capitalizedFirstLetter ,value: Float($0.value), color: getColor())})
        barChartView.setup(data: Array(data.prefix(5)), total: Float(totalCases))
    }
    
    private func getColor() -> UIColor {
        if uniqueColors.isEmpty {
            return UIColor.black
        } else {
            let color = uniqueColors.first
            uniqueColors.remove(at: 0)
            return color!
        }
    }
    
    // MARK: Requests
    private func fetchMostObservedSymptoms(){
        showLottieAnimation()
        
        CasesService.shared.fetchMostObservedSymptoms {[weak self] symptoms, totalCases in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if symptoms.isEmpty && totalCases == 0 {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage:  AlertString.ErrorType.noDataToBePlotted.rawValue)
            } else {
                self.totalCases = totalCases
                generateDataPoints(from: symptoms)
            }
        }
    }
}
