//
//  EnterOTPVC.swift
//  Cotasker
//
//  Created by Zignuts Technolab on 22/10/19.
//  Copyright © 2019 Pearl Inc. All rights reserved.
//

import UIKit
import Firebase
import SVPinView
import FirebaseAuth

class EnterOTPVC: UIViewController, UITextFieldDelegate {
    
    var imgFlag = UIImage()
    var str_enteredOTP = ""
    var strMobileNo = ""
    var strCountryCode = ""
    var verificationID = ""
    var strSubScreen = ""
    var timer: Timer?
    var totalTime = 59
    var strUserName = ""
    var strPassword = ""
    var screenFrom = ScreenType.none
    var screenFromRecheck = ScreenType.none
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var btn_Back: UIButton!
    //@IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var lbl_mobileNo: UILabel!
    @IBOutlet weak var constraint_viewBottom: NSLayoutConstraint!
    @IBOutlet weak var activity_Indicator: UIActivityIndicatorView!
    @IBOutlet weak var btn_Verify: UIControl!
    @IBOutlet weak var btn_resendCode: UIButton!
    @IBOutlet weak var img_Flag: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePinView()
        self.img_Flag.image = self.imgFlag
        self.btn_resendCode.isUserInteractionEnabled = false
        self.btn_resendCode.setTitleColor(UIColor.lightGray, for: .normal)
        self.lbl_mobileNo.text = "\(self.strCountryCode) \(self.strMobileNo)"
        
       // self.lbl_Timer.text = "00:59"
        self.startOtpTimer()
        
        //Confirm Button Color
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Verify.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Verify.backgroundColor = UIColor.init(patternImage: gradientColor)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        //self.lbl_Timer.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.btn_resendCode.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1), for: .normal)
                self.btn_resendCode.isUserInteractionEnabled = true
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func firebase_AuthforResendCode() {
        self.activity_Indicator.startAnimating()
        //ShowProgressHud(message: AppMessage.plzWait)
        let number = strCountryCode + strMobileNo
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            DismissProgressHud()
            self.activity_Indicator.stopAnimating()
            if error != nil {
                print("Error while sending confirmation code = \(error?.localizedDescription ?? "")")

                showSingleAlert(Title: "", Message: "\(error?.localizedDescription ?? "")", buttonTitle: AppMessage.Ok, completion: {
                })
                return
            }
            else {
                print("Confirmation code did sent  = \(verificationID ?? "")")
                self.view.makeToast("OTP sent successfully!")
                self.totalTime = 59
                self.startOtpTimer()
                self.btn_resendCode.isUserInteractionEnabled = false
                self.btn_resendCode.setTitleColor(UIColor.lightGray, for: .normal)
                if let verification_ID = verificationID {
                    self.verificationID = verification_ID
                }
            }
        }
    }


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK:- KEYBOARD METHODS
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userinfo:NSDictionary = (notification.userInfo as NSDictionary?) {
            if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.constraint_viewBottom.constant = (keybordsize.height/2) + 40
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraint_viewBottom.constant = 22
        self.view.layoutIfNeeded()
    }
    
    func configurePinView() {
        self.pinView.style = .box
        self.pinView.pinLength = 6
        self.pinView.interSpace = 5
        self.pinView.placeholder = "------"
        self.pinView.borderLineThickness = 1
        self.pinView.keyboardType = .phonePad
        self.pinView.shouldSecureText = false
        self.pinView.allowsWhitespaces = false
        self.pinView.secureCharacter = "\u{25CF}"
        self.pinView.activeBorderLineThickness = 1
        self.pinView.isContentTypeOneTimeCode = true
        self.pinView.becomeFirstResponderAtIndex = 0
        self.pinView.font = UIFont.init(name: "Optima-Regular", size: 16)!
        self.pinView.borderLineColor = UIColor.lightGray
        self.pinView.fieldBackgroundColor = UIColor.white
        self.pinView.activeBorderLineColor = UIColor.lightGray
        self.pinView.activeFieldBackgroundColor = UIColor.white
        
        self.pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        self.pinView.didFinishCallback = didFinishEnteringPin(pin:)
        self.pinView.didChangeCallback = { pin in
            self.str_enteredOTP = pin
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func didFinishEnteringPin(pin:String) {
        self.str_enteredOTP = pin
    }

    // MARK: UIButton Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendOTP_Action(_ sender: UIButton) {
        self.pinView.clearPin()
        self.str_enteredOTP = ""
        self.firebase_AuthforResendCode()
    }
    
    @IBAction func btnComfirm_Action(_ sender: UIControl) {
        if self.str_enteredOTP != "" {
            if self.str_enteredOTP.count < 6 {
                showSingleAlert(Title: "OTP", Message: "Please enter otp", buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                ShowProgressHud(message: "Verifying...")
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.str_enteredOTP)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if error != nil {
                        DismissProgressHud()
                        showSingleAlert(Title: "Error", Message: error?.localizedDescription ?? "Something went wrong", buttonTitle: AppMessage.Ok, completion: { })
                    }
                    else {
                        //Go to Dashboard
                        UserDefaults.appSetObject(true, forKey: AppMessage.login)
                        let fullMobile = "\(self.strCountryCode) \(self.strMobileNo)"
                        FirebaseManager.shared.UpdateMobileNumberInFromFirebaseStorage(fullMobile, completion: {
                            DismissProgressHud()
                            let objBiomatric = Story_Main.instantiateViewController(withIdentifier: "BiomatricLockVC") as! BiomatricLockVC
                            objBiomatric.strUserName = self.strUserName
                            objBiomatric.strPassword = self.strPassword
                            self.navigationController?.pushViewController(objBiomatric, animated: true)
                        })
                        
                    }
                }
            }
        }
        else {
            showSingleAlert(Title: "OTP", Message: "Please enter OTP", buttonTitle: AppMessage.Ok, completion: { })
        }
    }
}

