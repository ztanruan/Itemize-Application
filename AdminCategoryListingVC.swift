//
//  AdminCategoryListingVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 17/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AdminCategoryListingVC: UIViewController {

    var arrData = [[String: Any]]()
    var selectedIddd = ""
    var screenFrom = ScreenType.none
    var ref: DatabaseReference!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbl_noData: UILabel!
    @IBOutlet weak var btn_Done: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Done.isHidden = true
        self.lbl_noData.isHidden = true
        ref = Database.database().reference()
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Done.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Done.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if self.screenFrom == ScreenType.is_AdminCategory {
            self.btn_Done.isHidden = true
            self.lbl_Title.text = "Category"
            self.lbl_noData.text = "No Category Available\n\nplease press on plus sign and add new category"
            self.getCategoryFromfirebase()
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryType {
            self.btn_Done.isHidden = true
            self.lbl_Title.text = "Type"
            self.lbl_noData.text = "No Type Available\n\nplease press on plus sign and add new type in this selected category"
            self.getCategoryTypeFromfirebase()
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
            self.btn_Done.isHidden = true
            self.lbl_Title.text = "Brand"
            self.lbl_noData.text = "No Brand Available\n\nplease press on plus sign and add new brand in this selected type"
            self.getCategoryTypeBrandFromfirebase()
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
            self.btn_Done.isHidden = false
            self.lbl_Title.text = "Location"
            self.lbl_noData.text = "No Location Available\n\nplease press on plus sign and add new location in this selected brand"
            self.getCategory_Type_Brand_LocationFromfirebase()
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("CATEGORYDATAREFRESHNOTIFICATION"), object: nil, queue: nil) { (notification) in
            if self.screenFrom == ScreenType.is_AdminCategory {
                self.getCategoryFromfirebase()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryType {
                self.getCategoryTypeFromfirebase()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
                self.getCategoryTypeBrandFromfirebase()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
                self.getCategory_Type_Brand_LocationFromfirebase()
            }
        }
    }
    

    func getCategoryFromfirebase() {
        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllCategoryListFromFirebaseStorage { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arrData = dataaa
                }
                self.lbl_noData.isHidden = self.arrData.count == 0 ? false : true
                self.tblView.reloadData()
            }
        }
    }
    
    //For Type
    func getCategoryTypeFromfirebase() {
        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllCategoryTypeListFromFirebaseStorage(cat_iddd: self.selectedIddd) { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arrData = dataaa
                }
                self.lbl_noData.isHidden = self.arrData.count == 0 ? false : true
                self.tblView.reloadData()
            }
        }
    }
       
    //For Brand
    func getCategoryTypeBrandFromfirebase() {

        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllCategoryTypeBrandListFromFirebaseStorage { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arrData = dataaa
                }
                self.lbl_noData.isHidden = self.arrData.count == 0 ? false : true
                self.tblView.reloadData()
            }
        }
    }
    
    //For location
    func getCategory_Type_Brand_LocationFromfirebase() {

        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllCategoryTypeBrand_LocationListFromFirebaseStorage { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arrData = dataaa
                }
                self.lbl_noData.isHidden = self.arrData.count == 0 ? false : true
                self.tblView.reloadData()
            }
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
    
    
    //MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd_Action(_ sender: UIButton) {
        let objAdd = Story_Main.instantiateViewController(withIdentifier: "AddCatTypeBrandDetailsVC") as! AddCatTypeBrandDetailsVC
        objAdd.screenFrom = self.screenFrom
        objAdd.selectedID = self.selectedIddd
        self.navigationController?.pushViewController(objAdd, animated: true)
    }
    
    @IBAction func btnDone_Action(_ sender: UIButton) {
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: AdminVC.self) {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }

}

//MARK: - UITableview Delegate Datasource Method
extension AdminCategoryListingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CatTypeBranListingTableCell = tableView.dequeueReusableCell(withIdentifier: "CatTypeBranListingTableCell", for: indexPath) as! CatTypeBranListingTableCell
        cell.selectionStyle = .none
        
        let dic = self.arrData[indexPath.row]
        cell.lbl_Title.text = dic["title"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.tblView.beginUpdates()
            let idddd = self.arrData[indexPath.row]["id"] as? String ?? ""
            self.arrData.remove(at: indexPath.row)
            self.tblView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.lbl_noData.isHidden = self.arrData.count == 0 ? false : true
            self.tblView.endUpdates()
            
            if self.screenFrom == ScreenType.is_AdminCategory {
                self.ref.child("category").child(idddd).removeValue()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryType {
                let catidddddd = appDelegate.dic_valueforAddCatInAdmin["category_id"] as? String ?? ""
                self.ref.child("category").child(catidddddd).child("types").child(idddd).removeValue()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
                let catidddddd = appDelegate.dic_valueforAddCatInAdmin["category_id"] as? String ?? ""
                let typedddddd = appDelegate.dic_valueforAddCatInAdmin["type_id"] as? String ?? ""
                self.ref.child("category").child(catidddddd).child("types").child(typedddddd).child("brand").child(idddd).removeValue()
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
                let catidddddd = appDelegate.dic_valueforAddCatInAdmin["category_id"] as? String ?? ""
                let typedddddd = appDelegate.dic_valueforAddCatInAdmin["type_id"] as? String ?? ""
                let branddddddd = appDelegate.dic_valueforAddCatInAdmin["brand_id"] as? String ?? ""
                self.ref.child("category").child(catidddddd).child("types").child(typedddddd).child("brand").child(branddddddd).child("location").child(idddd).removeValue()
            }
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strValue = self.arrData[indexPath.row]["id"] as? String ?? ""
        
        if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
            appDelegate.dic_valueforAddCatInAdmin["location_id"] = strValue
        }
        else {
            let objType = Story_Main.instantiateViewController(withIdentifier: "AdminCategoryListingVC") as! AdminCategoryListingVC
            objType.selectedIddd = self.arrData[indexPath.row]["id"] as? String ?? ""
            
            if self.screenFrom == ScreenType.is_AdminCategory {
                appDelegate.dic_valueforAddCatInAdmin.removeAll()
                objType.screenFrom = ScreenType.is_AdminCategoryType
                appDelegate.dic_valueforAddCatInAdmin["category_id"] = strValue
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryType {
                objType.screenFrom = ScreenType.is_AdminCategoryTypeBrand
                appDelegate.dic_valueforAddCatInAdmin["type_id"] = strValue
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
                objType.screenFrom = ScreenType.is_AdminCategoryTypeBrandLocation
                appDelegate.dic_valueforAddCatInAdmin["brand_id"] = strValue
            }
            else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
                appDelegate.dic_valueforAddCatInAdmin["location_id"] = strValue
            }
            self.navigationController?.pushViewController(objType, animated: true)
        }
    }
}


// MARK: - UITable View Cell
class CatTypeBranListingTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_Title: UILabel!
}
