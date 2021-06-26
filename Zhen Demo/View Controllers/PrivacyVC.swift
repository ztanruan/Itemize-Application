//
//  PrivacyVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 27/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import LocalAuthentication

class PrivacyVC: UIViewController {

    var strTitle = ""
    var app_LoginPassword = ""
    var is_BiometricLock = false
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    var arrSections:[[String:Any?]] = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        self.lbl_title.text = self.strTitle
        
        if UserDefaults.appObjectForKey(AppMessage.is_biometricLock) != nil {
            let is_Onnn = UserDefaults.appObjectForKey(AppMessage.is_biometricLock) as? Bool ?? false
            self.is_BiometricLock = is_Onnn
        }
        else {
            self.is_BiometricLock = false
        }
        
        //For Password
        if UserDefaults.appObjectForKey(AppMessage.passworddddd) != nil {
            self.app_LoginPassword = UserDefaults.appObjectForKey(AppMessage.passworddddd) as? String ?? ""
        }

        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        manageSections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UITableView Delegate Datasource Method
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableView Delegate Datasource Method
extension PrivacyVC: UITableViewDelegate, UITableViewDataSource {
    
    func manageSections() {
                
        self.arrSections.removeAll()

        self.arrSections.append(["key": "biometric", "title": "Biometrics", "subtitle": "Enable faceID or Finger", "identity": "options"])

        self.tblView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSections.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: profileThisrdTableCell = tableView.dequeueReusableCell(withIdentifier: "profileThisrdTableCell", for: indexPath) as! profileThisrdTableCell
        cell.selectionStyle = .none
        cell.btnOnOff_switch?.isHidden = true
        
        let sectionDetail = self.arrSections[indexPath.row]
        let keyy = sectionDetail["key"] as? String ?? ""
        if keyy == "biometric" {
            
            cell.btnOnOff_switch?.isHidden = false
            cell.btnOnOff_switch?.isOn = self.is_BiometricLock
            
            
            //Switch Button Function
            cell.didTappedinSwitchButton = { (sender) in
                if self.is_BiometricLock {
                    self.is_BiometricLock = false
                    cell.btnOnOff_switch?.isOn = false
                    UserDefaults.appRemoveObjectForKey(AppMessage.is_biometricLock)
                }
                else {
                    self.is_BiometricLock = true
                    cell.btnOnOff_switch?.isOn = true
                    
                    DispatchQueue.main.async {
                        LoginService.callLogInService(userName: GetUserNameEmail("email"), password: self.app_LoginPassword, successBlock: { [weak self] in
                            self?.saveAccountDetailsToKeychain(userName: GetUserNameEmail("email"), password: self!.app_LoginPassword)
                        }) {
                            // handle failure case
                            UserDefaults.appRemoveObjectForKey(AppMessage.is_biometricLock)
                        }
                    }
                }
            }
        }
        else {
            cell.btnOnOff_switch?.isHidden = true
        }

        cell.lbl_Title.text = sectionDetail["title"] as? String ?? ""
        cell.lbl_Subtitle.text = sectionDetail["subtitle"] as? String ?? ""

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func saveAccountDetailsToKeychain(userName: String, password: String) {
        guard !userName.isEmpty, !password.isEmpty else { return }
        UserDefaults.standard.set(userName, forKey: "lastAccessedUserName")
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
            UserDefaults.appSetObject(true, forKey: AppMessage.is_biometricLock)
        } catch {
            print("Error saving password")
            UserDefaults.appSetObject(false, forKey: AppMessage.is_biometricLock)
        }
    }
}



//MARK:- UITableView Cell
