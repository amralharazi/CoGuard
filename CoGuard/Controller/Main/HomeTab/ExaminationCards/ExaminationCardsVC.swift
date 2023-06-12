//
//  ExaminationCardsVC.swift
//  CoGuard
//
//  Created by عمرو on 23.05.2023.
//

import UIKit
import QuickLook

class ExaminationCardsVC: TransparentViewCoveredVC {
    
    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var cardsTableView: UITableView!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var cards = [ExaminationCard]() {didSet{cardsTableView.reloadData()}}
    private var contentSizeObserver: NSKeyValueObservation?
    private let previewController = QLPreviewController()
    private var previewItems: [QLPreviewItem] = []
    private var hasReachedTheEnd = false
    private var isLoadingMore = true
    private let threshold = 120.0
    private var isDoctor = false
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        configureSubiews()
        fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar(backgoundColor: .white, tintColor: .oliveGreen, hideShadow: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentSizeObserver = nil
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        observeHeight()
        configureTableView()
        subtitleLbl.text = isDoctor ? "All receieved examination cards" : "All previosuly filled and submitted \nexamination cards"
        if isDoctor {addExportBtn()}
        configurePreviewController()
    }
    
    private func addExportBtn(){
        let doneBtn = UIBarButtonItem(image: UIImage(named: Asset.arrowUp), style: .plain, target: self, action: #selector(handleTapOnleft(barBtn:)))
        doneBtn.tintColor = .oliveGreen
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    private func configureTableView(){
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableView.register(UINib(nibName: Cell.ExaminationCardCell.name, bundle: nil), forCellReuseIdentifier: Cell.ExaminationCardCell.name)
    }
    
    private func configurePreviewController(){
        previewController.dataSource = self
    }
    
    private func observeHeight(){
        contentSizeObserver = cardsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    func createCSV(from cards:[ExaminationCard]) {
        var csvString = "\("Patient"),\("Temperature"),\("Probability"),\("Date"),\("Hospital")\n"
        for card in cards {
            let name = card.details.patientName ?? ""
            let temp = "\(card.details.bodyTemperature ?? "") ℃"
            let probability = "\(card.details.probability ?? "") %"
            let date = card.details.date?.toDate() ?? ""
            let hospital = card.details.hospital ?? ""
            csvString = csvString.appending("\(name), \(temp), \(probability), \(date), \(hospital)\n")
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("PatientCards.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
             
             previewItems.append(fileURL as QLPreviewItem)
            presentPreviewScreen()
        } catch {
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: error.localizedDescription)
            print(error)
        }
    }
    
    // MARK: Selectors
    @objc func handleTapOnleft(barBtn: UIBarButtonItem){
       createCSV(from: cards)
    }
    
    // MARK: Requests
    private func fetchCards(){
        showLottieAnimation()
        isLoadingMore = true
        
        CardService.shared.fetchCards(forDoctor: isDoctor,
                                      endingAt: isDoctor ? cards.last?.id as Any : (cards.last?.details.date ?? Date().timeIntervalSince1970)) {[weak self] cards in
            guard let self = self else {return}
            self.hideLottieAnimation()
            self.isLoadingMore = false
            self.hasReachedTheEnd = cards.count < 10
            self.cards = cards
        }
    }
    
    func fetchUser(with id: String) {
        showLottieAnimation()
        
        UserService.shared.fetchUser(with: id) {[weak self] user, error in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                print(error)
            }
            
            if let user = user {
                self.goToPatientProfile(user: user)
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension ExaminationCardsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ExaminationCardCell.reuseIdentifier) as? ExaminationCardCell {
            cell.isDoctor = isDoctor
            cell.card = cards[indexPath.row]
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDoctor {
            guard let userId = cards[indexPath.row].details.patientId else {return}
            fetchUser(with: userId)
        } else {
            goToRecsScreen(card: cards[indexPath.row])
        }
    }
}

// MARK: ExaminationCardCellDelegate
extension ExaminationCardsVC: ExaminationCardCellDelegate {
    func respondTo(cardAction: CardAction, for card: ExaminationCard) {
        switch cardAction {
        case .symptoms:
            goToSymptomsScreen(card: card)
            return
        case .attachments:
            goToAttachmentsScreen(card: card)
            return
        case .feedback:
            if card.details.feedback == nil,
            !isDoctor{
                showAlertScreen(title: "Under Review",
                                subtitle: "Doctor has not written your feedback yet, please check again later.",
                hasMultipleOptions: false)
            } else {
                goToFeedbackScreen(card: card)

            }
            return
        }
    }
}

// MARK:  UIScrollViewDelegate
extension ExaminationCardsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - contentOffset <= threshold),
           !hasReachedTheEnd,
           !isLoadingMore {
            fetchCards()
        }
    }
}

// MARK:  QLPreviewControllerDataSource
extension ExaminationCardsVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
         previewItems.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
       previewItems[index]
    }
}

// MARK: CardFeedbackVCDelegae
extension ExaminationCardsVC: CardFeedbackVCDelegae {
    func add(feedback: String, toCardWith id: String) {
        if let index = cards.firstIndex(where: {$0.id == id}) {
            cards[index].details.feedback = feedback
        }
    }
}

// MARK: Navigations
extension ExaminationCardsVC {
    private func goToRecsScreen(card: ExaminationCard){
        let storyboard = UIStoryboard(name: Storyboard.Recommendations, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.RecommendationsVC) as? RecommendationsVC {
            viewController.card = card
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToPatientProfile(user: User){
        let storyboard = UIStoryboard(name: Storyboard.Dashboard, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.ProfileVC) as? ProfileVC {
            viewController.user = user
            viewController.isBeingChecked = true
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToSymptomsScreen(card: ExaminationCard){
        let storyboard = UIStoryboard(name: Storyboard.Symptoms, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.SymptomsVC) as? SymptomsVC {
            viewController.card = card
            viewController.isChecking = true
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToAttachmentsScreen(card: ExaminationCard){
        let storyboard = UIStoryboard(name: Storyboard.CardAttachments, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CardAttachmentsVC) as? CardAttachmentsVC {
            viewController.card = card
            viewController.isChecking = true
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func goToFeedbackScreen(card: ExaminationCard){
        let storyboard = UIStoryboard(name: Storyboard.CardFeedback, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.CardFeedbackVC) as? CardFeedbackVC {
            viewController.card = card
            viewController.delegate = self
            viewController.isDoctor = isDoctor
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func presentPreviewScreen(){
        previewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(previewController, animated: true, completion: nil)
    }
}
