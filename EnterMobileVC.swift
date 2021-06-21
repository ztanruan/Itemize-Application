//
//  EnterMobileVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 26/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase

class EnterMobileVC: UIViewController, countryPickDelegate {

    var strUserName = ""
    var strPassword = ""
    var str_CountryCode = ""
    @IBOutlet weak var activity_Indicator: UIActivityIndicatorView!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var lbl_weWillSend: UILabel!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var constraint_Button_Bottom: NSLayoutConstraint!
    @IBOutlet weak var constraint_lblWillSent_TOP: NSLayoutConstraint!
    @IBOutlet weak var constraint_lblOTPVerification_BOTTOM: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txt_Mobile.addDoneToolbar()
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor1 = CAGradientLayer.init(frame: self.btn_Continue.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Continue.backgroundColor = UIColor.init(patternImage: gradientColor1)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let strPhoneCode = getCountryPhonceCode(countryCode)
            self.str_CountryCode = "+\(strPhoneCode)"
            self.lbl_countryCode.text = "+\(strPhoneCode)"
            self.img_flag.image = UIImage.init(named: "\(countryCode).png")
        }
        
        //For Attribute Text
        let newText = NSMutableAttributedString.init(string: "We will send you an One Time Password on this mobile number")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 12
        newText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.init(name: "Optima-Regular", size: 17)!,
                             range: NSRange.init(location: 0, length: newText.length))
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), range: NSRange.init(location: 0, length: newText.length))
        newText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSRange.init(location: 0, length: newText.length))
        
        let textRange = NSString(string: "We will send you an One Time Password on this mobile number")
        let termrange = textRange.range(of: "One Time Password")
        
        newText.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Optima-Regular", size: 17)!, range: termrange)
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: termrange)
        //self.lbl_weWillSend.attributedText = newText
    }
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userinfo:NSDictionary = (notification.userInfo as NSDictionary?) {
            if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let bottomSafeArea = appDelegate.window?.safeAreaInsets.bottom ?? 0
                //bottomSafeArea = bottomSafeArea + 100
                self.constraint_Button_Bottom.constant = keybordsize.height - 28
                //self.constraint_lblWillSent_TOP.constant = -bottomSafeArea
                //self.constraint_lblOTPVerification_BOTTOM.constant = bottomSafeArea
                debugPrint("keybordsize.height=======>>\(keybordsize.height)")
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraint_lblWillSent_TOP.constant = 8
        self.constraint_Button_Bottom.constant = 22
        self.constraint_lblOTPVerification_BOTTOM.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: - Picked Country
    func selectCountry(screenFrom: String, is_Pick: Bool, selectedCountry: Country?) {
        self.img_flag.image = selectedCountry?.flag
        self.lbl_countryCode.text = selectedCountry?.phoneCode ?? "+1"
        self.str_CountryCode = selectedCountry?.phoneCode ?? "+1"
        self.txt_Mobile.becomeFirstResponder()
    }
    
    //MARK: - Firebase Mobile Auth
    func firebase_Auth() {
        self.activity_Indicator.startAnimating()
        //ShowProgressHud(message: AppMessage.plzWait)
        let strMobileNumbr = self.txt_Mobile.text ?? ""
        if self.str_CountryCode.count > 0 && strMobileNumbr.count > 0 {
            let number = self.str_CountryCode + strMobileNumbr
            PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                ShowProgressHud(message: AppMessage.plzWait)
                if error != nil {
                    DismissProgressHud()
                    self.activity_Indicator.stopAnimating()
                    print("Error while sending confirmation code = \(error?.localizedDescription ?? "")")
                    showSingleAlert(Title: "", Message: "\(error?.localizedDescription ?? "")", buttonTitle: AppMessage.Ok, completion: { })
                    return
                }
                else {
                    print("Confirmation code did sent  = \(verificationID ?? "")")
                    DispatchQueue.main.async {
                        if let verification_ID = verificationID {
                            DismissProgressHud()
                            self.activity_Indicator.stopAnimating()
                            let objOTP = Story_Main.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
                            objOTP.strMobileNo = strMobileNumbr
                            objOTP.strCountryCode = self.str_CountryCode
                            objOTP.verificationID = verification_ID
                            objOTP.strUserName = self.strUserName
                            objOTP.strPassword = self.strPassword
                            objOTP.imgFlag = self.img_flag.image!
                            self.navigationController?.pushViewController(objOTP, animated: true)
                        }
                    }
                }
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
    
    // MARK: - UIButton Method Action
    
    @IBAction func btncountrycode_Action(_ sender: UIButton) {
        let objCountry = Story_Main.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        objCountry.delegate = self
        self.navigationController?.pushViewController(objCountry, animated: true)
    }
    
    @IBAction func btnGenerateOTP_Action(_ sender: UIControl) {
        let str_Mobile = self.txt_Mobile.text ?? ""
        if str_Mobile == "" {
            showSingleAlert(Title: "Mobile Number", Message: "Please enter a mobile number.", buttonTitle: AppMessage.Ok, delegate: self) { }
            return
        }
        else {
            print("Login With Phone")
            //Check This Number is Already registered in another account
            self.activity_Indicator.startAnimating()
            let fullMobile = "\(self.str_CountryCode) \(str_Mobile)"
            FirebaseManager.shared.MobileNumberAlreadyExistsFirebaseStorage(fullMobile, completion: {is_MobileExists in
                if is_MobileExists {
                    self.activity_Indicator.stopAnimating()
                    self.view.makeToast("Mobile number already exists")
                }
                else {
                    self.firebase_Auth()
                }
            })
        }
        
        //let objCode = Story_Main.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
        //self.navigationController?.pushViewController(objCode, animated: true)
    }

}
