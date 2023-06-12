//
//  NewsCell.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit

class NewsCell: UITableViewCell {

    // MARK: Subviews
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var photoIV: RoundedIV!
    
    // MARK: Properties
    var news: News? {didSet{configureCell()}}
    
    // MARK: Init
    override func prepareForReuse() {
        super.prepareForReuse()
        photoIV.image = nil
    }
    
    // MARK: Helpers
    private func configureCell(){
        guard let news = news else {return}
        titleLbl.text = news.title
        authorLbl.text = news.author
        dateLbl.text = news.published_date?.components(separatedBy: " ").first
        
        if let stringUrl = news.media,
           let url = URL(string: stringUrl) {
            photoIV.sd_setImage(with: url)
        }
    }
}
