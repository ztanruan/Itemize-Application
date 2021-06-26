//
//  ConfirmationInfoVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 01/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase

class ConfirmationInfoVC: UIViewController {

    var selectedIndex = 0
    var arr_Image = [Any]()
    var ref: DatabaseReference!
    var arr_UploadedImageURl = [String]()
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Brand: UIImageView!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_Brand: UILabel!
    @IBOutlet weak var lbl_Type: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Purchase_date: UILabel!
    @IBOutlet weak var lbl_SerialNumber: UILabel!
    @IBOutlet weak var lbl_PriceRange: UILabel!
    @IBOutlet weak var collectionImageView: UICollectionView!
    @IBOutlet weak var gender_segment: UISegmentedControl!
    @IBOutlet weak var view_InfoBG: UIView!
    @IBOutlet weak var view_ImageBg: UIView!
    @IBOutlet weak var lbl_buttonTitle: UILabel!
    @IBOutlet weak var constraint_viewCenterX: NSLayoutConstraint!
    @IBOutlet weak var constraint_viewImgCenterX: NSLayoutConstraint!
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_ImageBg.isHidden = true
        self.btn_Continue.cornerRadius = 5
        ref = Database.database().reference()
        self.arr_UploadedImageURl.removeAll()
        self.constraint_viewImgCenterX.constant = screenWidth
        self.arr_Image = [#imageLiteral(resourceName: "bmw_logo_PNG19707"), #imageLiteral(resourceName: "Family"), #imageLiteral(resourceName: "Private"), #imageLiteral(resourceName: "mazda-logo-png-8"), #imageLiteral(resourceName: "audi-logo-png-1920x1080-hd-1080p-1920"), #imageLiteral(resourceName: "bmw_logo_PNG19707")]
        self.lbl_Category.text = appDelegate.dic_ValueforRegisterItem["category"] as? String ?? ""
        self.lbl_Brand.text = appDelegate.dic_ValueforRegisterItem["brand"] as? String ?? ""
        self.lbl_Type.text = appDelegate.dic_ValueforRegisterItem["type"] as? String ?? ""
        self.lbl_Location.text = appDelegate.dic_ValueforRegisterItem["location"] as? String ?? ""
        self.lbl_Purchase_date.text = appDelegate.dic_ValueforRegisterItem["purchase_date"] as? String ?? ""
        self.lbl_SerialNumber.text = appDelegate.dic_ValueforRegisterItem["serial_number"] as? String ?? ""
        self.lbl_PriceRange.text = appDelegate.dic_ValueforRegisterItem["price_range"] as? String ?? ""
        let strGender = appDelegate.dic_ValueforRegisterItem["gender"] as? String ?? ""
        if strGender == "M" {
            self.gender_segment.selectedSegmentIndex = 1
        }
        else {
            self.gender_segment.selectedSegmentIndex = 0
        }
        self.arr_Image = appDelegate.dic_ValueforRegisterItem["item_image"] as? [Any] ?? []
        
        if self.arr_Image.count == 0 {
            self.lbl_buttonTitle.text = "Save"
        }
        
        let str_image = appDelegate.dic_ValueforRegisterItem["brand_image"] as? String ?? ""
        if str_image != "" {
            self.img_Brand.kf.setImage(with: URL(string: str_image))
            //self.img_Brand.sd_setImage(with: URL(string: str_image), placeholderImage: nil)
        }
        
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Continue.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Continue.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        self.collectionImageView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func ImageUpload_onFirebaseStorage(_ img: UIImage, arr_imgs: [Any]) {
        var dueImage = arr_imgs
        if let uploadImgData = img.jpegData(compressionQuality: 0.25) {
            let storageRef = Storage.storage().reference().child("item_image").child("\(randomString()).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            storageRef.putData(uploadImgData, metadata: metadata) { [weak self] (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                guard self != nil else { return }
                storageRef.downloadURL(completion: { (url, error) in
                    if let strImgurl = url?.absoluteString {
                        dueImage.remove(at: 0)
                        self?.arr_UploadedImageURl.append(strImgurl)
                        debugPrint("Upload Image URL======>>\(url?.absoluteString ?? "")")
                        
                        if dueImage.count != 0 {
                            if let fstimg = dueImage.first as? UIImage {
                                self?.ImageUpload_onFirebaseStorage(fstimg, arr_imgs: dueImage)
                            }
                        }
                        else {
                            DismissProgressHud()
                            appDelegate.dic_ValueforRegisterItem["item_image"] = self?.arr_UploadedImageURl
                            self?.saveDatainDatabase()
                        }
                    }
                    
                })
            }
        }
    }
    

    // MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        if self.selectedIndex == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.selectedIndex = 0
                self.view_ImageBg.isHidden = true
                self.lbl_buttonTitle.text = "Continue"
                self.constraint_viewImgCenterX.constant = screenWidth
            }) { (suceess) in
            
            }
        }
    }
    
    @IBAction func btnContinue_Action(_ sender: UIButton) {
        if self.arr_Image.count == 0 {
            appDelegate.dic_ValueforRegisterItem.removeValue(forKey: "item_image")
            self.saveDatainDatabase()
        }
        else {
            if self.selectedIndex == 0 {
                UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.view_ImageBg.isHidden = false
                    self.lbl_buttonTitle.text = "Save"
                    self.selectedIndex = self.selectedIndex + 1
                    self.constraint_viewImgCenterX.constant = 0
                }) { (success) in
                }
            }
            else {
                if self.arr_Image.count != 0 {
                    self.arr_UploadedImageURl.removeAll()
                    if let fstImg = self.arr_Image.first as? UIImage {
                        ShowProgressHud(message: AppMessage.plzWait)
                        self.ImageUpload_onFirebaseStorage(fstImg, arr_imgs: self.arr_Image)
                    }
                }
                else {
                    appDelegate.dic_ValueforRegisterItem.removeValue(forKey: "item_image")
                    self.saveDatainDatabase()
                }
            }
        }
    }
    
    func saveDatainDatabase() {
        self.ref.child("item_list").child(GetUserID()).childByAutoId().updateChildValues(appDelegate.dic_ValueforRegisterItem)
        let objCongo = Story_Main.instantiateViewController(withIdentifier: "CongratsVC") as! CongratsVC
        self.navigationController?.pushViewController(objCongo, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name.init("ITEMADDEDANFREFRESHHOMESCREENNOTIFICATION"), object: nil)
    }
    
}

//MARK: - UICollectionView Delegate Datasource Method
extension ConfirmationInfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_Image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        if let img = self.arr_Image[indexPath.row] as? UIImage {
            cell.img_Center.image = img
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen_Width = (screenWidth * 0.87)/3
        return CGSize.init(width: screen_Width, height: screen_Width)
    }
    
}
