//
//  TabbarVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 23/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var lastSelectIndex = 0
    var arr_Selectedimage = [#imageLiteral(resourceName: "icon_home_selected"), #imageLiteral(resourceName: "icon_resource_selected"), nil, #imageLiteral(resourceName: "icon_lock_selected"), #imageLiteral(resourceName: "icon_profile_selected")]
    var arr_UnSelectedimage = [#imageLiteral(resourceName: "icon_home_unselected"), #imageLiteral(resourceName: "icon_resource_unselected"), nil, #imageLiteral(resourceName: "icon_lock_unselected"), #imageLiteral(resourceName: "icon_profile_unselected")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Image For Bottom Tab
        self.delegate = self
        self.lastSelectIndex = 0
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arr_Selectedimage[i]
                let imageNameForUnselectedState = arr_UnSelectedimage[i]
                let unselectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)]
                let selectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
                
                self.tabBar.items?[i].setTitleTextAttributes(unselectedItemColor, for: .normal)
                self.tabBar.items?[i].setTitleTextAttributes(selectedItemColor, for: .selected)
                self.tabBar.items?[i].selectedImage = imageNameForSelectedState?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageNameForUnselectedState?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let imageCameraButton: UIImage! = #imageLiteral(resourceName: "icon_add")
        let getBlankButtonWidth = imageCameraButton.size.width + 40
        let getBlankButtonHeight = imageCameraButton.size.height + 40
        // Creates a Blank Button
        let cameraButton1 = UIButton(type: .custom)
        cameraButton1.frame = CGRect(x: ((screenWidth/2) - (getBlankButtonWidth/2)), y: ((screenHeight - (appDelegate.window?.safeAreaInsets.bottom ?? 0)) - getBlankButtonHeight) + 12 , width: getBlankButtonWidth, height: getBlankButtonHeight);
        cameraButton1.setBackgroundImage(nil, for: .normal)
        self.view.addSubview(cameraButton1)


        // Creates a Button
        let cameraButton = UIButton(type: .custom)
        // Sets width and height to the Button
        cameraButton.frame = CGRect(x: ((screenWidth/2) - (imageCameraButton.size.width/2)), y: ((screenHeight - (appDelegate.window?.safeAreaInsets.bottom ?? 0)) - imageCameraButton.size.height/7) - imageCameraButton.size.height , width: imageCameraButton.size.width, height: imageCameraButton.size.height);
        // Sets image to the Button
        cameraButton.setBackgroundImage(imageCameraButton, for: UIControl.State.normal)
        // Sets an action to the Button
        cameraButton.addTarget(self, action: #selector(clkToSelectCategory), for: .touchUpInside)

        // Adds the Button to the view
        self.view.addSubview(cameraButton)
        self.view.bringSubviewToFront(cameraButton)
        
        
        //Get Profile Data
        FirebaseManager.shared.GetUserNameEmailFromFirebaseStorage(GetUserID(), completion: {
            print("Data get from database")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arr_Selectedimage[i]
                let imageNameForUnselectedState = arr_UnSelectedimage[i]
                let unselectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)]
                let selectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
                
                self.tabBar.items?[i].setTitleTextAttributes(unselectedItemColor, for: .normal)
                self.tabBar.items?[i].setTitleTextAttributes(selectedItemColor, for: .selected)
                self.tabBar.items?[i].selectedImage = imageNameForSelectedState?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageNameForUnselectedState?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func clkToSelectCategory() {
        let objCategory = Story_Main.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        self.navigationController?.pushViewController(objCategory, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        if selectedViewController != nil && viewController != selectedViewController {
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(tabBarController.selectedIndex)
        if selectedViewController != nil && viewController != selectedViewController {
            UIView.transition(from: (selectedViewController?.view)!, to: viewController.view, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, completion: { (finished) in
            })
        }
        return true
    }
}




















