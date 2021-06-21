//
//  ItemImageCollectionCell.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 10/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class ItemImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_inner: UIView!
    @IBOutlet weak var img_Center: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view_Base.layer.cornerRadius = 12
        self.view_inner.layer.cornerRadius = 12
        self.img_Center.layer.cornerRadius = 12
    }


}
