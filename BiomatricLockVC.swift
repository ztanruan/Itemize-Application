//
//  BiomatricLockVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 11/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class BiomatricLockVC: UIViewController {

    var strUserName = ""
    var strPassword = ""
    let touchMe = BiometricIDAuth()
    let biometricAuthentication = BiometricAuthentication()


    
    @IBOutlet weak var btnTitle: UILabel!
     @IBOutlet weak var DescriptionLabel: UILabel!
     @IBOutlet weak var skipButton: UIButton!
     @IBOutlet weak var TurnOnLabel: UIButton!
    
    
    @IBOutlet weak var btn_On: UIControl!
    @IBOutlet weak var btn_Skip: UIControl!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.TurnOnLabel.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.TurnOnLabel.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        let biometric_type = touchMe.biometricType()
        UserDefaults.appSetObject(self.strPassword, forKey: AppMessage.passworddddd)
        self.btnTitle.text = biometric_type == BiometricType.faceID  ? "Turn on Face id" : "Turn on Touch id"
    }
    
    private func saveAccountDetailsToKeychain(userName: String, password: String) {
        guard !userName.isEmpty, !password.isEmpty else { return }
        UserDefaults.standard.set(userName, forKey: "lastAccessedUserName")
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
            
            UserDefaults.appSetObject(userName, forKey: "user_name")
            UserDefaults.appSetObject(password, forKey: "password")
            UserDefaults.appSetObject(true, forKey: AppMessage.is_biometricLock)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        } catch {
            print("Error saving password")
        }
    }
    
    private func callLoggedIn(userName: String, password: String) {
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        LoginService.callLogInService(userName: self.strUserName, password: self.strPassword, successBlock: { [weak self] in
            self?.saveAccountDetailsToKeychain(userName: self?.strUserName ?? "", password: self?.strPassword ?? "")
        }) {
            // handle failure case
        }
    }
    
    @IBAction func btnSkip_Action(_ sender: UIButton) {
        UserDefaults.appRemoveObjectForKey(AppMessage.is_biometricLock)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

