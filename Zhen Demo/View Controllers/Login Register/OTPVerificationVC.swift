//
//  OTPVerificationVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 26/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OTPVerificationVC: UIViewController {

    var is_One = false
    var is_two = false
    var is_three = false
    var is_four = false
    var is_five = false
    var is_Six = false
    var arrOTP = [String]()
    var arr_Numbers = [String]()
    var strCountryCode = ""
    var strMobileNo = ""
    var verificationID = ""
    
    var timer: Timer?
    var totalTime = 59
    var strUserName = ""
    var strPassword = ""
    @IBOutlet weak var activity_Indicator: UIActivityIndicatorView!
    @IBOutlet weak var lbl_Timer: UILabel!
    @IBOutlet weak var view_one: UIControl!
    @IBOutlet weak var view_two: UIControl!
    @IBOutlet weak var view_three: UIControl!
    @IBOutlet weak var view_four: UIControl!
    @IBOutlet weak var view_five: UIControl!
    @IBOutlet weak var view_six: UIControl!
    @IBOutlet weak var lbl_one: UILabel!
    @IBOutlet weak var lbl_two: UILabel!
    @IBOutlet weak var lbl_three: UILabel!
    @IBOutlet weak var lbl_four: UILabel!
    @IBOutlet weak var lbl_five: UILabel!
    @IBOutlet weak var lbl_six: UILabel!
    @IBOutlet weak var btn_Confirm: UIControl!
    @IBOutlet weak var btn_resendCode: UIButton!
    @IBOutlet weak var lbl_ResendCode: UILabel!
    @IBOutlet weak var img_ResendCode: UIImageView!
    @IBOutlet weak var lbl_codeSendWithMobile: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.is_One = true
        self.btn_resendCode.isHidden = true
        self.lbl_ResendCode.textColor = UIColor.lightGray
        self.img_ResendCode.setImageColor(color: UIColor.lightGray)
        
        
        self.lbl_one.textColor = UIColor.black
        self.view_one.backgroundColor = UIColor.white
        self.arr_Numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "X"]
        self.collectionView.reloadData()
        
        
        //Set Puzzle Time
        self.lbl_Timer.text = "00:59"
        self.startOtpTimer()
        
        
        //Screen Background Color
        let coloss1 = [#colorLiteral(red: 0.337254902, green: 0.4, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.7960784314, alpha: 1)]
        if let gradientColor1 = CAGradientLayer.init(frame: self.view.frame, colors: coloss1, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view.backgroundColor = UIColor.init(patternImage: gradientColor1)
        }
        
        //Confirm Button Color
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Confirm.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Confirm.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        
        //For Attribute Text
        let firstCharacter = self.strMobileNo[self.strMobileNo.startIndex]
        let last2Character = String(self.strMobileNo.suffix(2))
        
        let enterText = "\(self.strCountryCode) \(firstCharacter)******\(last2Character)"
        
        let newText = NSMutableAttributedString.init(string: "code sent to \(enterText)")
        newText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.init(name: "Optima-Regular", size: 15)!,
                             range: NSRange.init(location: 0, length: newText.length))
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), range: NSRange.init(location: 0, length: newText.length))
        
        let textRange = NSString(string: "code sent to \(enterText)")
        let termrange = textRange.range(of: enterText)
        
        newText.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Optima-Bold", size: 16)!, range: termrange)
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), range: termrange)
        self.lbl_codeSendWithMobile.attributedText = newText
        
    }
    
    func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        self.lbl_Timer.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.btn_resendCode.isHidden = false
                self.lbl_ResendCode.textColor = UIColor.white
                self.img_ResendCode.setImageColor(color: UIColor.white)
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
                self.btn_resendCode.isHidden = true
                self.lbl_ResendCode.textColor = UIColor.lightGray
                self.img_ResendCode.setImageColor(color: UIColor.lightGray)
                if let verification_ID = verificationID {
                    self.verificationID = verification_ID
                }
            }
        }
    }
    
    
    
    //MARK: - UIButton Method
    @IBAction func btnResendCode_Action(_ sender: UIButton) {
        self.arrOTP.removeAll()
        self.is_One = true
        self.is_two = false
        self.is_three = false
        self.is_four = false
        self.is_five = false
        self.is_Six = false
        self.lbl_one.text = "-"
        self.lbl_two.text = "-"
        self.lbl_three.text = "-"
        self.lbl_four.text = "-"
        self.lbl_five.text = "-"
        self.lbl_six.text = "-"
        self.lbl_one.textColor = UIColor.black
        self.lbl_two.textColor = UIColor.white
        self.lbl_three.textColor = UIColor.white
        self.lbl_four.textColor = UIColor.white
        self.lbl_five.textColor = UIColor.white
        self.lbl_six.textColor = UIColor.white
        self.view_one.backgroundColor = UIColor.white
        self.view_two.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view_three.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view_four.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view_five.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view_six.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.firebase_AuthforResendCode()
    }
    
    
    @IBAction func btnComfirm_Action(_ sender: UIControl) {
        if self.arrOTP.count != 0 {
            if self.arrOTP.count < 6 {
                showSingleAlert(Title: "OTP", Message: "Please enter otp", buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                ShowProgressHud(message: "Verifying...")
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.arrOTP.joined())
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
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - UICollectionView Delegate Datasource Method
extension OTPVerificationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_Numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: verificationNumbersCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "verificationNumbersCollectionCell", for: indexPath) as! verificationNumbersCollectionCell
        
        cell.btn_Number.backgroundColor = UIColor.clear
        let str_Numbers = self.arr_Numbers[indexPath.row]
        cell.lbl_numbers.text = str_Numbers

        if str_Numbers == "X" {
            cell.img_close.image = #imageLiteral(resourceName: "icon_delete")
            cell.lbl_numbers.isHidden = true
        }
        else {
            cell.img_close.image = nil
            cell.lbl_numbers.isHidden = false
        }
        
        //Did Number Tapped
        cell.btn_Number.tag = indexPath.row
        cell.btn_Number.addTarget(self, action: #selector(self.holdRelease(sender:)), for: .touchUpInside);
        cell.btn_Number.addTarget(self, action: #selector(self.HoldDown(sender:)), for: .touchDown)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (screenWidth - 50)/3, height: 50)
    }
    
    //target functions
    @objc func HoldDown(sender: UIControl) {
        if let currentCell = collectionView.cellForItem(at: IndexPath.init(row: sender.tag, section: 0)) as? verificationNumbersCollectionCell  {
            if let currentTappedNumber = currentCell.lbl_numbers.text {
                if currentTappedNumber == "" {
                    
                }
                else if currentTappedNumber == "X" {
                    if self.arrOTP.count != 0 {
                        currentCell.img_close.image = #imageLiteral(resourceName: "icon_delete_black")
                        currentCell.lbl_numbers.textColor = UIColor.black
                        currentCell.btn_Number.backgroundColor = UIColor.white
                    }
                }
                else {
                    if self.arrOTP.count != 6 {
                        currentCell.lbl_numbers.textColor = UIColor.black
                        currentCell.btn_Number.backgroundColor = UIColor.white
                    }
                }
            }
        }
    }

    @objc func holdRelease(sender: UIControl) {
        if let currentCell = collectionView.cellForItem(at: IndexPath.init(row: sender.tag, section: 0)) as? verificationNumbersCollectionCell  {
            currentCell.lbl_numbers.textColor = UIColor.white
            currentCell.btn_Number.backgroundColor = UIColor.clear
            if let currentTappedNumber = currentCell.lbl_numbers.text {
                if currentTappedNumber == "" {
                }
                else if currentTappedNumber == "X" {
                    if self.arrOTP.count != 0 {
                        currentCell.img_close.image = #imageLiteral(resourceName: "icon_delete")
                        if self.arrOTP.count == 1 {
                            self.is_One = true
                            self.is_two = false
                            self.is_three = false
                            self.is_four = false
                            self.is_five = false
                            self.is_Six = false
                            self.lbl_one.text = "-"
                            self.arrOTP.remove(at: 0)
                            self.lbl_one.textColor = UIColor.black
                            self.lbl_two.textColor = UIColor.white
                            self.view_one.backgroundColor = UIColor.white
                            self.view_two.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        }
                        else if self.arrOTP.count == 2 {
                            self.is_One = false
                            self.is_two = true
                            self.is_three = false
                            self.is_four = false
                            self.is_five = false
                            self.is_Six = false
                            self.lbl_two.text = "-"
                            self.arrOTP.remove(at: 1)
                            self.lbl_two.textColor = UIColor.black
                            self.lbl_three.textColor = UIColor.white
                            self.view_two.backgroundColor = UIColor.white
                            self.view_three.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        }
                        else if self.arrOTP.count == 3 {
                            self.is_One = false
                            self.is_two = false
                            self.is_three = true
                            self.is_four = false
                            self.is_five = false
                            self.is_Six = false
                            self.lbl_three.text = "-"
                            self.arrOTP.remove(at: 2)
                            self.lbl_four.textColor = UIColor.white
                            self.lbl_three.textColor = UIColor.black
                            self.view_three.backgroundColor = UIColor.white
                            self.view_four.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        }
                        else if self.arrOTP.count == 4 {
                            self.is_One = false
                            self.is_two = false
                            self.is_three = false
                            self.is_four = true
                            self.is_five = false
                            self.is_Six = false
                            self.lbl_four.text = "-"
                            self.arrOTP.remove(at: 3)
                            self.lbl_five.textColor = UIColor.white
                            self.lbl_four.textColor = UIColor.black
                            self.view_four.backgroundColor = UIColor.white
                            self.view_five.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        }
                        else if self.arrOTP.count == 5 {
                            self.is_One = false
                            self.is_two = false
                            self.is_three = false
                            self.is_four = false
                            self.is_five = true
                            self.is_Six = false
                            self.lbl_five.text = "-"
                            self.arrOTP.remove(at: 4)
                            self.lbl_six.textColor = UIColor.white
                            self.lbl_five.textColor = UIColor.black
                            self.view_five.backgroundColor = UIColor.white
                            self.view_six.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                        }
                        else if self.arrOTP.count == 6 {
                            self.is_One = false
                            self.is_two = false
                            self.is_three = false
                            self.is_four = false
                            self.is_five = false
                            self.is_Six = true
                            self.lbl_six.text = "-"
                            self.arrOTP.remove(at: 5)
                            self.lbl_six.textColor = UIColor.black
                            self.view_six.backgroundColor = UIColor.white
                        }
                    }
                }
                else {
                    if self.is_One {
                        self.is_One = false
                        self.is_two = true
                        self.is_three = false
                        self.is_four = false
                        self.is_five = false
                        self.is_Six = false
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_one.text = currentCell.lbl_numbers.text ?? ""
                        self.view_two.backgroundColor = UIColor.white
                        self.lbl_two.textColor = UIColor.black
                        self.lbl_one.textColor = UIColor.white
                        self.view_one.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                    else if self.is_two {
                        self.is_One = false
                        self.is_two = false
                        self.is_three = true
                        self.is_four = false
                        self.is_five = false
                        self.is_Six = false
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_two.text = currentCell.lbl_numbers.text ?? ""
                        self.view_three.backgroundColor = UIColor.white
                        self.lbl_three.textColor = UIColor.black
                        self.lbl_two.textColor = UIColor.white
                        self.view_two.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                    else if self.is_three {
                        self.is_One = false
                        self.is_two = false
                        self.is_three = false
                        self.is_four = true
                        self.is_five = false
                        self.is_Six = false
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_three.text = currentCell.lbl_numbers.text ?? ""
                        self.view_four.backgroundColor = UIColor.white
                        self.lbl_four.textColor = UIColor.black
                        self.lbl_three.textColor = UIColor.white
                        self.view_three.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                    else if self.is_four {
                        self.is_One = false
                        self.is_two = false
                        self.is_three = false
                        self.is_four = false
                        self.is_five = true
                        self.is_Six = false
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_four.text = currentCell.lbl_numbers.text ?? ""
                        self.view_five.backgroundColor = UIColor.white
                        self.lbl_five.textColor = UIColor.black
                        self.lbl_four.textColor = UIColor.white
                        self.view_four.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                    else if self.is_five {
                        self.is_One = false
                        self.is_two = false
                        self.is_three = false
                        self.is_four = false
                        self.is_five = false
                        self.is_Six = true
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_five.text = currentCell.lbl_numbers.text ?? ""
                        self.view_six.backgroundColor = UIColor.white
                        self.lbl_six.textColor = UIColor.black
                        self.lbl_five.textColor = UIColor.white
                        self.view_five.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                    else if self.is_Six {
                        self.is_One = false
                        self.is_two = false
                        self.is_three = false
                        self.is_four = false
                        self.is_five = false
                        self.is_Six = false
                        self.arrOTP.append(currentTappedNumber)
                        self.lbl_six.text = currentCell.lbl_numbers.text ?? ""
                        self.lbl_six.textColor = UIColor.white
                        self.view_six.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    }
                }
            }
        }
    }
}






//MARK:- Slider Collection Cell
class verificationNumbersCollectionCell: UICollectionViewCell {

    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var btn_Number: UIControl!
    @IBOutlet weak var lbl_numbers: UILabel!
    @IBOutlet weak var img_close: UIImageView!
    
    var didNumberTapped: ((UIControl)->Void)? = nil
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btn_Number_Action(_ sender: UIControl) {
        if self.didNumberTapped != nil {
            self.didNumberTapped!(sender)
        }
    }
}

