//
//  ForgotPassworVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 30/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassworVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
               
               view.addGestureRecognizer(tap)
               self.EmailTextField.delegate = self
               
               
               
               let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
               if let gradientColor = CAGradientLayer.init(frame: self.ResetButton.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
                   self.ResetButton.backgroundColor = UIColor.init(patternImage: gradientColor)
               }
               
               let bottomLine = CALayer()
               bottomLine.frame = CGRect(x: 0, y: EmailTextField.frame.height - 2, width: EmailTextField.frame.width, height: 2)
               bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 1).cgColor
               EmailTextField.borderStyle = .none
               EmailTextField.backgroundColor = .none
               
               EmailTextField.layer.addSublayer(bottomLine)
    }
    

    @IBAction func ResetBUttonPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        if let error = checkInputValidations() {
            //Invalid data
            showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
        }
        else {
            self.forgotPasword_Action()
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let objlogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objlogin, animated: true)
        
        
    }
    
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    
    
    
    //MARK: - Check Validation
    func checkInputValidations() -> (Title:String,Message:String)? {
        let str_email = self.EmailTextField.text ?? ""
        if str_email.trimed() == "" {
            return ("Email","Please enter email")
        }
        else if !isValidEmail(email: str_email.trimed() ) {
            return ("Email","Please enter a valid email")
        }
        return nil
    }
    
    //MARK: - Register Method
    func forgotPasword_Action() {
        ShowProgressHud(message: AppMessage.plzWait)
        let email = self.EmailTextField.text ?? ""

        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            DismissProgressHud()
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
                    showSingleAlert(Title: "", Message: "\(error.localizedDescription)", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.view.makeToast("Reset password email has been successfully sent")
            }
        }
    }
    
}
    
    

  
