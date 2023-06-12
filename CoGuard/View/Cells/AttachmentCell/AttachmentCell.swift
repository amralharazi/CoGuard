//
//  AttachmentCell.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit

class AttachmentCell: UITableViewCell {
    
    // MARK: Subviews
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: Properties
    var cardAttachment: CardAttachment? {didSet{configureCell()}}
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0
        progressView.isHidden = true
    }
    
    // MARK: Helpers
    private func setupCell(){
        progressView.isHidden = true
    }
    
    private func configureCell(){
        guard let cardAttachment = cardAttachment else {return}
        titleLbl.text = cardAttachment.attachment.title
        if let progress = cardAttachment.progress {
            progressView.isHidden = false
            progressView.progress = progress
        }
    }
}
