//
//  itemDetailVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 10/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Alamofire

class itemDetailVC: UIViewController {

    var arrImages = [UIImage]()
    var dic_Detail = [String: Any]()
    var imgViewww = UIImageView()
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Brand: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Purchase_date: UILabel!
    @IBOutlet weak var lbl_SerialNumber: UILabel!
    @IBOutlet weak var lbl_PriceRange: UILabel!
    @IBOutlet weak var lbl_Insurance: UILabel!
    @IBOutlet weak var gender_segment: UISegmentedControl!
    @IBOutlet weak var view_MainBG: UIView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var btn_Share: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDetail()
        self.view_MainBG.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.perform(#selector(show_animation), with: nil, afterDelay: 0.1)
        
        //Register Collection Cell====================================================//
        self.collectionView.register(UINib(nibName: "ItemDetailCollectionCell", bundle: .main), forCellWithReuseIdentifier: "ItemDetailCollectionCell")
        //=======================================================================//
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.takeScreenshot(false) { (imgggggggg) in
                if let img = imgggggggg {
                    self.arrImages.insert(img, at: 0)
                }
            }
        })
    }
    
    @objc func show_animation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_MainBG.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.layoutIfNeeded()
        }) { (success) in
        }
    }
    
    func setDetail() {
        self.lbl_Category.text = self.dic_Detail["category"] as? String ?? ""
        self.lbl_Brand.text = self.dic_Detail["brand"] as? String ?? ""
        self.lbl_Type.text = self.dic_Detail["type"] as? String ?? ""
        self.lbl_Location.text = self.dic_Detail["location"] as? String ?? ""
        self.lbl_Purchase_date.text = self.dic_Detail["purchase_date"] as? String ?? ""
        self.lbl_SerialNumber.text = self.dic_Detail["serial_number"] as? String ?? ""
        self.lbl_PriceRange.text = self.dic_Detail["price_range"] as? String ?? ""
        self.lbl_Insurance.text = self.dic_Detail["insurance"] as? String ?? "No"
        let strGender = self.dic_Detail["gender"] as? String ?? ""
        if strGender.lowercased() == "m" {
            self.gender_segment.selectedSegmentIndex = 1
        }
        else {
            self.gender_segment.selectedSegmentIndex = 0
        }
        
        let arr_Image = self.dic_Detail["item_image"] as? [Any] ?? []
        if arr_Image.count == 0 {
            self.btn_Next.isHidden = true
            self.pagecontrol.numberOfPages = 1
        }
        else {
            self.arrImages.removeAll()
            self.btn_Next.isHidden = false
            self.pagecontrol.numberOfPages = 2

            if arr_Image.count != 0 {
                if let img_string = arr_Image.first as? String {
                    self.downloadddImageFromUrl(img_string) { (imgggg) in
                        self.arrImages.append(imgggg)
                        self.downloadImage(arr_Image)
                    }
                }
            }
    
        
            
            
//            for img in arr_Image {
//                if let str_Img = img as? String {
//                    if let url = URL.init(string: str_Img) {
//                        self.imgViewww.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "car"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false) { (imageeeee) in
//                            if let imgg = imageeeee.value {
//                                self.arrImages.append(imgg)
//                            }
//                        }
//                    }
//                }
//            }
        }
        self.collectionView.reloadData()
    }
    
    func downloadImage(_ arr_Image: [Any]) {
        if arr_Image.count != 0 {
            var arrImageURL = arr_Image
            arrImageURL.remove(at: 0)
            if arrImageURL.count != 0 {
                if let img_string = arrImageURL.first as? String {
                    self.downloadddImageFromUrl(img_string) { (imgggg) in
                        self.arrImages.append(imgggg)
                        self.downloadImage(arrImageURL)
                    }
                }
            }
        }
    }
    
    func downloadddImageFromUrl(_ str_Img: String, completion:@escaping (UIImage)->Void) {
        if let url = URL.init(string: str_Img) {
            self.imgViewww.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "car"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false) { (imageeeee) in
                if let imgg = imageeeee.value {
                    completion(imgg)
                }
            }
        }
    }
    
    
    func clkToClose() {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view_MainBG.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    func takeScreenshot(_ shouldSave: Bool, completion:@escaping (UIImage?)->Void)  {
        var screenshotImage :UIImage?
        let layer = self.view_MainBG.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return completion(nil)}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        completion(screenshotImage)
    }
    
    
    
    
    
    func imageShareFromShareContent(is_Image: Bool, strShareDetail: String) {

        let activityViewController = UIActivityViewController(activityItems: self.arrImages, applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        //activityViewController.popoverPresentationController?.sourceView = (self.view_navigationBar.btn_MapListing)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToWeibo,
                                                        UIActivity.ActivityType.print,
                                                        UIActivity.ActivityType.assignToContact,
                                                        UIActivity.ActivityType.saveToCameraRoll,
                                                        UIActivity.ActivityType.addToReadingList,
                                                        UIActivity.ActivityType.postToFlickr,
                                                        UIActivity.ActivityType.postToVimeo,
                                                        UIActivity.ActivityType.postToWeibo]
        appDelegate.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    

    // MARK: - UIButton Action
    @IBAction func btnclose_Action(_ sender: UIButton) {
        self.clkToClose()
    }
    
    @IBAction func btnshare_Action(_ sender: UIButton) {
        if self.pagecontrol.currentPage == 0 {
            //Detail Share
            let str_cat = self.dic_Detail["category"] as? String ?? ""
            let str_brand = self.dic_Detail["brand"] as? String ?? ""
            let str_type = self.dic_Detail["type"] as? String ?? ""
            let str_location = self.dic_Detail["location"] as? String ?? ""
            let strPurchaseDate = self.dic_Detail["purchase_date"] as? String ?? ""
            let str_serialNumber = self.dic_Detail["serial_number"] as? String ?? ""
            let str_pricerange = self.dic_Detail["price_range"] as? String ?? ""
            let str_insurance = self.dic_Detail["insurance"] as? String ?? "No"
            var strGender = self.dic_Detail["gender"] as? String ?? ""
            if strGender.lowercased() == "m" {
                strGender = "Male"
            }
            else {
                strGender = "Female"
            }
            
            
            let shareContent = "ITEM INFORMATION\n\nCategory: \(str_cat)\nBrand: \(str_brand)\nType: \(str_type)\nLocation: \(str_location)\nPurchase Date: \(strPurchaseDate)\nSerial number: \(str_serialNumber)\nPrice Range: \(str_pricerange)\nInsurance: \(str_insurance)\nGender: \(strGender)"
            self.imageShareFromShareContent(is_Image: false, strShareDetail: shareContent)
        }
        else {
            //Image Share
            self.imageShareFromShareContent(is_Image: true, strShareDetail: "")
        }
    }
    
    @IBAction func btnnext_Action(_ sender: UIButton) {
        if self.pagecontrol.currentPage == 0 {
            self.collectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        else {
            self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
}


//MARK: - UICollectionView Delegate Datasource Method
extension itemDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CHANGING PAGE NUMBER
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect.init(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint.init(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleindex = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pagecontrol.currentPage = visibleindex.row
            if visibleindex.row == 1 {
                self.btn_Next.setTitle("Prev", for: UIControl.State.normal)
            }
            else {
                self.btn_Next.setTitle("Next", for: UIControl.State.normal)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr_Image = self.dic_Detail["item_image"] as? [Any] ?? []
        if arr_Image.count == 0 {
            return 1
        }
        else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ItemDetailCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailCollectionCell", for: indexPath) as! ItemDetailCollectionCell
        cell.lbl_Category.text = self.dic_Detail["category"] as? String ?? ""
        cell.lbl_Brand.text = self.dic_Detail["brand"] as? String ?? ""
        cell.lbl_Type.text = self.dic_Detail["type"] as? String ?? ""
        cell.lbl_Location.text = self.dic_Detail["location"] as? String ?? ""
        cell.lbl_Purchase_date.text = self.dic_Detail["purchase_date"] as? String ?? ""
        cell.lbl_SerialNumber.text = self.dic_Detail["serial_number"] as? String ?? ""
        cell.lbl_PriceRange.text = self.dic_Detail["price_range"] as? String ?? ""
        cell.lbl_Insurance.text = self.dic_Detail["insurance"] as? String ?? "No"
        let str_BrandImg = self.dic_Detail["brand_image"] as? String ?? ""
        let arr_Image = self.dic_Detail["item_image"] as? [Any] ?? []
        cell.arr_ItemImageData = arr_Image
        cell.collection_imageView.reloadData()
        let strGender = self.dic_Detail["gender"] as? String ?? ""
        if strGender.lowercased() == "m" {
            cell.gender_segment.selectedSegmentIndex = 1
        }
        else {
            cell.gender_segment.selectedSegmentIndex = 0
        }
        
        if str_BrandImg != "" {
            cell.img_Header.kf.setImage(with: URL(string: str_BrandImg))
            //cell.img_Header.sd_setImage(with: URL(string: str_BrandImg), placeholderImage: nil)
        }
        else {
            cell.img_Header.image = #imageLiteral(resourceName: "car")
        }
        
        if indexPath.row == 0 {
            cell.view_imageBG.isHidden = true
            cell.gender_segment.isHidden = false
            cell.lbl_Title.text = "ITEM INFORMATION"
        }
        else {
            cell.view_imageBG.isHidden = false
            cell.gender_segment.isHidden = true
            cell.lbl_Title.text = "DEVICE IMAGES"
            cell.collection_imageView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
