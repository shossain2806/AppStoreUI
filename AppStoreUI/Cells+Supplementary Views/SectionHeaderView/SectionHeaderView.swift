//
//  SectionHeaderView.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 4/2/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
        
    static let identifier = "SectionHeaderView"
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
}
