//
//  FeedbackVC.swift
//  Zhen Demo
//
//  Created by Jin on 7/6/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class FeedbackVC: UIViewController, UITextViewDelegate {
    
    
    var strTitle = ""
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var textView: UITextView!
    var ref =  DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.ref = Database.database().reference()
        // Do any additional setup after loading the view.\
        self.lbl_title.text = self.strTitle
        textView.delegate = self
        textView.text = "Let us know what you think about the app"
        textView.textColor = UIColor.lightGray
        
        
        
        textView.textContainerInset =
            UIEdgeInsets(top: 8,left: 5,bottom: 8,right: 5);
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Let us know what you think about the app"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
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
    @IBAction func submitButtonPressed(_ sender: Any) {
        // Create new Alert
        
        if textView.text != "Let us know what you think about the app" {
            
            let userEmail = Auth.auth().currentUser?.email
            let userID = Auth.auth().currentUser?.uid
            let dict = ["ID": userID, "email": userEmail, "feedback": textView.text]
            self.ref.child("feedback").childByAutoId().setValue(dict)
            
            
            var dialogMessage = UIAlertController(title: "Thank You", message: "We will evaluate your feedback and make changes based on it", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                self.navigationController?.popViewController(animated: true)
                
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
            
            
        }  else {
            
            var dialogMessage = UIAlertController(title: "Sorry", message: "Please let us know your experience with the app", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
            
        }
        
    }
    //MARK: - UITableView Delegate Datasource Method
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
