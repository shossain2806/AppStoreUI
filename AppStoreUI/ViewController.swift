//
//  ViewController.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 22/1/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

enum CollectionViewElementKind  {
    static let footerElementKind = "footer-element-kind"
    static let headerElementKind = "header-element-kind"
    static let titleElementKind =  "title-element-kind"
    static let badgeElementKind = "badge-element-kind"
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    static let sectionBackgroundElementKind = "section-background-element-kind"
}

class ViewController: UIViewController {
        
    var collectionView: UICollectionView! = nil
    let storeController = AppStoreItemController()
   
    var dataSource : UICollectionViewDiffableDataSource<AppStoreItemController.AppStoreItemSection, AppStoreItemController.AppStoreItem>! = nil
    var currentSnapShot : NSDiffableDataSourceSnapshot<AppStoreItemController.AppStoreItemSection, AppStoreItemController.AppStoreItem>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Apps"
        configureHierarchy()
        configureDataSource()
    }


}

extension ViewController {
    
    func configureHierarchy(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "AppStoreFeatureCell", bundle: nil), forCellWithReuseIdentifier: AppStoreFeatureCell.cellIdentifier)
        collectionView.register(UINib(nibName: "AppStoreItemCell", bundle: nil), forCellWithReuseIdentifier: AppStoreItemCell.identifier)
        collectionView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind: CollectionViewElementKind.sectionHeaderElementKind, withReuseIdentifier: SectionHeaderView.identifier)
       
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout{
       
        let sectionProvider = {  (sectionIndex: Int,
                   layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionItem = self.currentSnapShot.sectionIdentifiers[sectionIndex]
           
            //item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
             
            //group
            //if we have space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth : CGFloat = layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.45 : 0.90
            let heightDimension : NSCollectionLayoutDimension = sectionItem.isFeaturedSection ? .absolute(300) : .absolute(260)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: heightDimension)
               
            let group = sectionItem.isFeaturedSection ? NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) : NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
               
            group.interItemSpacing = sectionItem.isFeaturedSection ? .fixed(0) : .fixed(20)
           
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 10
            section.contentInsets = sectionItem.isFeaturedSection ? NSDirectionalEdgeInsets(top: 20, leading: 5.0, bottom: 20, trailing: 5.0) : .zero
            
            // section header
            if !sectionItem.isFeaturedSection{
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: CollectionViewElementKind.sectionHeaderElementKind, alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            //section background
            let decoration = NSCollectionLayoutDecorationItem.background(elementKind: CollectionViewElementKind.sectionBackgroundElementKind)
            decoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.decorationItems = [decoration]
            return section
    
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        layout.register(BackgroundView.self, forDecorationViewOfKind: CollectionViewElementKind.sectionBackgroundElementKind)
        return layout
    }
}

extension ViewController{
   
    func configureDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<AppStoreItemController.AppStoreItemSection, AppStoreItemController.AppStoreItem>(collectionView: collectionView, cellProvider: { (collectionView : UICollectionView, indexPath: IndexPath, storeItem: AppStoreItemController.AppStoreItem) -> UICollectionViewCell? in
            let section = self.currentSnapShot.sectionIdentifiers[indexPath.section]
            if section.isFeaturedSection{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppStoreFeatureCell.cellIdentifier, for: indexPath) as? AppStoreFeatureCell else{
                    fatalError("cell not registered")

                }
                let item = self.dataSource.itemIdentifier(for: indexPath)!
                cell.configure(with: item)
                return cell
            }else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppStoreItemCell.identifier, for: indexPath) as? AppStoreItemCell else{
                    fatalError("cell not registered")

                }
                let item = self.dataSource.itemIdentifier(for: indexPath)!
                cell.configure(with: item, indexPath: indexPath)
                return cell
            }
            
        })
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            let section = self.currentSnapShot.sectionIdentifiers[indexPath.section]
            switch kind {
            case CollectionViewElementKind.sectionHeaderElementKind:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: CollectionViewElementKind.sectionHeaderElementKind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as?  SectionHeaderView else{
                    fatalError("Cannot create new supplementary")
                }
               
                headerView.lblTitle.text = section.title
                headerView.lblDescription.text = section.subtitle
                return headerView
            default:
                return nil
            }
            
        }
        
        currentSnapShot = NSDiffableDataSourceSnapshot<AppStoreItemController.AppStoreItemSection, AppStoreItemController.AppStoreItem>()
        
        storeController.collections.forEach{
            let collection = $0
            currentSnapShot.appendSections([collection])
            currentSnapShot.appendItems(collection.items)
        }
        
        dataSource.apply(currentSnapShot,animatingDifferences: false)
    }
}
