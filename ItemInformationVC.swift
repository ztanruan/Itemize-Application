//
//  ItemInformationVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 01/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class ItemInformationVC: UIViewController {

    var dic_Data = [String: Any]()
    var arrSection = [[String: Any]]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var constraint_tblViewBottom: NSLayoutConstraint!
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
                let keyboardHeight = keybordsize.height - bottomSafeArea - 74
                self.constraint_tblViewBottom.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraint_tblViewBottom.constant = 0
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

    // MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: UIControl) {
        self.view.endEditing(true)
        appDelegate.dic_ValueforRegisterItem = self.dic_Data
        let objImage = Story_Main.instantiateViewController(withIdentifier: "AddItemImageVC") as! AddItemImageVC
        self.navigationController?.pushViewController(objImage, animated: true)
        //For Category Selection
        //showSingleAlert(Title: "Type", Message: "Please select one option", buttonTitle: AppMessage.Ok, delegate: self) { }
        //return
    }
}

//MARK: - UICollectionView Delegate Datasource Method
extension ItemInformationVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func manageSection() {
        
        self.dic_Data["gender"] = "M"
        
        self.arrSection.removeAll()
        self.arrSection.append(["key":"info_Header", "title":"Profile", "identity": "info_Header"])
        self.arrSection.append(["key": "category", "title": "Category", "placeholder": "Category", "identity": "textfield"])
        self.arrSection.append(["key": "type", "title": "Type", "placeholder": "Type", "identity": "textfield"])
        self.arrSection.append(["key": "brand", "title": "Brand", "placeholder": "Brand", "identity": "textfield"])
        self.arrSection.append(["key": "location", "title": "Location", "placeholder": "Location", "identity": "textfield"])
        self.arrSection.append(["key": "purchase_date", "title": "Purchase Date", "placeholder": "Purchase Date", "identity": "textfield"])
        self.arrSection.append(["key": "serial_number", "title": "Serial Number", "placeholder": "Serial Number", "identity": "textfield"])
        self.arrSection.append(["key": "price_range", "title": "Price Range", "placeholder": "Price Range", "identity": "textfield"])
        self.arrSection.append(["key": "gender", "title": "", "placeholder": "", "identity": "segment_control"])

        self.tblView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = self.arrSection[indexPath.row]
        let key = dic["key"] as? String ?? ""
        let strIdenty = dic["identity"] as? String ?? ""
        
        if strIdenty == "info_Header" {
            let cell: ItemHeaderTableCell = tableView.dequeueReusableCell(withIdentifier: "ItemHeaderTableCell", for: indexPath) as! ItemHeaderTableCell
            cell.selectionStyle = .none
            
            return cell
        }
        else if strIdenty == "segment_control" {
            let cell: SegmentTableCell = tableView.dequeueReusableCell(withIdentifier: "SegmentTableCell", for: indexPath) as! SegmentTableCell
            cell.selectionStyle = .none

            cell.sement_control.addTarget(self, action: #selector(changeValue(_:)), for: UIControl.Event.valueChanged)
            
            return cell
        }
        else {
            let cell: ItemTableCell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath) as! ItemTableCell
            cell.img_icon.image = nil
            cell.selectionStyle = .none
            cell.txt_fild.delegate = self
            cell.txt_fild.accessibilityHint = key
            cell.view_Base.backgroundColor = .white
            cell.txt_fild.placeholder = dic["placeholder"] as? String ?? ""
            cell.txt_fild.text = self.dic_Data[key] as? String ?? ""
            
            if key == "category" || key == "type" || key == "brand" || key == "location" {
                cell.txt_fild.textColor = .darkGray
                cell.txt_fild.isUserInteractionEnabled = false
            }
            else {
                cell.txt_fild.textColor = .black
                cell.txt_fild.isUserInteractionEnabled = true
            }
            
            
            if key == "purchase_date" {
                cell.img_icon.image = nil
                self.purchasedatePicker.datePickerMode = .date
                self.purchasedatePicker.maximumDate = Date()
                self.purchasedatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
                self.didSelectedDate = {(sender) in
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd/MM/yyyy"
                    cell.txt_fild.text = dateFormater.string(from: sender.date)
                    
                    //Converted
                    dateFormater.dateFormat = "yyyy-MM-dd"
                    self.dic_Data[key] = dateFormater.string(from: sender.date)
                }
                cell.txt_fild.addDoneToolbar()
                cell.txt_fild.inputView = self.purchasedatePicker
                cell.txt_fild.autocapitalizationType = .none
                cell.txt_fild.isUserInteractionEnabled = true
            }
            else if key == "price_range" {

                cell.img_icon.image = #imageLiteral(resourceName: "icon_bottom-arrow")
                let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                numberToolbar.barStyle = .default
                numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
                    numberToolbar.sizeToFit()
                cell.txt_fild.inputAccessoryView = numberToolbar
                cell.txt_fild.inputView = self.pricePicker
                self.didSelectPriceRange = {(str) in
                    cell.txt_fild.text = str
                }
            }
            else {
                cell.img_icon.image = nil
            }
            
            
            return cell
        }
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func changeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.dic_Data["gender"] = "F"
        }
        else {
            self.dic_Data["gender"] = "F"
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
            self.dic_Data["price_range"] = self.arrr_PriceRange[row]
            self.didSelectPriceRange!(self.arrr_PriceRange[row])
        }
        return self.arrr_PriceRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.didSelectPriceRange != nil {
            self.dic_Data["price_range"] = self.arrr_PriceRange[row]
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
                    self.dic_Data[key] = dateFormater.string(from: shoowedDate)
                    
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
                self.dic_Data[key] = strText.trimed()
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


//MARK: - UITable Cell
class ItemHeaderTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_center: UIImageView!
    @IBOutlet weak var lbl_subTitle: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ItemTableCell: UITableViewCell {
    
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var txt_fild: UITextField!
    @IBOutlet weak var img_icon: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SegmentTableCell: UITableViewCell {
    
    @IBOutlet weak var sement_control: UISegmentedControl!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


