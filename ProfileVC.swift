//
//  ProfileVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 23/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import AlamofireImage

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var ref: DatabaseReference!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_TotalItm: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    let imagePicker = UIImagePickerController()
    
    var arrSections:[[String:Any?]] = [[String:Any?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        self.imagePicker.delegate = self
        ref = Database.database().reference()
        let str_profile = GetUserNameEmail("profile")
        let email = GetUserNameEmail("email")
        let fName = GetUserNameEmail("firstName")
        let fullName = "\(fName)"
        self.lbl_Name.text = fullName.capitalized
        self.lbl_Email.text = email
        self.lbl_TotalItm.text = "\(appDelegate.int_TotalItem)"
        
        if str_profile != "" {
            self.imgProfile.kf.setImage(with: URL(string: str_profile))
            //self.imgProfile.sd_setImage(with: URL(string: str_profile), placeholderImage: #imageLiteral(resourceName: "icon_Default_user"))
        }
        

        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        manageSections()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.lbl_TotalItm.text = "\(appDelegate.int_TotalItem)"
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        //Open Full Image View Click Event
//        if let image = self.imgProfile.image, image != #imageLiteral(resourceName: "icon_Default_user") {
//            SMPhotoViewer.showImage(toView: self, image: image, fromView: self.imgProfile)
//        }
        
        self.openImagePicker()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Upload Profile picture
    func UplosdProfileImage_onFirebaseStorage(_ img: UIImage) {
        if let uploadImgData = img.jpegData(compressionQuality: 0.25) {
            let storageRef = Storage.storage().reference().child("profile_image").child("\(randomString()).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            storageRef.putData(uploadImgData, metadata: metadata) { [weak self] (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                guard self != nil else { return }
                storageRef.downloadURL(completion: { (url, error) in
                    if let strImgurl = url?.absoluteString {
                        DismissProgressHud()
                        debugPrint("Upload Image URL======>>\(strImgurl)")
                        self?.imgProfile.image = img
                        FirebaseManager.shared.UpdateProfilePictureInFromFirebaseStorage(strImgurl, completion: {
                        })
                    }
                })
            }
        }
    }
    
    //MARK: - UIImagePicker View Delegate Datasource method
    
    func openImagePicker() {
        
        let imageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            
            imageAlert.dismiss(animated: true, completion: nil)
        })
        
        let Capture = UIAlertAction.init(title: "Take Photo", style: .destructive, handler: { (action) in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .rear
                self.imagePicker.showsCameraControls = true
                self.imagePicker.allowsEditing = true
            }
            else {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
            }
            appDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chosefromlib = UIAlertAction.init(title: "Choose Photo", style: .default, handler: { (action) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            appDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)

        })
        
        imageAlert.addAction(Capture)
        imageAlert.addAction(chosefromlib)
        imageAlert.addAction(cancel)
        
        if let presenter = imageAlert.popoverPresentationController {
            presenter.sourceView = self.imgProfile
            presenter.sourceRect = self.imgProfile.frame
        }
        appDelegate.window?.rootViewController?.present(imageAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let PickedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                ShowProgressHud(message: AppMessage.plzWait)
                self.UplosdProfileImage_onFirebaseStorage(PickedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }

}

//MARK: - UITableView Delegate Datasource Method
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func manageSections() {
                
        self.arrSections.removeAll()

        //self.arrSections.append(["key":"profile_Header", "title":"Profile", "identity": "profile_Header", "sub_section": 0])
        //self.arrSections.append(["key": "label", "title": "GENERAL", "identity": "general", "sub_section": 0])
        
      self.arrSections.append(["key": "account_security", "title": "Account Security", "subtitle": "Change your security settings", "identity": "options", "image": "lock2"])
             self.arrSections.append(["key": "profile_setting", "title": "Profile Settings", "subtitle": "Update and modify your profile", "identity": "options", "image": "settings2"])
             self.arrSections.append(["key": "privacy", "title": "Privacy", "subtitle": "Change your password", "identity": "options", "image": "protection2"])
             self.arrSections.append(["key": "notifications", "title": "Notifications", "subtitle": "Change your notification settings", "identity": "options", "image": "bell2"])
             self.arrSections.append(["key": "Verification", "title": "Verify Account", "subtitle": "Proof of your identity", "identity": "options", "image": "id2"])
             self.arrSections.append(["key": "help_feedback", "title": "Help & Feedback", "subtitle": "Get help and feedback for us", "identity": "options", "image": "help2"])

        self.tblView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSections.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionDetail = self.arrSections[indexPath.row]
        let strIdenty = sectionDetail["identity"] as? String ?? ""

        if strIdenty == "profile_Header" {
            let cell: profileFirstTableCell = tableView.dequeueReusableCell(withIdentifier: "profileFirstTableCell", for: indexPath) as! profileFirstTableCell
            cell.selectionStyle = .none
            
            return cell
        }
        else if strIdenty == "general" {
            let cell: profileSeconTableCell = tableView.dequeueReusableCell(withIdentifier: "profileSeconTableCell", for: indexPath) as! profileSeconTableCell
            cell.selectionStyle = .none
            
            return cell
        }
        else {
            let cell: profileThisrdTableCell = tableView.dequeueReusableCell(withIdentifier: "profileThisrdTableCell", for: indexPath) as! profileThisrdTableCell
            cell.selectionStyle = .none
            cell.btnOnOff_switch?.isHidden = true
            let img = UIImage(named: (sectionDetail["image"]) as! String)
                      cell.iconImage.image = img
            cell.lbl_Title.text = sectionDetail["title"] as? String ?? ""
            cell.lbl_Subtitle.text = sectionDetail["subtitle"] as? String ?? ""
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let sectionDetail = self.arrSections[indexPath.row]
            let strKey = sectionDetail["key"] as? String ?? ""
            let strTitleeeee = sectionDetail["title"] as? String ?? ""
            if strKey == "privacy" {
                let objPrivacy = Story_Main.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
                objPrivacy.strTitle = strTitleeeee.uppercased()
                self.navigationController?.pushViewController(objPrivacy, animated: true)
            }
            
            else if strKey == "Verification" {
                let objPrivacy = Story_Main.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                objPrivacy.strTitle = strTitleeeee.uppercased()
                self.navigationController?.pushViewController(objPrivacy, animated: true)
            }
            else if strKey == "help_feedback" {
                let objPrivacy = Story_Main.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
                objPrivacy.strTitle = strTitleeeee.uppercased()
                self.navigationController?.pushViewController(objPrivacy, animated: true)
        }
        
    }
}



//MARK:- UITableView Cell
class profileFirstTableCell: UITableViewCell {
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_ProfileBG: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_totalItem: UILabel!
    @IBOutlet weak var lbl_totalItem_Title: UILabel!
    @IBOutlet weak var lbl_InsuranceCoverage: UILabel!
    @IBOutlet weak var lbl_InsuranceCoverage_Title: UILabel!
}

class profileSeconTableCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
}

class profileThisrdTableCell: UITableViewCell {
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_ImgBG: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Subtitle: UILabel!
    @IBOutlet weak var btnOnOff_switch: UISwitch!
    @IBOutlet weak var iconImage: UIImageView!

    var didTappedinSwitchButton: ((UISwitch)->Void)? = nil
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
     }
    
    
    @IBAction func btn_SwitchOn_Off(_ sender: UISwitch) {
        if self.didTappedinSwitchButton != nil {
            self.didTappedinSwitchButton!(sender)
        }
    }
    
}
