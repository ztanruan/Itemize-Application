//
//  IntroSliderVC.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 25/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit

class IntroSliderVC: UIViewController {
    
    var selectedIndex = 0
    var arrSection = [[String: Any]]()
    @IBOutlet weak var btn_Next: UIControl!
    @IBOutlet weak var btn_Skip: UIControl!
    @IBOutlet weak var lbl_NextButtonTitle: UILabel!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraint_btnNextBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.groupTableViewBackground
        self.manageSection()
        
//        let coloss = [#colorLiteral(red: 0.9960784314, green: 0.6549019608, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3529411765, blue: 0.04705882353, alpha: 1)]
//        if let gradientColor = CAGradientLayer.init(frame: self.btn_Skip.frame, colors: coloss, direction: GradientDirection.Bottom).creatGradientImage() {
//            self.btn_Skip.backgroundColor = UIColor.init(patternImage: gradientColor)
//        }
   }

    
    //MARK: - UIButton Method Action
    @IBAction func btnNext_Action(_ sender: UIControl) {
        if  selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 2 || selectedIndex == 3   {
            self.collectionView.scrollToItem(at: IndexPath.init(row: selectedIndex + 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        else {
            UserDefaults.appSetObject(true, forKey: AppMessage.intro_Slider)
            let objLogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(objLogin, animated: true)
        }
    }
    
    
    @IBAction func btnSkip_Action(_ sender: UIControl) {
        UserDefaults.appSetObject(true, forKey: AppMessage.intro_Slider)
        let objLogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objLogin, animated: true)
    }
}

//MARK: - UICollectionView Delegate Datasource Method
extension IntroSliderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func manageSection() {
        
        
        self.arrSection.removeAll()
        self.arrSection.append(["title": "Protect What's Yours", "sub_title": "Itemize is your verification to the products you purchase. We’ll help you store important product information and provide the right resources to protect what’s yours", "image": #imageLiteral(resourceName: "OnBoarding11")])
        self.arrSection.append(["title": "Bar Code Integration", "sub_title": "Easily access purchase history and product information with Bar Code integration", "image": #imageLiteral(resourceName: "OnBoarding15")])
        self.arrSection.append(["title": "Insurance Coverage", "sub_title":  "We make it easy to learn about insurance and how to protect your items in the resources page", "image": #imageLiteral(resourceName: "OnBoarding13")])
        self.arrSection.append(["title": "Privacy Protection", "sub_title":  "Protect what is yours and provide proof of purchase without the worry", "image": #imageLiteral(resourceName: "OnBoarding14")])
        self.arrSection.append(["title": "Biometrics Protection", "sub_title":  "We use encryption to protect your account information. Touch and Face ID is integrated to access your itemized list", "image": #imageLiteral(resourceName: "OnBoarding12")])
        self.collectionView.reloadData()
        
        self.pagecontrol.numberOfPages = self.arrSection.count
    }
    
    // MARK: - CHANGING PAGE NUMBER
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect.init(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint.init(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleindex = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.selectedIndex = visibleindex.row
            self.pagecontrol.currentPage = visibleindex.row
            if visibleindex.row == (self.arrSection.count - 1) {
                self.btn_Skip.isHidden = true
                self.lbl_NextButtonTitle.text = "Continue"
                self.constraint_btnNextBottom.constant = 0
            }
            else {
                self.btn_Skip.isHidden = false
                self.lbl_NextButtonTitle.text = "Next"
                self.constraint_btnNextBottom.constant = 12
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: sliderCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCollectionCell", for: indexPath) as! sliderCollectionCell
        
        let dic = self.arrSection[indexPath.row]
        
        cell.lbl_Title.text = dic["title"] as? String ?? ""
        let str_subTitle = dic["sub_title"] as? String ?? ""
        cell.img_Center.image =  dic["image"] as? UIImage ?? #imageLiteral(resourceName: "car")
        cell.lbl_TermsConditions.text = "By continuing you agree to the Terms & conditions"
        
        if indexPath.row == (self.arrSection.count - 1) {
            cell.lbl_TermsConditions.isHidden = false
        }
        else {
            cell.lbl_TermsConditions.isHidden = true
        }
        
        
        //For Attribute Text
        let newText1 = NSMutableAttributedString.init(string: str_subTitle)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = .center
        paragraphStyle1.lineSpacing = 2
        newText1.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.init(name: "KohinoorBangla-Regular", size: 16)!,
                             range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle1, range: NSRange.init(location: 0, length: newText1.length))
        cell.lbl_subTitle.attributedText = newText1
        
        //For Attribute Text
        let newText = NSMutableAttributedString.init(string: "By continuing you agree to the Terms & Conditions")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        newText.addAttribute(NSAttributedString.Key.font,
                             value: UIFont.init(name: "KohinoorBangla-Regular", size: 16)!,
                             range: NSRange.init(location: 0, length: newText.length))
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: NSRange.init(location: 0, length: newText.length))
        newText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSRange.init(location: 0, length: newText.length))
        
        let textRange = NSString(string: "By continuing you agree to the Terms & Conditions")
        let termrange = textRange.range(of: "Terms & Conditions")
        
        newText.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Optima-Regular", size: 16)!, range: termrange)
        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.368627451, green: 0.5764705882, blue: 0.8980392157, alpha: 1), range: termrange)
        cell.lbl_TermsConditions.attributedText = newText
        
        //Did Next Tapped
        cell.didNextTapped = { (sender) in
            if indexPath.row == 0 || indexPath.row == 1 {
                self.collectionView.scrollToItem(at: IndexPath.init(row: indexPath.row + 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            }
            else {
                let objLogin = Story_Main.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                self.navigationController?.pushViewController(objLogin, animated: true)
            }
        }
        
        //Did Skip Tapped
        cell.didSkipTapped = { (sender) in
            let objLogin = Story_Main.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
            self.navigationController?.pushViewController(objLogin, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: screenWidth, height: collectionView.bounds.height)
    }
    
}


//MARK:- Slider Collection Cell
class sliderCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var lbl_TermsConditions: UILabel!
    @IBOutlet weak var img_Center: UIImageView!
    @IBOutlet weak var btn_Next: UIControl!
    @IBOutlet weak var btn_Skip: UIControl!
    @IBOutlet weak var lbl_NextButtonTitle: UILabel!
    @IBOutlet weak var constraint_btnNextBottom: NSLayoutConstraint!
    
    var didNextTapped: ((UIControl)->Void)? = nil
    var didSkipTapped: ((UIControl)->Void)? = nil
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btn_Next_Action(_ sender: UIControl) {
        if self.didNextTapped != nil {
            self.didNextTapped!(sender)
        }
    }
    
    @IBAction func btn_Skip_Action(_ sender: UIControl) {
        if self.didSkipTapped != nil {
            self.didSkipTapped!(sender)
        }
    }
}

