//
//  ItemDetailCollectionCell.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 10/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class ItemDetailCollectionCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var arr_Images = [Any]()
    @IBOutlet weak var img_Header: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Brand: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Purchase_date: UILabel!
    @IBOutlet weak var lbl_SerialNumber: UILabel!
    @IBOutlet weak var lbl_PriceRange: UILabel!
    @IBOutlet weak var lbl_Insurance: UILabel!
    @IBOutlet weak var gender_segment: UISegmentedControl!
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_innerView: UIView!
    
    @IBOutlet weak var view_imageBG: UIView!
    @IBOutlet weak var collection_imageView: UICollectionView!
    
    
    var arr_ItemImageData: [Any] = [] {
        didSet {
            self.arr_Images = arr_ItemImageData
            self.collection_imageView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collection_imageView.delegate = self
        self.collection_imageView.dataSource = self
        
        self.collection_imageView.register(UINib(nibName: "ItemImageCollectionCell", bundle: .main), forCellWithReuseIdentifier: "ItemImageCollectionCell")
    }
    
    //MARK: - UICollectionView Delegate Datasource Method

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_Images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ItemImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionCell", for: indexPath) as! ItemImageCollectionCell
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        if let str_img = self.arr_Images[indexPath.row] as? String {
            cell.img_Center.kf.setImage(with: URL(string: str_img))
            //cell.img_Center.sd_setImage(with: URL(string: str_img), placeholderImage: nil)
            
            
//            if let url = URL.init(string: str_img) {
//                cell.activityIndicator.startAnimating()
//                cell.img_Center.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "car"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false) { (imageeeee) in
                    cell.activityIndicator.stopAnimating()
//                    cell.img_Center.image = imageeeee.value
//                }
//            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }

}
