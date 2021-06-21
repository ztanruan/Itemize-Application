//
//  AddCatTypeBrandDetailsVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 17/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddCatTypeBrandDetailsVC: UIViewController {

    var imgAdd = false
    var selectedID: String = ""
    var ref: DatabaseReference!
    var screenFrom = ScreenType.none
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Save: UIControl!
    @IBOutlet weak var viewImgProduceBG: UIView!
    @IBOutlet weak var img_Product: UIImageView!
    @IBOutlet weak var txt_Value: UITextField!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Save.cornerRadius = 5
        self.imagePicker.delegate = self
        ref = Database.database().reference()
        
        if self.screenFrom == ScreenType.is_AdminCategory {
            self.lbl_Title.text = "Add Category"
            self.txt_Value.placeholder = "Enter Category Name"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryType {
            self.lbl_Title.text = "Add Type"
            self.txt_Value.placeholder = "Enter Type Name"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
            self.lbl_Title.text = "Add Brand"
            self.txt_Value.placeholder = "Enter Brand Name"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
            self.lbl_Title.text = "Add Location"
            self.txt_Value.placeholder = "Enter Location Name"
        }
        
        
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Save.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Save.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
    }
    
    //MARK: Upload image
    func ImageUpload_onFirebaseStorage(_ img: UIImage, selectID: String, diccc: [String: Any]) {
        var dic_type = diccc
        if let uploadImgData = img.jpegData(compressionQuality: 0.25) {
            let storageRef = Storage.storage().reference().child("category_image").child("\(randomString()).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            storageRef.putData(uploadImgData, metadata: metadata) { [weak self] (metadata, error) in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    guard self != nil else { return }
                    storageRef.downloadURL(completion: { (url, error) in
                        DispatchQueue.main.async {
                            if let strImgurl = url?.absoluteString {
                                DismissProgressHud()
                                debugPrint("Upload Image URL======>>\(url?.absoluteString ?? "")")
                                dic_type["image"] = strImgurl
                                
                                if self?.screenFrom == ScreenType.is_AdminCategory {
                                    self?.ref.child("category").childByAutoId().updateChildValues(dic_type)
                                }
                                else if self?.screenFrom == ScreenType.is_AdminCategoryType {
                                    self?.ref.child("category").child(self?.selectedID ?? "").child("types").childByAutoId().updateChildValues(dic_type)
                                }
                                else if self?.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
                                    let cateid = appDelegate.dic_valueforAddCatInAdmin["category_id"] as? String ?? ""
                                    let typeid = appDelegate.dic_valueforAddCatInAdmin["type_id"] as? String ?? ""
                                    self?.ref.child("category").child(cateid).child("types").child(typeid).child("brand").childByAutoId().updateChildValues(dic_type)
                                }
                                else if self?.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
                                    let cateid = appDelegate.dic_valueforAddCatInAdmin["category_id"] as? String ?? ""
                                    let typeid = appDelegate.dic_valueforAddCatInAdmin["type_id"] as? String ?? ""
                                    let brandid = appDelegate.dic_valueforAddCatInAdmin["brand_id"] as? String ?? ""
                                    self?.ref.child("category").child(cateid).child("types").child(typeid).child("brand").child(brandid).child("location").childByAutoId().updateChildValues(dic_type)
                                }
                                self?.navigationController?.popViewController(animated: true)
                                NotificationCenter.default.post(name: NSNotification.Name.init("CATEGORYDATAREFRESHNOTIFICATION"), object: nil)
                            }
                        }
                    })
                }
            }
        }
    }
    
    //MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd_PictureAction(_ sender: UIButton) {
        self.openImagePicker()
    }
    
    @IBAction func btnSave_Action(_ sender: UIControl) {
        self.view.endEditing(true)
        var strKey = ""
        var strMsginText = ""
        let str_CatName = self.txt_Value.text ?? ""
        if self.screenFrom == ScreenType.is_AdminCategory {
            strKey = "types"
            strMsginText = "category"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryType {
            strKey = "brand"
            strMsginText = "type"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrand {
            strKey = "location"
            strMsginText = "brand"
        }
        else if self.screenFrom == ScreenType.is_AdminCategoryTypeBrandLocation {
            strKey = ""
            strMsginText = "location"
        }
        
        
        if self.imgAdd == false {
            showSingleAlert(Title: "", Message: "Please select \(strMsginText) image", buttonTitle: AppMessage.Ok, delegate: self) { }
            return
        }
        
        if str_CatName.trimed() == "" {
            showSingleAlert(Title: "", Message: "Please enter \(strMsginText) name", buttonTitle: AppMessage.Ok, delegate: self) { }
            return
        }
        
        
        //Save in Firebase
        var param_Category = [String: Any]()
        if strKey != "" {
            param_Category[strKey] = ""
        }
        param_Category["id"] = randomString(length: 9)
        param_Category["title"] = str_CatName.trimed()
        if let img = self.img_Product.image {
            ShowProgressHud(message: AppMessage.plzWait)
            self.ImageUpload_onFirebaseStorage(img, selectID: selectedID, diccc: param_Category)
        }
    }
}


//MARK: - UIImagePicker View Delegate Datasource method

extension AddCatTypeBrandDetailsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
                self.imagePicker.allowsEditing = true
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
            presenter.sourceView = self.viewImgProduceBG
            presenter.sourceRect = self.viewImgProduceBG.frame
        }
        appDelegate.window?.rootViewController?.present(imageAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let PickedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.imgAdd = true
                self.img_Product.image = PickedImage
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
    
    
}
