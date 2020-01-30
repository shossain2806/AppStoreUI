//
//  AppStoreItemCell.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 30/1/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class AppStoreItemCell: UICollectionViewCell {
    static let identifier = "AppStoreItemCell"
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnGet: UIButton!
    @IBOutlet weak var lblInAppPurchase: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblInAppPurchase.isHidden = true
        lblTitle.text = nil
        lblDescription.text = nil
        imgViewIcon.image = nil
        seperatorView.isHidden = true
    }
       
    
    func configure(with item: AppStoreItemController.AppStoreItem, indexPath: IndexPath){
        lblTitle.text = item.title
        lblDescription.text = item.description
        if let imageName = item.imageURL{
             imgViewIcon.image = UIImage(named: imageName)
        }
        lblInAppPurchase.isHidden = !item.inAppPurchasable
        seperatorView.isHidden = !(indexPath.item % 2 == 0)
    }
}
