//
//  CardAttachmentsVC.swift
//  CoGuard
//
//  Created by عمرو on 24.05.2023.
//

import UIKit
import AVKit
import UniformTypeIdentifiers

class CardAttachmentsVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var attachmentsTableView: UITableView!
    @IBOutlet weak var nextBtn: AdjustableButton!
    
    // MARK: Constraints
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var contentSizeObserver: NSKeyValueObservation?
    private let imagePicker = UIImagePickerController()
    private var tappedIndexPath: IndexPath?
    private var isDoctor = false
    var card: ExaminationCard?
    var isChecking = false
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isDoctor = UniversalFuncs.shared.getCurrentUser()?.isDoctor ?? false
        configureSubiews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeHeight()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentSizeObserver = nil
    }
    
    // MARK: Helpers
    private func configureSubiews(){
        observeHeight()
        configureTableView()
        
        subtitleLbl.text = isDoctor ? "Supporting visuals for a more accurate evaluation" : "Please upload the following docs for \na more accurate evaluation"
        
        if isChecking {
            nextBtn.isHidden = true
        } else {
            configureItems()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
        }
    }
    
    private func configureItems(){
        for case let attachment in Attachment.allCases {
            card?.attachments.append(CardAttachment(attachment: attachment))
        }
    }
    
    private func configureTableView(){
        attachmentsTableView.delegate = self
        attachmentsTableView.dataSource = self
        attachmentsTableView.register(UINib(nibName: Cell.AttachmentCell.name, bundle: nil), forCellReuseIdentifier: Cell.AttachmentCell.name)
    }
    
    private func observeHeight(){
        contentSizeObserver = attachmentsTableView.observe(\UITableView.contentSize, options: [NSKeyValueObservingOptions.new], changeHandler: { _, change in
            if let contentHeight = change.newValue?.height {
                self.tableViewHeight.constant = contentHeight
            }
        })
    }
    
    private func configureImagePickerFor(index: Int){
        if index > 2 {
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.videoMaximumDuration = 10
            imagePicker.videoQuality = .type640x480
        } else {
            imagePicker.mediaTypes = [UTType.image.identifier]
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePicker, animated: true)
        }
    }
    
    private func getAttachmentDataFrom(media info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.2){
            uploadAttachment(data: data)
        } else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            do {
                let videoData = try Data(contentsOf: videoUrl as URL)
                uploadAttachment(data: videoData, isImage: false)
            } catch {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                print(error)
            }
        }
    }
    
    private func show(visualFrom stringUrl: String) {
        guard let url = URL(string: stringUrl) else {return}
        
        if url.isImageFile {
           showImage(with: url)
        } else {
            playVideo(url: url)
        }
    }
    
    // MARK: Actions
    @IBAction func nextBtnPressed(_ sender: Any) {
        goToDoctorListScreen()
    }
    
    // MARK: Requests
    private func uploadAttachment(data: Data, isImage: Bool = true) {
        
        CardService.shared.uploadAttachment(data: data, isImage: isImage) {[weak self] progress, url, error in
            guard let self = self else {return}
            
            if let error = error {
                showAlert(withTitle: AlertString.ErrorType.title.rawValue,
                          withMessage: error.localizedDescription)
                return
            }
            
            if let url = url,
               let indexPath = tappedIndexPath {
                card?.attachments[indexPath.row].stringUrl = url.absoluteString
            }
            
            if let progress = progress,
               let indexPath = tappedIndexPath {
                card?.attachments[indexPath.row].progress = progress
                attachmentsTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDelegate
extension CardAttachmentsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        card?.attachments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.AttachmentCell.reuseIdentifier) as? AttachmentCell {
            cell.cardAttachment = card?.attachments[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isChecking,
           let stringUrl = card?.attachments[indexPath.row].stringUrl {
            show(visualFrom: stringUrl)
        } else {
            configureImagePickerFor(index: indexPath.row)
        }
        tappedIndexPath = indexPath
    }
}

// MARK:  UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CardAttachmentsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        getAttachmentDataFrom(media: info)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Navigations
extension CardAttachmentsVC {
    private func goToDoctorListScreen(){
        let storyboard = UIStoryboard(name: Storyboard.DoctorList, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.DoctorListVC) as? DoctorListVC {
            viewController.newCard = card
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func showImage(with url: URL) {
        let storyboard = UIStoryboard(name: Storyboard.ImageViewer, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: VCIdentifier.ImageViewerVC) as? ImageViewerVC {
            viewController.url = url
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) { vc.player?.play() }
    }
}
