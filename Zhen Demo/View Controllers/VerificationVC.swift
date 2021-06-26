//
//  VerificationVC.swift
//  Zhen Demo
//
//  Created by Jin on 7/5/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import Foundation
import UIKit

class VerificationVC: UIViewController {


        var strTitle = ""
      @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_TopHeaderBG: UIView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.\
            self.lbl_title.text = self.strTitle
            
        
            
        

            let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
            if let gradientColor = CAGradientLayer.init(frame: self.view_TopHeaderBG.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
                self.view_TopHeaderBG.backgroundColor = UIColor.init(patternImage: gradientColor)
            }
            
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

        //MARK: - UITableView Delegate Datasource Method
        @IBAction func btnBack_Action(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
    }
