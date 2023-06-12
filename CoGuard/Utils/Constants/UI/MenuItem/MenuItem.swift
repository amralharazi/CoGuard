//
//  MenuItem.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit

enum MenuItem: Int, CaseIterable {
    case examinationCard
    case mostObservedSymptoms
    case submittedCards
    case casesData
    case news
    case hospitals
    case casesMap
    
    var title: String {
        switch self {
        case .examinationCard:
            return "Examination Card"
        case .mostObservedSymptoms:
            return "Most Observed Symptoms"
        case .submittedCards:
            return "Submitted Cards"
        case .casesData:
            return "Statistics"
        case .news:
            return "Covid News"
        case .hospitals:
            return "Hospitals"
        case .casesMap:
            return "Cases Map"
        }
    }
    
    var img: UIImage {
        switch self {
        case .examinationCard:
            return UIImage(named: Asset.card) ?? UIImage()
        case .mostObservedSymptoms:
            return UIImage(named: Asset.chart) ?? UIImage()
        case .submittedCards:
            return UIImage(named: Asset.history) ?? UIImage()
        case .casesData:
            return UIImage(named: Asset.stats) ?? UIImage()
        case .news:
            return UIImage(named: Asset.news) ?? UIImage()
        case .hospitals:
            return UIImage(named: Asset.hospitals) ?? UIImage()
        case .casesMap:
            return UIImage(named: Asset.map) ?? UIImage()
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .examinationCard:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Symptoms, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.SymptomsVC) as! SymptomsVC
            viewController.hidesBottomBarWhenPushed = true
            return LottieCoveredNVC(rootViewController: viewController)
        case .mostObservedSymptoms:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.MostObservedSymptoms, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.MostObservedSymptomsVC) as! MostObservedSymptomsVC
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        case .submittedCards:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.ExaminationCards, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.ExaminationCardsVC) as! ExaminationCardsVC
            viewController.hidesBottomBarWhenPushed = true
            return LottieCoveredNVC(rootViewController: viewController)
        case .casesData:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Statistics, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.StatisticsVC) as! StatisticsVC
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        case .news:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.CovidNews, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.CovidNewsVC) as! CovidNewsVC
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        case .hospitals:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.Hospitals, bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: VCIdentifier.HospitalsVC) as! HospitalsVC
            viewController.hidesBottomBarWhenPushed = true
            return UINavigationController(rootViewController: viewController)
        case .casesMap:
            let storyBoard: UIStoryboard = UIStoryboard(name: Storyboard.CasesMap, bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: VCIdentifier.CasesMapVC) as! CasesMapVC
        }
    }
}
