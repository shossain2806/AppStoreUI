//
//  AppStoreFeatureCell.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 22/1/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class AppStoreFeatureCell: UICollectionViewCell {
    
    static let cellIdentifier = "AppStoreFeatureCell"

    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewIcon.layer.cornerRadius = 6.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblHint.text = nil
        lblTitle.text = nil
        lblDescription.text = nil
        imgViewIcon.image = nil
    }
    
    func configure(with item: AppStoreItemController.AppStoreItem){
        lblHint.text = item.hint
        lblTitle.text = item.title
        lblDescription.text = item.description
        if let imageName = item.imageURL{
             imgViewIcon.image = UIImage(named: imageName)
        }
       
    }
}
