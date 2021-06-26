//
//  CountryPickerVC.swift
//  RedButton
//
//  Created by Zignuts Technolab on 30/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import UIKit


protocol countryPickDelegate {
    func selectCountry(screenFrom: String, is_Pick: Bool, selectedCountry: Country?)
}


class CountryPickerVC: UIViewController,UITextFieldDelegate, UISearchBarDelegate {

    var delegate: countryPickDelegate?
    var is_screenFrom = ""
    var selectedValue = ""
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tblCountry: UITableView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var txt_SearchBar: UISearchBar!
    @IBOutlet weak var viewPopupBottomLayout: NSLayoutConstraint!
    
    var arrCountry = [Country]()
    var iscountryPicker = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
           txt_SearchBar.layer.borderWidth = 1
           txt_SearchBar.layer.borderColor = UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1).cgColor
        
        self.txt_SearchBar.delegate = self
        self.txt_SearchBar.setWhitebackground_color()
        self.txt_SearchBar.placeholder = "Search your country"
        self.tblCountry.tableFooterView = UIView(frame: .zero)
        self.txt_SearchBar.change(textFont: UIFont.init(name: "Optima-Regular", size: 15))
        
        arrCountry =  SMCountry.shared.getAllCountry(withreload: true)
        tblCountry.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
            self.txt_SearchBar.barTintColor = UIColor.init(patternImage: gradientColor)
        }
    }
    
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        let userinfo:NSDictionary = (notification.userInfo as NSDictionary?)!
        if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomSafeArea = appDelegate.window?.safeAreaInsets.bottom ?? 0
            self.viewPopupBottomLayout.constant = (keybordsize.height - bottomSafeArea)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        self.viewPopupBottomLayout.constant = 0
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FUNCTIONS
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - UISearchbar delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tblCountry.reloadData()
    }
}

extension CountryPickerVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func getfiltered() -> [Country]? {

        if self.txt_SearchBar.text == "" || txt_SearchBar.text == nil{
            return arrCountry
        }
        
        if let strSearch = txt_SearchBar.text {
            return arrCountry.filter { (objcon) -> Bool in
                if let name = objcon.name {
                    return (name.lowercased().range(of: strSearch.lowercased()) != nil)
                }
                return false
            }
        }

        return arrCountry
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getfiltered()!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: contryTableCell = tableView.dequeueReusableCell(withIdentifier: "contryTableCell") as! contryTableCell
        cell.selectionStyle = .none

        let Country = getfiltered()![indexPath.row]
        cell.img_flag.image = Country.flag
        
        if iscountryPicker == true {
            cell.lbl_CountryName.text = Country.name ?? ""
            cell.lbl_CountryCode.text  = self.is_screenFrom != "" ? "" : Country.code
        }else{
            cell.lbl_CountryName.text = Country.name! + "(\(Country.code!))"
            cell.lbl_CountryCode.text  = self.is_screenFrom != "" ? "" : Country.phoneCode
        }
        
        cell.img_Seleced.image = self.selectedValue == Country.name! ? #imageLiteral(resourceName: "Successfully") : nil

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let Country = getfiltered()![indexPath.row]
        self.delegate?.selectCountry(screenFrom: self.is_screenFrom, is_Pick: true, selectedCountry: Country)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


//MARK: - UITABLE Cell
class contryTableCell: UITableViewCell {
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_CountryName: UILabel!
    @IBOutlet weak var lbl_CountryCode: UILabel!
    @IBOutlet weak var img_Seleced: UIImageView!
}
