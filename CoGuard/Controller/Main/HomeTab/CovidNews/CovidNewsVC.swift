//
//  CovidNewsVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit
import SafariServices

class CovidNewsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var newsTableView: UITableView!
    
    // MARK: Properties
    private var news = [News]() {didSet{newsTableView.reloadData()}}
    private let requestManager = RequestManager()
    private var hasReachedTheEnd = false
    private var isLoadingMore = true
    private let threshold = 120.0
    private var pageNumber = 1
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await fetchNews()}
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureTableView()
        configureNavBar(preferredLargeTitle: true)
    }
    
    private func configureTableView(){
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: Cell.NewsCell.name, bundle: nil), forCellReuseIdentifier: Cell.NewsCell.name)
    }
    
    // MARK: Requests
    private func fetchNews() async {
        showLottieAnimation()
        isLoadingMore = true

        do {
            let articles : Articles = try await requestManager.perform(NewsRequests.getNews(startingPage: pageNumber))
            self.news.append(contentsOf: articles.articles ?? [])
            self.pageNumber += 1
            self.isLoadingMore = false
            self.hideLottieAnimation()
            self.hasReachedTheEnd = pageNumber == articles.total_pages
        } catch {
            self.hideLottieAnimation()
            showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                      withMessage: error.localizedDescription)
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension CovidNewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.NewsCell.reuseIdentifier) as? NewsCell {
            cell.news = news[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = news[indexPath.row].link,
           let url = URL(string: link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
}

// MARK:  UIScrollViewDelegate
extension CovidNewsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        let contentOffset = scrollView.contentOffset.y
          let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - contentOffset <= threshold),
           !hasReachedTheEnd,
           !isLoadingMore {
            Task { await fetchNews()}
        }
    }
}
