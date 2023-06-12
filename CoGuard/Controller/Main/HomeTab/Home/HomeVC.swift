//
//  HomeVC.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    // MARK: Properties
    private var items = [MenuItem]() {didSet{menuCollectionView.reloadData()}}
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: Helpers
    private func configureSubviews(){
        configureItems()
        configureCollectionView()
        configureCollectionViewLayout()
        configureNavBar(preferredLargeTitle: true)
    }
    
    private func configureItems(){
        guard let user = UniversalFuncs.shared.getCurrentUser() else {return}
        
        for case let item in MenuItem.allCases {
            if (item == .examinationCard && user.isDoctor)
            || (item == .mostObservedSymptoms && !user.isDoctor){continue}
            items.append(item)
        }
    }
    
    private func configureCollectionView(){
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(UINib(nibName: Cell.MenuItemCell.name, bundle: nil), forCellWithReuseIdentifier: Cell.MenuItemCell.reuseIdentifier)
    }
    
    private func configureCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = DrawingConstants.minimumSpacing
        layout.minimumInteritemSpacing = DrawingConstants.minimumSpacing
        menuCollectionView.contentInset = UIEdgeInsets(top: DrawingConstants.edgeInset, left: DrawingConstants.edgeInset, bottom: 0, right: DrawingConstants.edgeInset)
        menuCollectionView.collectionViewLayout = layout
    }
}

// MARK:  UICollectionViewDelegate & UICollectionViewDataSource
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.MenuItemCell.reuseIdentifier, for: indexPath) as? MenuItemCell {
            cell.item = items[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width-(2*DrawingConstants.edgeInset)-DrawingConstants.minimumSpacing)/2
        return CGSize(width:  itemWidth, height: collectionView.frame.height*0.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = items[indexPath.item].viewController else {return }
        if viewController is UINavigationController {
            viewController.modalPresentationStyle = .pageSheet
            present(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
