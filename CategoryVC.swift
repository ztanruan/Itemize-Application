//
//  CategoryVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 29/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CategoryVC: UIViewController {

    var strType = ""
    var strCategory = ""
    var selfScreen = ""
    var selectedIndexForCategory = 0
    var selectedIndexForType = 0
    var arrData = [[String: Any]]()
    var screenFrom = ScreenType.none
    var ref: DatabaseReference!
    var selectedDic = [String: Any]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.btn_Continue.cornerRadius = 5
        self.lbl_Title.text = "CATEGORY"
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Continue.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Continue.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        
        //Data
        if self.screenFrom == ScreenType.is_TypesScreen {
            self.lbl_Title.text = "TYPE"
            self.selfScreen = "Type_List"
            self.collectionView.reloadData()
        }
        else if self.screenFrom == ScreenType.is_brandScreen {
            self.lbl_Title.text = "BRAND"
            self.selfScreen = "Brand_List"
            self.collectionView.reloadData()
        }
        else if self.screenFrom == ScreenType.is_locationScreen {
            self.lbl_Title.text = "LOCATION"
            self.selfScreen = "Location_List"
            self.collectionView.reloadData()
        }
        else {
            //self.manageSection()
            self.getCategoryData()
            self.selfScreen = "Category_list"
            appDelegate.dic_ValueforRegisterItem.removeAll()
        }
    }
    
    func getCategoryData() {
        if UserDefaults.appObjectForKey(AppMessage.category) != nil {
            let data = UserDefaults.appObjectForKey(AppMessage.category) as! Data
            if let arr_cat = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String: Any]] {
                self.arrData = arr_cat
                self.getCategoryFromfirebase(false)
            }
            else {
                self.getCategoryFromfirebase(true)
            }
        }
        else {
            self.getCategoryFromfirebase(true)
        }
    }
    
    func getCategoryFromfirebase(_ animate: Bool) {
        if animate {
            ShowProgressHud(message: AppMessage.plzWait)
        }
        FirebaseManager.shared.GetAllCategoryListFromFirebaseStorage { (data) in
            DismissProgressHud()
            if let dataaa = data {
                self.arrData = dataaa
                UserDefaults.appSetObject(NSKeyedArchiver.archivedData(withRootObject: dataaa), forKey: AppMessage.category)
            }
            self.collectionView.reloadData()
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

    // MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: UIControl) {
        let stTitleee = "Category"
        if self.selfScreen == "Category_list" {
            if self.selectedDic.count == 0 {
                showSingleAlert(Title: stTitleee, Message: "Please select one option", buttonTitle: AppMessage.Ok, delegate: self) { }
                return
            }
            else {
                let strCategory_name = self.selectedDic["title"] as? String ?? ""
                appDelegate.dic_ValueforRegisterItem["category"] = strCategory_name
                appDelegate.dic_ValueforRegisterItem["cat_id"] = self.selectedDic["id"] as? String ?? ""

                ShowProgressHud(message: AppMessage.plzWait)
                FirebaseManager.shared.getTypeListFromCategoryFromfirebase(self.selectedDic["id"] as? String ?? "") { (data) in
                    DismissProgressHud()
                    if let dataaa = data {
                        let objCategory = Story_Main.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                        objCategory.arrData = dataaa
                        objCategory.screenFrom = ScreenType.is_TypesScreen
                        self.navigationController?.pushViewController(objCategory, animated: true)
                    }
                    else {
                        showSingleAlert(Title: "", Message: "Type not found", buttonTitle: AppMessage.Ok, delegate: self) { }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
        else if self.selfScreen == "Type_List" {
            if self.selectedDic.count == 0 {
                showSingleAlert(Title: "Tpye", Message: "Please select one option", buttonTitle: AppMessage.Ok, delegate: self) { }
                return
            }
            else {
                let strType_name = self.selectedDic["title"] as? String ?? ""
                appDelegate.dic_ValueforRegisterItem["type"] = strType_name
                appDelegate.dic_ValueforRegisterItem["type_id"] = self.selectedDic["id"] as? String ?? ""

                ShowProgressHud(message: AppMessage.plzWait)
                FirebaseManager.shared.getBrandListFromCategoryFromfirebase(appDelegate.dic_ValueforRegisterItem["cat_id"] as? String ?? "", type_id: self.selectedDic["id"] as? String ?? "") { (data) in
                    DismissProgressHud()
                    if let dataaa = data {
                        let objCategory = Story_Main.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                        objCategory.arrData = dataaa
                        objCategory.screenFrom = ScreenType.is_brandScreen
                        self.navigationController?.pushViewController(objCategory, animated: true)
                    }
                    else {
                        showSingleAlert(Title: "", Message: "Brand not found", buttonTitle: AppMessage.Ok, delegate: self) { }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
        else if self.selfScreen == "Brand_List" {
            if self.selectedDic.count == 0 {
                showSingleAlert(Title: "Brand", Message: "Please select one option", buttonTitle: AppMessage.Ok, delegate: self) { }
                return
            }
            else {
                let strBrand_name = self.selectedDic["title"] as? String ?? ""
                let strBrand_Image = self.selectedDic["image"] as? String ?? ""
                appDelegate.dic_ValueforRegisterItem["brand"] = strBrand_name
                appDelegate.dic_ValueforRegisterItem["brand_image"] = strBrand_Image
                appDelegate.dic_ValueforRegisterItem["brand_id"] = self.selectedDic["id"] as? String ?? ""

                ShowProgressHud(message: AppMessage.plzWait)
                FirebaseManager.shared.getLocationListFromCategoryFromfirebase(appDelegate.dic_ValueforRegisterItem["cat_id"] as? String ?? "", typeid: appDelegate.dic_ValueforRegisterItem["type_id"] as? String ?? "", brandid: self.selectedDic["id"] as? String ?? "") { (data) in
                    DismissProgressHud()
                    if let dataaa = data {
                        let objCategory = Story_Main.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                        objCategory.arrData = dataaa
                        objCategory.screenFrom = ScreenType.is_locationScreen
                        self.navigationController?.pushViewController(objCategory, animated: true)
                    }
                    else {
                        showSingleAlert(Title: "", Message: "Location not found", buttonTitle: AppMessage.Ok, delegate: self) { }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
        else if self.selfScreen == "Location_List" {
            if self.selectedDic.count == 0 {
                showSingleAlert(Title: "Location", Message: "Please select one option", buttonTitle: AppMessage.Ok, delegate: self) { }
                return
            }
            else {
                let strType_name = self.selectedDic["title"] as? String ?? ""
                appDelegate.dic_ValueforRegisterItem["location"] = strType_name
                let objInfo = Story_Main.instantiateViewController(withIdentifier: "ItemInfoFirstSecondPartVC") as! ItemInfoFirstSecondPartVC
                objInfo.screenFrom = ScreenType.is_firstInfo
                self.navigationController?.pushViewController(objInfo, animated: true)
            }
        }
    }
        
}

//MARK: - UICollectionView Delegate Datasource Method
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: collectionItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionItemCell", for: indexPath) as! collectionItemCell
        cell.img_Center.contentMode = .scaleAspectFill
        
        let dic = self.arrData[indexPath.row]
        
        let strid = dic["id"] as? String ?? ""
        let str_Title = dic["title"] as? String ?? ""
        let str_ImgItem = dic["image"] as? String ?? ""
        cell.lbl_Title.text = dic["title"] as? String ?? ""
        cell.lbl_subTitle.text = dic["sub_title"] as? String ?? ""
        cell.img_Center.image =  dic["image"] as? UIImage ?? #imageLiteral(resourceName: "car")
        
        cell.constraint_lblHeight?.constant = 39
        let height = estimatedHeightOfLabel(text: str_Title)
        print("Label Height=======>>\(height)")
        if 40 > height {
            //cell.constraint_lblHeight?.constant = height
        }
        
        if str_ImgItem != "" {
            cell.img_Center.kf.setImage(with: URL(string: str_ImgItem))
            //cell.img_Center.sd_setImage(with: URL(string: str_ImgItem), placeholderImage: nil)
        }
        
        

        let cat_id = self.selectedDic["id"] as? String ?? ""
        if cat_id == strid {
            cell.view_inner.layer.borderWidth = 2
            cell.view_inner.layer.borderColor = #colorLiteral(red: 0.8196078431, green: 0.08235294118, blue: 0.5960784314, alpha: 1)
        }
        else {
            cell.view_inner.layer.borderWidth = 0
            cell.view_inner.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (UIScreen.main.bounds.width - 36)/2
        return CGSize.init(width: screenWidth, height: screenWidth)
    }
    
    
    func ImageUpload_onFirebaseStorage(_ img: UIImage, selectID: String, diccc: [String: Any]) {
        var dic_type = diccc
        if let uploadImgData = img.jpegData(compressionQuality: 0.25) {
            let storageRef = Storage.storage().reference().child("category_image").child("\(randomString()).png")
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
                        debugPrint("Upload Image URL======>>\(url?.absoluteString ?? "")")
                        dic_type["image"] = url?.absoluteString
                        //self?.ref.child("category").child(selectID).child("brand").childByAutoId().updateChildValues(dic_type)
                    }
                })
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = self.arrData[indexPath.row]
        self.selectedDic.removeAll()
        self.selectedDic["id"] = dic["id"] as? String ?? ""
        self.selectedDic["title"] = dic["title"] as? String ?? ""
        self.selectedDic["image"] = dic["image"] as? String ?? ""
        self.selectedIndexForCategory = indexPath.row
        self.strCategory = dic["title"] as? String ?? ""
        self.collectionView.reloadData()

        /*
        let dic_cat = self.arrData[indexPath.row]
        let arr_types = dic_cat["types"] as? [[String: Any]]
        let dic_tyes = arr_types?[indexPath.row]
        let arr_Brand = dic_tyes?["brand"] as? [[String: Any]]
        let dic_brandddddd = arr_Brand?[1]
        let arr_Location = dic_brandddddd?["location"] as? [[String: Any]]
        let dic_locationnnnnn = arr_Location?[indexPath.row]

        let dicccccccc = ["title": dic_brandddddd?["title"] as? String ?? "",
                          "sub_title": dic_brandddddd?["sub_title"] as? String ?? ""]
        if let img = dic_brandddddd?["image"] as? UIImage {
            //self.ImageUpload_onFirebaseStorage(img, selectID: dic["id"] as? String ?? "", diccc: dicccccccc)
        }
        */
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        let particularCellLabelWidth = ((screenWidth-36)/2) - 36
        let size = CGSize(width: particularCellLabelWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.init(name: "Optima-Regular", size: 16)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil).height
        return rectangleHeight.rounded()
    }
}

