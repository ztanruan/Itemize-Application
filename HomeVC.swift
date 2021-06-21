//
//  HomeVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 23/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, UITextFieldDelegate {

    var arr_Data = [[String: Any]]()
    var arr_SearchData = [[String: Any]]()
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var lbl_NoData: UILabel!
    @IBOutlet weak var view_NoData: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txt_Search.delegate = self
        self.view_NoData.isHidden = true
        self.txt_Search.addDoneToolbar()
        let strNoDataText = "Opps ! Looks like your item list is empty, Please hit the add button to add all your valuable items !"
        self.txt_Search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        //For Attribute Text
        let newText1 = NSMutableAttributedString.init(string: strNoDataText)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = .center
        paragraphStyle1.lineSpacing = 4
        newText1.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.init(name: "Optima-Regular", size: 15)!,
                             range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle1, range: NSRange.init(location: 0, length: newText1.length))
        self.lbl_NoData.attributedText = newText1
        
        
        self.manageSection()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("ITEMADDEDANFREFRESHHOMESCREENNOTIFICATION"), object: nil, queue: nil) { (notification) in
            self.manageSection()
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
    
    func searchItemList(_ strSearchText: String) {
        if strSearchText == "" {
            self.arr_Data = self.arr_SearchData
            self.view_NoData.isHidden = self.arr_Data.count == 0 ? false : true
            self.collectionView.reloadData()
        }
        else {
            var is_added = false
            var arrSearchData = [[String: Any]]()
            for dicItem in self.arr_SearchData {
                let strItmTitle = dicItem["category"] as? String ?? ""
                let strItmsubTitle = dicItem["brand"] as? String ?? ""
                if((strItmTitle.range(of: strSearchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)) != nil) {
                    is_added = true
                    arrSearchData.append(dicItem)
                }
                
                if((strItmsubTitle.range(of: strSearchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)) != nil) {
                    if is_added == false {
                        arrSearchData.append(dicItem)
                    }
                }
            }
            self.arr_Data = arrSearchData
            self.view_NoData.isHidden = self.arr_Data.count == 0 ? false : true
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - UITextField Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let str_text = textField.text {
            self.searchItemList(str_text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

}

//MARK: - UICollectionView Delegate Datasource Method
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func manageSection() {
        
        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetAllItemListFromFirebaseStorage(GetUserID()) { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arr_Data = dataaa
                    self.arr_SearchData = dataaa
                }
                appDelegate.int_TotalItem = self.arr_Data.count
                self.view_NoData.isHidden = self.arr_Data.count == 0 ? false : true
                self.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_Data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: collectionItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionItemCell", for: indexPath) as! collectionItemCell
        cell.img_Center.contentMode = .scaleAspectFill
        
        let dic = self.arr_Data[indexPath.row]
        cell.lbl_subTitle.textColor = .black
        
        cell.lbl_Title.text = dic["category"] as? String ?? ""
        cell.lbl_subTitle.text = dic["brand"] as? String ?? ""
        
        let strImg = dic["brand_image"] as? String ?? ""
        if strImg != "" {
            cell.img_Center.kf.setImage(with: URL(string: strImg))
            //cell.img_Center.sd_setImage(with: URL(string: strImg), placeholderImage: nil)
        }
        else {
            cell.img_Center.image = #imageLiteral(resourceName: "car")
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (UIScreen.main.bounds.width - 36)/2
        return CGSize.init(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dicDetail = self.arr_Data[indexPath.row]
        if let parent = appDelegate.window?.rootViewController {
            let objDetail = itemDetailVC(nibName:"itemDetailVC", bundle:nil)
            objDetail.dic_Detail = dicDetail
            parent.addChild(objDetail)
            objDetail.view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            parent.view.addSubview((objDetail.view)!)
            objDetail.didMove(toParent: parent)
        }
    }
}
