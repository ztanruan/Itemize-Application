//
//  AdminVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 17/06/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class AdminVC: UIViewController {

    @IBOutlet weak var view_TopHeaderBG: UIView!
    @IBOutlet weak var btn_Category: UIControl!
    @IBOutlet weak var btn_Logout: UIControl!
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_Category.cornerRadius = 5
        
        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
        if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Category.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Category.backgroundColor = UIColor.init(patternImage: gradientColor)
        }
        
        if let gradientColor = CAGradientLayer.init(frame: self.btn_Logout.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
            self.btn_Logout.backgroundColor = UIColor.init(patternImage: gradientColor)
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
    
    //MARK: - UIButton Method Action
    @IBAction func btnCategory_Action(_ sender: UIControl) {
        let objAdminCat = Story_Main.instantiateViewController(withIdentifier: "AdminCategoryListingVC") as! AdminCategoryListingVC
        objAdminCat.screenFrom = ScreenType.is_AdminCategory
        self.navigationController?.pushViewController(objAdminCat, animated: true)
    }
    
    @IBAction func btnLogout_Action(_ sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name.init("CREDITIALBLANKNOTIFICATION"), object: nil)
    }

}



