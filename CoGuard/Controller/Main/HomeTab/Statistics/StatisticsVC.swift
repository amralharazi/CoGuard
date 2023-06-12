//
//  StatisticsVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class StatisticsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countryDataTableView: UITableView!
    private let searchBar = UISearchBar()
    
    // MARK: Properties
    private var filteredCountriesData = [RegionStats]() {didSet{countryDataTableView.reloadData()}}
    private var allCountriesData = [RegionStats]() {didSet{filteredCountriesData = allCountriesData}}
    private var globalData = [GlobalCasesData]() {didSet{collectionView.reloadData()}}
    private let requestManager = RequestManager()
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await fetchStats()}
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureSearchBar()
        configureTableView()
        configureCollectionView()
        hideKeyboardWhenTappedAround()
        configureCollectionViewLayout()
        configureNavBar(preferredLargeTitle: true)
    }
    
    private func configureSearchBar(){
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.textColor = .black
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search For Country"
        searchBar.searchTextField.setPlaceHolderColor(.gray)
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.rightView?.tintColor = .gray
    }
    
    private func configureTableView(){
        countryDataTableView.delegate = self
        countryDataTableView.dataSource = self
        if #available(iOS 15.0, *) {countryDataTableView.sectionHeaderTopPadding = 0}
        countryDataTableView.register(UINib(nibName: Cell.CountryStatCell.name, bundle: nil), forCellReuseIdentifier: Cell.CountryStatCell.name)
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.GlobalStatCell.name, bundle: nil), forCellWithReuseIdentifier: Cell.GlobalStatCell.reuseIdentifier)
    }
    
    private func configureCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = DrawingConstants.statMinSpacing
        layout.minimumInteritemSpacing = DrawingConstants.statMinSpacing
        collectionView.contentInset = UIEdgeInsets(top: DrawingConstants.statEdgeInset, left: DrawingConstants.statEdgeInset, bottom: 0, right: DrawingConstants.statEdgeInset)
        collectionView.collectionViewLayout = layout
    }
    
    private func configureDataItemsWith(stats: RegionStats){
        if let totalCases = stats.cases?.total {
            globalData.append(GlobalCasesData(title: "Total", value: "\(totalCases.formatNumber())"))
        }
        
        if let recoveredCases = stats.cases?.recovered {
            globalData.append(GlobalCasesData(title: "Recovered", value: "\(recoveredCases.formatNumber())"))
        }
        
        if let deaths = stats.deaths?.total {
            globalData.append(GlobalCasesData(title: "Deaths", value: "\(deaths.formatNumber())"))
        }
        
        if let critical = stats.cases?.critical {
            globalData.append(GlobalCasesData(title: "Critical", value: "\(critical.formatNumber())"))
        }
        
        if let totalCases = stats.cases?.total,
           let recoveredCases = stats.cases?.recovered {
            let recoveryRate = (Double(recoveredCases)/Double(totalCases))*100
            globalData.append(GlobalCasesData(title: "Recovery %", value: String(format: "%.1f", recoveryRate)))
        }
        
        if let totalCases = stats.cases?.total,
           let deaths = stats.deaths?.total {
            let fatalityRate = (Double(deaths)/Double(totalCases))*100
            globalData.append(GlobalCasesData(title: "Fatality %", value: String(format: "%.1f", fatalityRate)))
        }
    }
    
    override func dismissKeyboard(){
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // MARK: Requests
    private func fetchStats() async {
        showLottieAnimation()
        
        do {
            let stats : CovidStatsResponse = try await requestManager.perform(CasesRequests.fetchGlobalCases)
            let allCountriesStats: CovidStatsResponse =  try await requestManager.perform(CasesRequests.fetchStatsForAllCountries)
            if let stats = stats.response?.first,
               let countriesData = allCountriesStats.response {
                configureDataItemsWith(stats: stats)
                self.allCountriesData = countriesData.compactMap({$0.country != nil ? $0 : nil}).sorted(by: {$0.country!.lowercased() < $1.country!.lowercased()})
            }
            
            self.hideLottieAnimation()
        } catch {
            self.hideLottieAnimation()
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: error.localizedDescription)
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension StatisticsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCountriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.CountryStatCell.reuseIdentifier) as? CountryStatCell {
            cell.countryStats = filteredCountriesData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
}

// MARK:  UICollectionViewDelegate & UICollectionViewDataSource
extension StatisticsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        globalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.GlobalStatCell.reuseIdentifier, for: indexPath) as? GlobalStatCell {
            cell.globalStat = globalData[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width-(2*DrawingConstants.statMinSpacing)-2*DrawingConstants.statEdgeInset)/3
        return CGSize(width:  itemWidth, height: collectionView.frame.height*0.5-DrawingConstants.statMinSpacing)
    }
}

// MARK: UISearchBarDelegate
extension StatisticsVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCountriesData = allCountriesData
        } else {
            filteredCountriesData = allCountriesData.filter({$0.country?.lowercased().contains(searchText.lowercased()) ?? false})
        }
        countryDataTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        filteredCountriesData = allCountriesData
    }
}
