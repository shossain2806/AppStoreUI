//
//  BackgroundView.swift
//  AppStoreUI
//
//  Created by Md. Saber Hossain on 30/1/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class BackgroundView: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension BackgroundView{
    func configure(){
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .opaqueSeparator
        addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 0.5),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
