//
//  SymptomsVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit
import CoreLocation

class SymptomsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var symptomsTableView: UITableView!
    @IBOutlet weak var nextBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var contentSizeObserver: NSKeyValueObservation?
    private let locationManager = CLLocationManager()
    private var isDoctor = false
    var card: ExaminationCard?
    var isChecking = false
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(backgoundColor: .white, tintColor: .oliveGreen, hideShadow: true)
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        
        if !isDoctor {
            requestLocationAccess()
            locationManager.delegate = self
        }
        configureSubiews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentSizeObserver = nil
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        observeHeight()
        configureTableView()
        
        subtitleLbl.text = isDoctor ? "Patient's symptoms and their severity rate" : "Please rate your observed symptoms"
        
        if isChecking {
            nextBtn.isHidden = true
            symptomsTableView.isUserInteractionEnabled = false
        } else {
            card = ExaminationCard()
            configureItems()
            card?.details.date = Date().timeIntervalSince1970
            let user = UniversalFuncs.shared.getCurrentUser()
            card?.details.patientId = user?.uid
            card?.details.patientName = user?.name
        }
    }
    
    private func configureItems(){
        for case let symptom in Symptom.allCases {
            card?.symptoms.append(PatientSymptom(symptom: symptom))
        }
    }
    
    private func configureTableView(){
        symptomsTableView.delegate = self
        symptomsTableView.dataSource = self
        symptomsTableView.register(UINib(nibName: Cell.SymptomCell.name, bundle: nil), forCellReuseIdentifier: Cell.SymptomCell.name)
    }
    
    private func observeHeight(){
        contentSizeObserver = symptomsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    func calculateProbability(){
        guard let patient = UniversalFuncs.shared.getCurrentUser() else {return}
        let sex = patient.sex
        let age = patient.getAge()
        
        let sexValue = sex.caseInsensitiveCompare("male") == .orderedSame ? 1.0 : 0
        
        guard let lossOfSmellAndTasteRate = card?.symptoms.first(where: {$0.id == Symptom.lossOfSmellAndTaste.rawValue})?.rate,
              let abdominalPainRate = card?.symptoms.first(where: {$0.id == Symptom.abdominalPain.rawValue})?.rate,
              let inappetenceRate = card?.symptoms.first(where: {$0.id == Symptom.inappetence.rawValue})?.rate,
              let persistentCoughRate = card?.symptoms.first(where: {$0.id == Symptom.caugh.rawValue})?.rate,
              let diarrheaRate = card?.symptoms.first(where: {$0.id == Symptom.diarrhea.rawValue})?.rate,
              let fatigueRate = card?.symptoms.first(where: {$0.id == Symptom.fatigue.rawValue})?.rate,
              let feverRate = card?.symptoms.first(where: {$0.id == Symptom.fever.rawValue})?.rate else {
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: AlertString.ErrorType.unexpectedError.rawValue)
            return}
        
        let lossOfSmellAndTasteValue = lossOfSmellAndTasteRate > 0 ? 1.0 : 0
        let persistentCoughValue = persistentCoughRate > 0 ? 1.0 : 0
        let abdominalPainValue = abdominalPainRate > 0 ? 1.0 : 0
        let inappetenceValue = inappetenceRate > 0 ? 1.0 : 0
        let diarrheaValue = diarrheaRate > 0 ? 1.0 : 0
        let fatigueValue = fatigueRate > 0 ? 1.0 : 0
        let feverValue = feverRate > 0 ? 1.0 : 0
        
        let model1 = -1.32
        - (0.01 * Double(age))
        + (0.44 * sexValue)
        + (1.75 * lossOfSmellAndTasteValue)
        + (0.31 * persistentCoughValue)
        + (0.49 * fatigueValue)
        + (0.39 * inappetenceValue)
        
        let  model1Probability = exp(model1) / (1 + exp(model1))
        
        let model2 = -2.30
        + (0.01 * Double(age))
        - (0.24 * sexValue)
        + (1.6 * lossOfSmellAndTasteValue)
        + (0.76 * feverValue)
        + (0.33 * persistentCoughValue)
        + (0.25 * fatigueValue)
        + (0.31 * diarrheaValue)
        + (0.46 * inappetenceValue)
        - (0.48 * abdominalPainValue)
        
        let  model2Probability = exp(model2) / (1 + exp(model2))
        
        let averageProbability =  ((model1Probability+model2Probability)/2) * 100
        
        let scoreBasedCase: Int
        if averageProbability >= 85.0 {
            scoreBasedCase = 0
        } else if averageProbability > 50.0 && averageProbability < 85.0 {
            scoreBasedCase = 1
        } else {
            scoreBasedCase = 2
        }
        
        card?.details.probability = String(format:"%.1f", averageProbability)
        card?.details.scoreBasedCase = scoreBasedCase
        
        goToBodyTempScreen()
    }
    
    private func requestLocationAccess(){
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            showLocationDisabeledAlert()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
        calculateProbability()
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension SymptomsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        card?.symptoms.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.SymptomCell.reuseIdentifier) as? SymptomCell {
            cell.patientSymptom = card?.symptoms[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: SymptomCellDelegate
extension SymptomsVC: SymptomCellDelegate {
    func set(rate: Int, for symptom: PatientSymptom) {
        if let index = card?.symptoms.firstIndex(where: {$0.id == symptom.id}) {
            card?.symptoms[index].rate = rate
        }
    }
}

// MARK: CLLocationManagerDelegate
extension SymptomsVC: CLLocationManagerDelegate {
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.delegate = nil
            card?.locaion = location
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationAccess()
    }
}

// MARK: Navigations
extension SymptomsVC {
    private func goToBodyTempScreen(){
        let storyboard = UIStoryboard(name: Storyboard.Temperature, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.TemperatureVC) as? TemperatureVC {
            viewController.newCard = card
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

