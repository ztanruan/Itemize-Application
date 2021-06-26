//
//  AddItemImageVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 01/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class AddItemImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var arr_Images = [Any]()
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Continue: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Skip: UIControl!
    let imagePicker = UIImagePickerController()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Continue.cornerRadius = 5
        self.lbl_Title.text = "IMAGES"
        self.imagePicker.delegate = self
        self.collection_view.backgroundColor = .white
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Continue.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Continue.backgroundColor = UIColor.init(patternImage: gradientColor)
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
                self.imagePicker.allowsEditing = false
            }
            else {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
            }
            appDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chosefromlib = UIAlertAction.init(title: "Choose Photo", style: .default, handler: { (action) in
        
            let limit = 6 - self.arr_Images.count
            
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = limit
            imagePicker.settings.theme.selectionStyle = .checked
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = false

            let start = Date()
            self.presentImagePicker(imagePicker, select: { (asset) in
                print("Selected: \(asset)")
            }, deselect: { (asset) in
                print("Deselected: \(asset)")
            }, cancel: { (assets) in
                print("Canceled with selections: \(assets)")
            }, finish: { (assets) in
                print("Finished with selections: \(assets)")
                
                for imageAssets in assets {
                    debugPrint(imageAssets)
                    self.getImageFromAsset(asset: imageAssets, imageSize: CGSize.init(width: 100, height: 100)) { (imageee) in
                        self.arr_Images.append(imageee)
                        self.collection_view.reloadData()
                    }
                }

            }, completion: {
                let finish = Date()
                print(finish.timeIntervalSince(start))
            })
            
        })
        
        imageAlert.addAction(Capture)
        imageAlert.addAction(chosefromlib)
        imageAlert.addAction(cancel)
        
        if let presenter = imageAlert.popoverPresentationController {
            presenter.sourceView = self.collection_view
            presenter.sourceRect = self.collection_view.frame
        }
        appDelegate.window?.rootViewController?.present(imageAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let PickedImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.arr_Images.append(PickedImage)
                self.collection_view.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
    
    func getImageFromAsset(asset:PHAsset,imageSize:CGSize, callback:@escaping (_ result:UIImage) -> Void) -> Void {

        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                callback(UIImage(data: data)!)
            }
        }
        
        
        /*
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (currentImage, info) in
            callback(currentImage!)
        })
        */
    }

    // MARK: - UIButton Method Action
    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue_Action(_ sender: UIControl) {
        if self.arr_Images.count == 0 {
            self.view.makeToast("Please upload images")
            return
        }

        appDelegate.dic_ValueforRegisterItem["item_image"] = self.arr_Images
        let objConfirm = Story_Main.instantiateViewController(withIdentifier: "ConfirmationInfoVC") as! ConfirmationInfoVC
        self.navigationController?.pushViewController(objConfirm, animated: true)
    }
    
    @IBAction func btnSkip_Action(_ sender: UIControl) {
        appDelegate.dic_ValueforRegisterItem["item_image"] = self.arr_Images
        let objConfirm = Story_Main.instantiateViewController(withIdentifier: "ConfirmationInfoVC") as! ConfirmationInfoVC
        self.navigationController?.pushViewController(objConfirm, animated: true)
    }
    
    
    
}

//MARK: - UICollectionView Delegate Datasource Method
extension AddItemImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arr_Images.count == 0 {
            return 1
        }
        else {
            if self.arr_Images.count == 6 {
                return self.arr_Images.count
            }
            else {
                return self.arr_Images.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        if self.arr_Images.count == 6 {
            if let img = self.arr_Images[indexPath.row] as? UIImage {
                cell.img_Center.image = img
                cell.btnDelete.isHidden = false
                cell.btnDelete.tag = indexPath.row
            }
            else {
                cell.img_Center.image = #imageLiteral(resourceName: "Add-512")
                cell.btnDelete.isHidden = true
            }
        }
        else {
            if indexPath.row == 0 {
                cell.img_Center.image = #imageLiteral(resourceName: "Add-512")
                cell.btnDelete.isHidden = true
            }
            else {
                if let img = self.arr_Images[indexPath.row - 1] as? UIImage {
                    cell.img_Center.image = img
                    cell.btnDelete.isHidden = false
                    cell.btnDelete.tag = indexPath.row - 1
                }
                else {
                    cell.img_Center.image = #imageLiteral(resourceName: "Add-512")
                    cell.btnDelete.isHidden = true
                }
            }
        }
        
        //Button Action
        cell.btnDelete.addTarget(self, action: #selector(btn_DeleteImage_Action(_:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (UIScreen.main.bounds.width - 36)/2
        return CGSize.init(width: screenWidth, height: screenWidth)
    }
    
    @objc func btn_DeleteImage_Action(_ sender: UIButton) {
        self.arr_Images.remove(at: sender.tag)
        self.collection_view.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if self.arr_Images.count < 6 {
                self.view.endEditing(true)
                self.openImagePicker()
            }
        }
        
    }
    
}




//MARK: - UITable Cell
class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_inner: UIView!
    @IBOutlet weak var img_Center: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view_Base.layer.cornerRadius = 12
        self.view_inner.layer.cornerRadius = 12
        self.img_Center.layer.cornerRadius = 12
    }
}

