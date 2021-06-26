//
//  RegisterVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 30/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var NameTextField: UITextField!
    // @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    // @IBOutlet weak var RePasswordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.SignUpButton.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.SignUpButton.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        
        let bottomLine = CALayer()
        let bottomLine1 = CALayer()
        let bottomLine2 = CALayer()
        let bottomLine3 = CALayer()
        let bottomLine4 = CALayer()
        bottomLine.frame = CGRect(x: 0, y: NameTextField.frame.height - 2, width: NameTextField.frame.width, height: 2)
        //   bottomLine1.frame = CGRect(x: 0, y: lastNameTextField.frame.height - 2, width: lastNameTextField.frame.width, height: 2)
        bottomLine2.frame = CGRect(x: 0, y: EmailTextField.frame.height - 2, width: EmailTextField.frame.width, height: 2)
        bottomLine3.frame = CGRect(x: 0, y: PasswordTextField.frame.height - 2, width: PasswordTextField.frame.width, height: 2)
        //      bottomLine4.frame = CGRect(x: 0, y: RePasswordTextField.frame.height - 2, width: RePasswordTextField.frame.width, height: 2)
        
        
        
        
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
        bottomLine1.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
        bottomLine2.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
        bottomLine3.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
        bottomLine4.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
        
        NameTextField.borderStyle = .none
        NameTextField.backgroundColor = .none
        
        //   lastNameTextField.borderStyle = .none
        //   lastNameTextField.backgroundColor = .none
        
        
        EmailTextField.borderStyle = .none
        EmailTextField.backgroundColor = .none
        
        PasswordTextField.borderStyle  = .none
        PasswordTextField.backgroundColor = .none
        
        
        // RePasswordTextField.borderStyle = .none
        //  RePasswordTextField.backgroundColor = .none
        
        
        
        
        //   lastNameTextField.layer.addSublayer(bottomLine1)
        NameTextField.layer.addSublayer(bottomLine)
        EmailTextField.layer.addSublayer(bottomLine2)
        PasswordTextField.layer.addSublayer(bottomLine3)
        //     RePasswordTextField.layer.addSublayer(bottomLine4)
        
        
        ref = Database.database().reference()
    }
    
    
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        
        
        self.view.endEditing(true)
        if let error = checkInputValidations() {
            //Invalid data
            showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
        }
        else {
            print("Register")
            self.register_Action()
        }
        
    }
    
    
    
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    // MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    func checkInputValidations() -> (Title:String,Message:String)? {
        let fName = NameTextField.text
        // let lName = lastNameTextField.text
        let email = EmailTextField.text
        let password = PasswordTextField.text
        //   let repassword = RePasswordTextField.text
        
        
        if fName?.trimed() == nil || fName?.trimed() == "" {
            return ("First Name","Please enter first name.")
        }
            //      else if lName?.trimed() == nil || lName?.trimed() == "" {
            //          return ("Last Name","Please enter last name.")
            //      }
        else if email?.trimed() == nil || email?.trimed() == "" {
            return ("Email","Please enter email")
        }
        else if !isValidEmail(email: email?.trimed() ?? "") {
            return ("Email","Please enter a valid email")
        }
        else if password?.trimed() == nil || password?.trimed() == "" {
            return ("Password","Please enter password")
        }
        
        //     else if repassword?.trimed() == nil || repassword?.trimed() == "" {
        //         return ("Password","Please enter password")
        //      }
        
        //    else if PasswordTextField.text != RePasswordTextField.text {
        //        return ("Password","Password does not match")
        //  }
        
        return nil
    }
    
    
    //MARK: - Register Method
    func register_Action() {
        ShowProgressHud(message: AppMessage.plzWait)
        let email = EmailTextField.text ?? ""
        let password = PasswordTextField.text ?? ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                DismissProgressHud()
                if AuthErrorCode.init(rawValue: error.code) == .emailAlreadyInUse {
                    showSingleAlert(Title: "", Message: "Email is already exists", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .weakPassword {
                    showSingleAlert(Title: "", Message: "The password must be 6 characters long or more", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else {
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("User signs up successfully")
                let userData = ["login_with": "normal",
                                "email": self.EmailTextField.text ?? "",
                                "firstName": self.NameTextField.text ?? ""]
                //          "lastName": self.dic_Value["last_name"] as? String ?? ""]
                let newUserInfo = Auth.auth().currentUser
                if let user = newUserInfo {
                    self.login_Action()
                    self.ref.child("users").child(user.uid).updateChildValues(userData)
                }
            }
        }
    }
    
    // MARK: - Login
    func login_Action() {
        let email = self.EmailTextField.text ?? ""
        let password = self.PasswordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            DismissProgressHud()
            if let error = error as NSError? {
                if AuthErrorCode.init(rawValue: error.code) == .userNotFound {
                    showSingleAlert(Title: "", Message: "This email is not register,\nPlease sign up", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .wrongPassword {
                    showSingleAlert(Title: "", Message: "Password wrong", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else {
                    print("Error: \(error.localizedDescription)")
                }
            }
            else {
                print("User signs in successfully")
                if let curretAuth = Auth.auth().currentUser {
                    UserDefaults.appSetObject(curretAuth.uid, forKey: AppMessage.uID)
                    FirebaseManager.shared.GetUserNameEmailFromFirebaseStorage(curretAuth.uid) {
                        DismissProgressHud()
                        let objEnterMobile = Story_Main.instantiateViewController(withIdentifier: "EnterMobileVC") as! EnterMobileVC
                        objEnterMobile.strUserName = email
                        objEnterMobile.strPassword = password
                        self.navigationController?.pushViewController(objEnterMobile, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - UIButton Method Action
    @IBAction func btnAlreadyHaveAccount(_ sender: UIButton) {
        let objlogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objlogin, animated: true)
    }
    
    
    
}


