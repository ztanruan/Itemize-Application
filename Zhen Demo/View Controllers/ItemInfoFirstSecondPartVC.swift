//
//  ItemInfoFirstSecondPartVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 04/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class ItemInfoFirstSecondPartVC: UIViewController {

    var screenFrom = ScreenType.none
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_One: UITextField!
    @IBOutlet weak var txt_two: UITextField!
    @IBOutlet weak var txt_three: UITextField!
    @IBOutlet weak var view_One_Bg: UIView!
    @IBOutlet weak var view_two_Bg: UIView!
    @IBOutlet weak var view_three_Bg: UIView!
    @IBOutlet weak var img_thirdIcon: UIImageView!
    @IBOutlet weak var img_BrandImage: UIImageView!
    @IBOutlet weak var sement_control: UISegmentedControl!
    @IBOutlet weak var constraint_viewBottom: NSLayoutConstraint!
    var arrr_PriceRange = ["0 - 600", "600 - 1200", "1200 - 1800", "1800 - 2400", "2400 - 3000"]
    
    var purchasedatePicker = UIDatePicker()
    var didSelectedDate: ((UIDatePicker)->Void)? = nil
    
    var pricePicker = UIPickerView()
    var didSelectPriceRange: ((String?)->Void)? = nil
    var pickerDidEndPicking: ((UIPickerView)->Void)? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Continue.cornerRadius = 5
        self.lbl_Title.text = "INFORMATION"
        self.pricePicker.delegate = self
        self.pricePicker.dataSource = self
        self.view_One_Bg.backgroundColor = .white
        self.view_two_Bg.backgroundColor = .white
        self.view_three_Bg.backgroundColor = .white
        
        let str_image = appDelegate.dic_ValueforRegisterItem["brand_image"] as? String ?? ""
        if str_image != "" {
            self.img_BrandImage.contentMode = .scaleAspectFill
            self.img_BrandImage.kf.setImage(with: URL(string: str_image))
            //self.img_BrandImage.sd_setImage(with: URL(string: str_image), placeholderImage: nil)
        }
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Continue.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Continue.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        

        self.manageSection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userinfo:NSDictionary = (notification.userInfo as NSDictionary?) {
            if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let bottomSafeArea = appDelegate.window?.safeAreaInsets.bottom ?? 0
                let keyboardHeight = keybordsize.height - bottomSafeArea - 100
                self.constraint_viewBottom.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraint_viewBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Check Validation
    func checkInputValidationsForSecondStep() -> (Title:String,Message:String)? {
        let str_PurchaseDate = appDelegate.dic_ValueforRegisterItem["purchase_date"] as? String ?? ""
        let str_serialNomber = appDelegate.dic_ValueforRegisterItem["serial_number"] as? String ?? ""
        if str_PurchaseDate.trimed() == "" {
            return ("Purchase Date","Please enter purchase date")
        }
        else if str_serialNomber.trimed() == "" {
            return ("Serial number","Please enter serial number")
        }
        return nil
    }
    
    

    // MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: UIControl) {
        self.view.endEditing(true)
        if self.screenFrom == ScreenType.is_firstInfo {
            let objInfo = Story_Main.instantiateViewController(withIdentifier: "ItemInfoFirstSecondPartVC") as! ItemInfoFirstSecondPartVC
            objInfo.screenFrom = ScreenType.is_secondInfo
            self.navigationController?.pushViewController(objInfo, animated: true)
        }
        else if self.screenFrom == ScreenType.is_secondInfo {
            if let error = checkInputValidationsForSecondStep() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                let objInfo = Story_Main.instantiateViewController(withIdentifier: "ItemInfoFirstSecondPartVC") as! ItemInfoFirstSecondPartVC
                objInfo.screenFrom = ScreenType.is_thirdInfo
                self.navigationController?.pushViewController(objInfo, animated: true)
            }
        }
        else {
            let price_range = appDelegate.dic_ValueforRegisterItem["price_range"] as? String ?? ""
            if price_range.trimed() == "" {
                showSingleAlert(Title: "Price Range", Message: "Please select price range", buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                let objImage = Story_Main.instantiateViewController(withIdentifier: "AddItemImageVC") as! AddItemImageVC
                self.navigationController?.pushViewController(objImage, animated: true)
            }
        }
    }
}

//MARK: - UICollectionView Delegate Datasource Method
extension ItemInfoFirstSecondPartVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func manageSection() {
        
        if self.screenFrom == ScreenType.is_firstInfo {
            self.img_thirdIcon.isHidden = true
            self.sement_control.isHidden = true
            self.view_One_Bg.isHidden = false
            self.view_two_Bg.isHidden = false
            self.view_three_Bg.isHidden = false
            self.txt_One.placeholder = "Category"
            self.txt_two.placeholder = "Type"
            self.txt_three.placeholder = "Brand"
            self.txt_One.accessibilityHint = "category"
            self.txt_two.accessibilityHint = "type"
            self.txt_three.accessibilityHint = "brand"
            self.txt_One.textColor = .darkGray
            self.txt_two.textColor = .darkGray
            self.txt_three.textColor = .darkGray
            self.txt_One.isUserInteractionEnabled = false
            self.txt_two.isUserInteractionEnabled = false
            self.txt_three.isUserInteractionEnabled = false
            self.txt_One.text = appDelegate.dic_ValueforRegisterItem["category"] as? String ?? ""
            self.txt_two.text = appDelegate.dic_ValueforRegisterItem["type"] as? String ?? ""
            self.txt_three.text = appDelegate.dic_ValueforRegisterItem["brand"] as? String ?? ""
        }
        else if self.screenFrom == ScreenType.is_secondInfo {
            self.img_thirdIcon.isHidden = true
            self.sement_control.isHidden = true
            self.view_One_Bg.isHidden = false
            self.view_two_Bg.isHidden = false
            self.view_three_Bg.isHidden = false
            self.txt_One.placeholder = "Location"
            self.txt_two.placeholder = "Purchase Date"
            self.txt_three.placeholder = "Serial Number"
            self.txt_One.accessibilityHint = "location"
            self.txt_two.accessibilityHint = "purchase_date"
            self.txt_three.accessibilityHint = "serial_number"
            self.txt_One.textColor = .darkGray
            self.txt_two.textColor = .black
            self.txt_three.textColor = .black
            self.txt_One.isUserInteractionEnabled = false
            self.txt_two.isUserInteractionEnabled = true
            self.txt_three.isUserInteractionEnabled = true
            self.txt_One.text = appDelegate.dic_ValueforRegisterItem["location"] as? String ?? ""
            self.txt_two.text = appDelegate.dic_ValueforRegisterItem["purchase_date"] as? String ?? ""
            self.txt_three.text = appDelegate.dic_ValueforRegisterItem["serial_number"] as? String ?? ""
            //********************************************************************************************//
            //********************************************************************************************//
            //********************************************************************************************//

            //For Purchase Data
            self.purchasedatePicker.datePickerMode = .date
            self.purchasedatePicker.maximumDate = Date()
            self.purchasedatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
            self.didSelectedDate = {(sender) in
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd/MM/yyyy"
                self.txt_two.text = dateFormater.string(from: sender.date)

                //Converted
                dateFormater.dateFormat = "yyyy-MM-dd"
                appDelegate.dic_ValueforRegisterItem["purchase_date"] = dateFormater.string(from: sender.date)
            }
            self.txt_two.addDoneToolbar()
            self.txt_two.inputView = self.purchasedatePicker
            self.txt_two.autocapitalizationType = .none
            //********************************************************************************************//
            //********************************************************************************************//
            //********************************************************************************************//
            
        }
        else {
            self.img_thirdIcon.isHidden = false
            self.sement_control.isHidden = false
            self.view_One_Bg.isHidden = false
            self.view_two_Bg.isHidden = true
            self.view_three_Bg.isHidden = true
            self.txt_One.placeholder = "Price Range"
            self.txt_One.textColor = .black
            self.txt_One.isUserInteractionEnabled = true
            self.txt_One.accessibilityHint = "price_range"
            appDelegate.dic_ValueforRegisterItem["gender"] = "M"
            self.txt_One.text = appDelegate.dic_ValueforRegisterItem["price_range"] as? String ?? ""
            self.sement_control.addTarget(self, action: #selector(changeValue(_:)), for: UIControl.Event.valueChanged)
            //********************************************************************************************//
            //********************************************************************************************//
            //********************************************************************************************//

            //For Price Range
            let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            numberToolbar.barStyle = .default
            numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
            numberToolbar.sizeToFit()
            self.txt_One.inputAccessoryView = numberToolbar
            self.txt_One.inputView = self.pricePicker
            self.didSelectPriceRange = {(str) in
                self.txt_One.text = str
            }
            //********************************************************************************************//
            //********************************************************************************************//
            //********************************************************************************************//
        }
    }
    
    @objc func changeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            appDelegate.dic_ValueforRegisterItem["gender"] = "F"
        }
        else {
            appDelegate.dic_ValueforRegisterItem["gender"] = "F"
        }
    }
    
    
    //MARK: - UIPicker View Delegate Datasource method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrr_PriceRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.pickerDidEndPicking = {(sender) in
            appDelegate.dic_ValueforRegisterItem["price_range"] = self.arrr_PriceRange[row]
            self.didSelectPriceRange!(self.arrr_PriceRange[row])
        }
        return self.arrr_PriceRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.didSelectPriceRange != nil {
            appDelegate.dic_ValueforRegisterItem["price_range"] = self.arrr_PriceRange[row]
            self.didSelectPriceRange!(self.arrr_PriceRange[row])
            
            self.pickerDidEndPicking = {(sender) in
                self.didSelectPriceRange!(self.arrr_PriceRange[row])
            }
        }
    }
    
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
        if pickerDidEndPicking != nil{
            self.pickerDidEndPicking!(self.pricePicker)
        }
    }
    //********************************************************************************************//
    //********************************************************************************************//
    
    
    // MARK: - UITextfield Delegate Method
    @IBAction func datePickerDidSetectDate(_ sender: UIDatePicker){
        if self.didSelectedDate != nil {
            self.didSelectedDate!(sender)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let key = textField.accessibilityHint {
            if key == "purchase_date" {
                if let strTxt = textField.text {
                    var shoowedDate = Date()
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd/MM/yyyy"
                    if strTxt != "" {
                        if let selectedDate = dateFormater.date(from: strTxt) {
                            shoowedDate = selectedDate
                        }
                    }
                    self.purchasedatePicker.date = shoowedDate
                    textField.text = dateFormater.string(from: shoowedDate)
                    
                    //Converted
                    dateFormater.dateFormat = "yyyy-MM-dd"
                    appDelegate.dic_ValueforRegisterItem[key] = dateFormater.string(from: shoowedDate)
                    
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let strText = textField.text {
            if let key = textField.accessibilityHint {
                appDelegate.dic_ValueforRegisterItem[key] = strText.trimed()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let strID = textField.accessibilityHint {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if strID == "purchase_date" {
                let ACCEPTABLE_NUMBERS = "1234567890-/"
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= 10
            }
        }
        return true
    }
}



